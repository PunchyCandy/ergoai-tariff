import argparse
import json
import os
import shutil
import sys
import tempfile
from contextlib import contextmanager
from typing import Any

from dotenv import load_dotenv

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from rag.ingest import normalize_hs_code, policy_records_to_ergo_facts, retrieve_policy

load_dotenv()

ERGOROOT = os.getenv("ERGOROOT")
XSBARCHDIR = os.getenv("XSBARCHDIR")

if not ERGOROOT or not XSBARCHDIR:
    raise EnvironmentError(
        "Missing ERGOROOT or XSBARCHDIR in .env or environment variables."
    )

ERGO_PY_PATH = os.path.join(ERGOROOT, "python")
if ERGO_PY_PATH not in sys.path:
    sys.path.insert(0, ERGO_PY_PATH)

try:
    from pyergo import pyergo_command, pyergo_end_session, pyergo_query, pyergo_start_session
except Exception as e:
    raise ImportError(
        f"Failed to import ErgoAI Python bindings from "
        f"{ERGO_PY_PATH}. If you're using a virtualenv, "
        "install missing dependencies (e.g., `pip install six`) "
        "or ensure ERGOAI_3.0 is present at the expected path."
    ) from e


BASE_RULE_FILES = [
    "data/products.ergo",
    "data/shipments.ergo",
    "rules/decision.ergo",
]
RUNTIME_SHIPMENT_ID = "runtime_quote"
RUNTIME_PRODUCT_ID = "runtime_product"
FIELD_NAME_MAP = {
    "Shipment": "shipment_id",
    "Origin": "origin",
    "ImportCountry": "import_country",
    "Product": "product_id",
    "Value": "declared_value_usd",
    "Date": "shipment_date",
    "HsCode": "hs_code",
    "Category": "category",
    "Description": "description",
    "DutyUSD": "duty_usd",
    "Rate": "rate",
    "Explanation": "explanation",
}


def term_to_python(term: Any) -> Any:
    if term is None or isinstance(term, (int, float, str, bool)):
        return term
    if isinstance(term, (list, tuple)):
        return [term_to_python(item) for item in term]

    if hasattr(term, "value"):
        try:
            return term_to_python(term.value)
        except Exception:
            return str(term)

    if hasattr(term, "name") and hasattr(term, "args"):
        name = term.name
        if hasattr(name, "value"):
            name = name.value
        args = [term_to_python(arg) for arg in term.args]
        return {"functor": name, "args": args}

    if hasattr(term, "args"):
        try:
            return [term_to_python(arg) for arg in term.args]
        except Exception:
            return str(term)

    return str(term)


def friendly_key(name: str) -> str:
    cleaned = name.lstrip("?")
    return FIELD_NAME_MAP.get(cleaned, cleaned[:1].lower() + cleaned[1:])


def normalize_bindings(payload: Any) -> Any:
    if isinstance(payload, list):
        return [normalize_bindings(item) for item in payload]
    if isinstance(payload, dict):
        return {friendly_key(key): normalize_bindings(value) for key, value in payload.items()}
    return payload


def enrich_result_payload(payload: dict[str, Any]) -> dict[str, Any]:
    result = payload.get("result")
    if isinstance(result, dict):
        if "duty_usd" in result and "total_tariff_amount_usd" not in result:
            result["total_tariff_amount_usd"] = result["duty_usd"]
        if "rate" in result and "total_tariff_rate_percent" not in result:
            result["total_tariff_rate_percent"] = round(float(result["rate"]) * 100, 4)
    return payload


def ergo_atom(value: str) -> str:
    normalized = value.strip().lower().replace("-", "_").replace(" ", "_")
    if not normalized:
        raise ValueError("Expected a non-empty Ergo atom value.")
    for char in normalized:
        if not (char.isalnum() or char == "_"):
            raise ValueError(
                f"Value '{value}' cannot be represented as an Ergo atom without extra escaping."
            )
    return normalized


def ergo_date(value: str) -> str:
    parts = value.strip().split("-")
    if len(parts) != 3:
        raise ValueError("Date must use YYYY-MM-DD format.")

    year, month, day = parts
    try:
        year_i = int(year)
        month_i = int(month)
        day_i = int(day)
    except ValueError as exc:
        raise ValueError("Date must use numeric YYYY-MM-DD values.") from exc

    if not (1 <= month_i <= 12 and 1 <= day_i <= 31):
        raise ValueError("Date must contain a valid month and day.")

    return f"date({year_i},{month_i},{day_i})"


