import argparse
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


DEFAULT_INPUT_PATH = Path("htsdata.json")
DEFAULT_OUTPUT_PATH = Path("rag/data/hts_policy.json")
DEFAULT_EFFECTIVE_FROM = "2025-01-01"
DEFAULT_EFFECTIVE_TO = "9999-12-31"
DEFAULT_IMPORT_COUNTRY = "usa"
DEFAULT_SOURCE_ATOM = "htsus_2025_json"


RATE_PERCENT_RE = re.compile(r"^\s*(\d+(?:\.\d+)?)\s*%\s*$")


def normalize_hs_code(value: str) -> str:
    digits = "".join(char for char in value if char.isdigit())
    if len(digits) < 6:
        raise ValueError(f"HTS number '{value}' must contain at least 6 digits.")
    return f"hs{digits[:4]}_{digits[4:6]}"


def parse_rate(raw_rate: str) -> float | None:
    value = (raw_rate or "").strip()
    if not value:
        return None
    if value.lower() == "free":
        return 0.0

    match = RATE_PERCENT_RE.match(value)
    if match:
        return float(match.group(1)) / 100.0

    return None


def build_citation(rows: list[dict[str, Any]], representative_row: dict[str, Any]) -> str:
    parts = [
        f"Normalized from {len(rows)} HTS row(s) sharing six-digit code {normalize_hs_code(representative_row['htsno'])}.",
        f"Representative row {representative_row['htsno']}: {representative_row['description']}.",
        f"General rate of duty: {representative_row['general']}.",
    ]

    footnotes: list[str] = []
    special_values: list[str] = []
    additional_values: list[str] = []
    for row in rows:
        footnotes.extend(
            item.get("value", "").strip()
            for item in (row.get("footnotes") or [])
            if item.get("value")
        )
        special = (row.get("special") or "").strip()
        if special:
            special_values.append(special)
        additional = (row.get("additionalDuties") or row.get("addiitionalDuties") or "").strip()
        if additional:
            additional_values.append(additional)

    if footnotes:
        parts.append("Footnotes: " + " ".join(dict.fromkeys(footnotes)))
    if special_values:
        parts.append(
            "Special rate text retained for later normalization: "
            + " | ".join(dict.fromkeys(special_values))
            + "."
        )
    if additional_values:
        parts.append(
            "Additional duties text retained for later normalization: "
            + " | ".join(dict.fromkeys(additional_values))
            + "."
        )

    return " ".join(parts)


def transform_rows(
    rows: list[dict[str, Any]],
    *,
    import_country: str,
    effective_from: str,
    effective_to: str,
    source_atom: str,
) -> tuple[list[dict[str, Any]], Counter]:
    grouped_rows: dict[str, list[dict[str, Any]]] = defaultdict(list)
    documents: list[dict[str, Any]] = []
    stats: Counter = Counter()

    for row in rows:
        stats["rows_seen"] += 1

        htsno = (row.get("htsno") or "").strip()
        description = (row.get("description") or "").strip()
        rate_text = (row.get("general") or "").strip()
        special_text = (row.get("special") or "").strip()
        additional_text = (row.get("additionalDuties") or row.get("addiitionalDuties") or "").strip()

        if not htsno:
            stats["skipped_missing_htsno"] += 1
            continue
        if not rate_text:
            stats["skipped_missing_general_rate"] += 1
            continue

        try:
            hs_code = normalize_hs_code(htsno)
        except ValueError:
            stats["skipped_invalid_htsno"] += 1
            continue

        rate = parse_rate(rate_text)
        if rate is None:
            stats["skipped_unparsed_general_rate"] += 1
            continue

        grouped_rows[hs_code].append(
            {
                "htsno": htsno,
                "description": description,
                "general": rate_text,
                "rate": rate,
                "special": special_text,
                "additionalDuties": additional_text,
                "footnotes": row.get("footnotes") or [],
            }
        )
        if special_text:
            stats["rows_with_special_rate_text"] += 1
        if additional_text:
            stats["rows_with_additional_duties_text"] += 1
        if row.get("footnotes"):
            stats["rows_with_footnotes"] += 1

    for hs_code, hs_rows in sorted(grouped_rows.items()):
        unique_rates = {item["rate"] for item in hs_rows}
        if len(unique_rates) != 1:
            stats["skipped_ambiguous_hs6_rates"] += 1
            continue

        representative = min(
            hs_rows,
            key=lambda item: (len("".join(char for char in item["htsno"] if char.isdigit())), item["htsno"]),
        )
        document = {
            "id": f"htsus_{hs_code}_base",
            "kind": "tariff_rate",
            "import_country": import_country,
            "hs_code": hs_code,
            "rate": representative["rate"],
            "effective_from": effective_from,
            "effective_to": effective_to,
            "source_atom": source_atom,
            "hts_number": representative["htsno"],
            "description": representative["description"],
            "citation": build_citation(hs_rows, representative),
        }
        documents.append(document)
        stats["documents_written"] += 1

    return documents, stats


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Transform raw HTS JSON rows into the normalized policy format used by rag/ingest.py."
    )
    parser.add_argument(
        "--input",
        default=str(DEFAULT_INPUT_PATH),
        help=f"Raw HTS JSON input path. Defaults to {DEFAULT_INPUT_PATH}.",
    )
    parser.add_argument(
        "--output",
        default=str(DEFAULT_OUTPUT_PATH),
        help=f"Normalized JSON output path. Defaults to {DEFAULT_OUTPUT_PATH}.",
    )
    parser.add_argument(
        "--import-country",
        default=DEFAULT_IMPORT_COUNTRY,
        help=f"Import country atom for emitted records. Defaults to {DEFAULT_IMPORT_COUNTRY}.",
    )
    parser.add_argument(
        "--effective-from",
        default=DEFAULT_EFFECTIVE_FROM,
        help=f"Effective-from date to stamp on generated records. Defaults to {DEFAULT_EFFECTIVE_FROM}.",
    )
    parser.add_argument(
        "--effective-to",
        default=DEFAULT_EFFECTIVE_TO,
        help=f"Effective-to date to stamp on generated records. Defaults to {DEFAULT_EFFECTIVE_TO}.",
    )
    parser.add_argument(
        "--source-atom",
        default=DEFAULT_SOURCE_ATOM,
        help=f"Source atom to stamp on generated records. Defaults to {DEFAULT_SOURCE_ATOM}.",
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()
    input_path = Path(args.input)
    output_path = Path(args.output)

    rows = json.loads(input_path.read_text(encoding="utf-8"))
    if not isinstance(rows, list):
        raise ValueError(f"Expected a JSON list in {input_path}, got {type(rows).__name__}.")

    documents, stats = transform_rows(
        rows,
        import_country=args.import_country,
        effective_from=args.effective_from,
        effective_to=args.effective_to,
        source_atom=args.source_atom,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps({"documents": documents}, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {stats['documents_written']} normalized tariff_rate documents to {output_path}")
    for key in sorted(stats):
        print(f"{key}: {stats[key]}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