def ergo_number(value: float) -> str:
    return format(float(value), ".10g")


def iso_date(value: Any) -> str:
    if isinstance(value, str):
        return value
    if isinstance(value, dict) and value.get("functor") == "date":
        args = value.get("args", [])
        if len(args) == 3:
            year, month, day = args
            return f"{int(year):04d}-{int(month):02d}-{int(day):02d}"
    raise ValueError(f"Unsupported shipment date format: {value!r}")


def render_runtime_facts(args: argparse.Namespace) -> str:
    origin = ergo_atom(args.origin)
    import_country = ergo_atom(args.import_country)
    product_id = ergo_atom(args.product_id or RUNTIME_PRODUCT_ID)
    value = ergo_number(args.value)
    shipment_date = ergo_date(args.date)

    fact_lines = [
        "/* ---- runtime input ---- */",
        f"shipment({RUNTIME_SHIPMENT_ID}, {origin}, {import_country}, {product_id}, {value}, {shipment_date}).",
    ]

    if args.hs_code:
        hs_code = normalize_hs_code(args.hs_code)
        category = ergo_atom(args.category or "user_defined")
        description = ergo_atom(args.description or "runtime_product")
        hs_label = ergo_atom(args.hs_label or f"label_{hs_code}")
        fact_lines.append(f"product({product_id}, {hs_code}, {category}, {description}).")
        fact_lines.append(f"hs_label({hs_code}, {hs_label}).")

    return "\n".join(fact_lines) + "\n"


def retrieve_runtime_policy(
    *,
    hs_code: str,
    origin: str,
    import_country: str,
    shipment_date: str,
) -> tuple[str, list[dict[str, Any]]]:
    retrieved_policy = retrieve_policy(
        {
            "hts_code": hs_code,
            "origin": origin,
            "import_country": import_country,
            "date": shipment_date,
        }
    )
    if not retrieved_policy:
        raise ValueError(
            f"No HTS policy records were found for HS code '{hs_code}', "
            f"origin '{origin}', import country '{import_country}', and date '{shipment_date}'."
        )

    return policy_records_to_ergo_facts(retrieved_policy), retrieved_policy


def build_combined_kb(base_dir: str, additional_facts: str = "") -> str:
    sections = []
    for relative_path in BASE_RULE_FILES:
        full_path = os.path.join(base_dir, relative_path)
        with open(full_path, "r", encoding="utf-8") as src:
            sections.append(f"/* ---- {full_path} ---- */\n{src.read().rstrip()}\n")

    if additional_facts:
        sections.append(additional_facts.rstrip() + "\n")

    return "\n".join(sections)


@contextmanager
def ergo_session():
    pyergo_start_session(XSBARCHDIR, ERGOROOT)
    try:
        yield
    finally:
        pyergo_end_session()


class TariffApp:
    def __init__(self) -> None:
        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        self.runtime_dir = tempfile.mkdtemp(prefix="ergoai_tariff_", dir=tempfile.gettempdir())
        self.load_count = 0

    def close(self) -> None:
        shutil.rmtree(self.runtime_dir, ignore_errors=True)

    def _next_combined_path(self) -> str:
        self.load_count += 1
        return os.path.join(self.runtime_dir, f"combined_{self.load_count}.ergo")

    def load_kb(self, additional_facts: str = "") -> None:
        combined_kb = build_combined_kb(self.base_dir, additional_facts=additional_facts)
        last_error = None

        # Ergo writes compiled artifacts next to the consulted file, so each load gets
        # its own unique path to avoid stale cache conflicts and cross-process races.
        for _ in range(2):
            combined_path = self._next_combined_path()
            with open(combined_path, "w", encoding="utf-8") as out:
                out.write(combined_kb)
            try:
                pyergo_command(f"['{combined_path}'].")
                return
            except Exception as exc:
                last_error = exc

        if last_error is not None:
            raise last_error

    def query(self, query_text: str) -> list[dict[str, Any]]:
        answers = pyergo_query(query_text)
        results = []
        for answer in answers or []:
            bindings = {name: value for (name, value) in answer[0]}
            results.append(
                normalize_bindings({name: term_to_python(value) for name, value in bindings.items()})
            )
        return results

    def list_shipments(self) -> list[dict[str, Any]]:
        self.load_kb()
        return self.query("shipment(?Shipment, ?Origin, ?ImportCountry, ?Product, ?Value, ?Date).")

    def get_product_catalog(self, additional_facts: str = "") -> list[dict[str, Any]]:
        self.load_kb(additional_facts=additional_facts)
        return self.query("product(?Product, ?HsCode, ?Category, ?Description).")

    def evaluate_shipment_id(self, shipment_id: str) -> dict[str, Any]:
        shipment_atom = ergo_atom(shipment_id)
        self.load_kb()

        shipment_matches = self.query(
            f"shipment({shipment_atom}, ?Origin, ?ImportCountry, ?Product, ?Value, ?Date)."
        )
        if not shipment_matches:
            raise ValueError(f"Shipment '{shipment_id}' was not found.")

        shipment_input = shipment_matches[0]
        product_catalog = self.get_product_catalog()
        product_match = next(
            (item for item in product_catalog if item.get("product_id") == shipment_input.get("product_id")),
            None,
        )
        if not product_match or "hs_code" not in product_match:
            raise ValueError(
                f"Shipment '{shipment_id}' references a product without an HS code mapping."
            )

        retrieved_policy_facts, retrieved_policy = retrieve_runtime_policy(
            hs_code=str(product_match["hs_code"]),
            origin=str(shipment_input["origin"]),
            import_country=str(shipment_input["import_country"]),
            shipment_date=iso_date(shipment_input["shipment_date"]),
        )
        self.load_kb(additional_facts=retrieved_policy_facts)

        duty_matches = self.query(
            f"duty({shipment_atom}, ?DutyUSD, ?Rate, ?Explanation)."
        )
        if not duty_matches:
            raise ValueError(f"No duty result could be derived for shipment '{shipment_id}'.")

        return enrich_result_payload(
            {
                "shipment_id": shipment_atom,
                "input": shipment_input,
                "product": product_match,
                "retrieved_policy": normalize_bindings(retrieved_policy),
                "result": duty_matches[0],
            }
        )

    def evaluate_runtime_input(self, args: argparse.Namespace) -> dict[str, Any]:
        runtime_facts = render_runtime_facts(args)
        runtime_product_id = ergo_atom(args.product_id or RUNTIME_PRODUCT_ID)
        product_catalog = self.get_product_catalog(additional_facts=runtime_facts)
        product_match = next(
            (item for item in product_catalog if item.get("product_id") == runtime_product_id),
            None,
        )
        if not product_match:
            raise ValueError(
                f"Product '{args.product_id}' was not found. "
                "Use an existing product id from app/data/products.ergo or provide --hs-code."
            )

        resolved_hs_code = args.hs_code or str(product_match["hs_code"])
        retrieved_policy_facts, retrieved_policy = retrieve_runtime_policy(
            hs_code=resolved_hs_code,
            origin=args.origin,
            import_country=args.import_country,
            shipment_date=args.date,
        )
        additional_facts = runtime_facts + retrieved_policy_facts
        self.load_kb(additional_facts=additional_facts)

        duty_matches = self.query(
            f"duty({RUNTIME_SHIPMENT_ID}, ?DutyUSD, ?Rate, ?Explanation)."
        )
        if not duty_matches:
            raise ValueError("No duty result could be derived for the provided shipment input.")

        shipment_matches = self.query(
            f"shipment({RUNTIME_SHIPMENT_ID}, ?Origin, ?ImportCountry, ?Product, ?Value, ?Date)."
        )

        result = {
            "shipment_id": RUNTIME_SHIPMENT_ID,
            "input": shipment_matches[0] if shipment_matches else {},
            "result": duty_matches[0],
            "product": {
                "product_id": runtime_product_id,
                **product_match,
            },
        }

        result["retrieved_policy"] = normalize_bindings(retrieved_policy)

        return enrich_result_payload(result)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Evaluate import tariff outcomes with ErgoAI."
    )
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("list", help="List the sample shipments available in app/data/shipments.ergo.")

    sample_parser = subparsers.add_parser(
        "sample",
        help="Evaluate one of the sample shipment ids already stored in the knowledge base.",
    )
    sample_parser.add_argument("shipment_id", help="Shipment id such as s1 or s4.")

    quote_parser = subparsers.add_parser(
        "quote",
        help="Evaluate a shipment provided at the command line.",
    )
    quote_parser.add_argument("--origin", required=True, help="Origin country atom, for example china.")
    quote_parser.add_argument(
        "--import-country",
        default="usa",
        help="Importing country atom. Defaults to usa.",
    )
    quote_parser.add_argument(
        "--product-id",
        help="Existing product id from data/products.ergo, or a custom id when used with --hs-code.",
    )
    quote_parser.add_argument(
        "--hs-code",
        help="Custom HTS code to evaluate. This triggers retrieval from the local HTS policy corpus.",
    )
    quote_parser.add_argument(
        "--category",
        help="Category for a custom runtime product. Used only with --hs-code.",
    )
    quote_parser.add_argument(
        "--description",
        help="Description atom for a custom runtime product. Used only with --hs-code.",
    )
    quote_parser.add_argument(
        "--hs-label",
        help="Optional label atom for a custom HS code. Used only with --hs-code.",
    )
    quote_parser.add_argument("--value", required=True, type=float, help="Declared value in USD.")
    quote_parser.add_argument("--date", required=True, help="Shipment date in YYYY-MM-DD format.")
    quote_parser.add_argument(
        "--json",
        action="store_true",
        help="Print only JSON output.",
    )

    interactive_parser = subparsers.add_parser(
        "interactive",
        help="Prompt for shipment fields in the terminal and evaluate the result.",
    )
    interactive_parser.add_argument(
        "--json",
        action="store_true",
        help="Print only JSON output.",
    )

    return parser


def validate_quote_args(args: argparse.Namespace) -> None:
    if not args.product_id and not args.hs_code:
        raise ValueError("Provide either --product-id for an existing product or --hs-code for a custom product.")
    if args.hs_code is None and (args.category or args.description or args.hs_label):
        raise ValueError("--category, --description, and --hs-label require --hs-code.")


def prompt(text: str, default: str | None = None) -> str:
    suffix = f" [{default}]" if default else ""
    value = input(f"{text}{suffix}: ").strip()
    return value or (default or "")


def run_interactive(app: TariffApp, json_only: bool) -> int:
    product_mode = prompt("Use an existing product id or custom HS code? (product/hs)", "product")
    args = argparse.Namespace(
        origin=prompt("Origin country", "china"),
        import_country=prompt("Import country", "usa"),
        product_id=None,
        hs_code=None,
        category=None,
        description=None,
        hs_label=None,
        value=float(prompt("Declared value USD", "1000")),
        date=prompt("Shipment date YYYY-MM-DD", "2025-11-10"),
    )

    if product_mode == "hs":
        args.product_id = prompt("Product id", RUNTIME_PRODUCT_ID)
        args.hs_code = prompt("HS code", "8517.62")
        args.category = prompt("Category", "electronics")
        args.description = prompt("Description", "runtime_product")
        args.hs_label = prompt("HS label", f"label_{normalize_hs_code(args.hs_code)}")
    else:
        args.product_id = prompt("Existing product id", "p_router")

    validate_quote_args(args)
    result = app.evaluate_runtime_input(args)
    print_output(result, json_only=json_only)
    return 0


def print_output(payload: dict[str, Any] | list[dict[str, Any]], json_only: bool = False) -> None:
    if json_only:
        print(json.dumps(payload, indent=2, sort_keys=True))
        return

    if isinstance(payload, list):
        print(json.dumps(payload, indent=2, sort_keys=True))
        return

    print("Input")
    print(json.dumps(payload.get("input", {}), indent=2, sort_keys=True))
    if "product" in payload:
        print("\nProduct")
        print(json.dumps(payload["product"], indent=2, sort_keys=True))
    if "retrieved_policy" in payload:
        print("\nRetrieved Policy")
        print(json.dumps(payload["retrieved_policy"], indent=2, sort_keys=True))
    print("\nResult")
    print(json.dumps(payload.get("result", {}), indent=2, sort_keys=True))


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    command = args.command or "list"
    app: TariffApp | None = None

    try:
        with ergo_session():
            app = TariffApp()

            if command == "list":
                print_output(app.list_shipments(), json_only=False)
                return 0

            if command == "sample":
                print_output(app.evaluate_shipment_id(args.shipment_id), json_only=False)
                return 0

            if command == "quote":
                validate_quote_args(args)
                print_output(app.evaluate_runtime_input(args), json_only=args.json)
                return 0

            if command == "interactive":
                return run_interactive(app, json_only=args.json)

            parser.print_help()
            return 1
    except (ValueError, EnvironmentError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        if app is not None:
            app.close()


if __name__ == "__main__":
    raise SystemExit(main())
