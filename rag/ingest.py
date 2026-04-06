import json
import os
from datetime import date
from typing import Any


CORPUS_PATH = os.path.join(os.path.dirname(__file__), "data", "hts_policy.json")


def _load_corpus() -> list[dict[str, Any]]:
    with open(CORPUS_PATH, "r", encoding="utf-8") as src:
        payload = json.load(src)
    return payload["documents"]


def _normalize_atom(value: str) -> str:
    return value.strip().lower().replace("-", "_").replace(" ", "_")


def normalize_hs_code(value: str) -> str:
    digits = "".join(char for char in value if char.isdigit())
    if len(digits) < 6:
        raise ValueError("HTS code must contain at least 6 digits.")
    return f"hs{digits[:4]}_{digits[4:6]}"


def _parse_date(value: str) -> date:
    year, month, day = value.split("-")
    return date(int(year), int(month), int(day))


def _active_on(shipment_date: date, effective_from: str, effective_to: str | None = None) -> bool:
    start = _parse_date(effective_from)
    end = _parse_date(effective_to) if effective_to else date.max
    return start <= shipment_date <= end


def retrieve_policy(shipment: dict[str, Any]) -> list[dict[str, Any]]:
    """
    Retrieve local HTS policy records relevant to a shipment.

    This first version is intentionally simple:
    - exact HTS code match after normalization to the repo's `hs8517_62` style
    - import country match
    - optional origin match for overrides
    - date filtering on effective windows
    """

    normalized_hs_code = normalize_hs_code(shipment["hts_code"])
    normalized_import_country = _normalize_atom(shipment["import_country"])
    normalized_origin = _normalize_atom(shipment["origin"])
    shipment_date = _parse_date(shipment["date"])

    matches = []
    for document in _load_corpus():
        if document["import_country"] != normalized_import_country:
            continue
        if document["hs_code"] != normalized_hs_code:
            continue
        if not _active_on(
            shipment_date,
            document["effective_from"],
            document.get("effective_to"),
        ):
            continue
        if document["kind"] in {"exec_override", "exempt_rule"} and document["origin"] != normalized_origin:
            continue
        matches.append(document)

    return matches


def _ergo_date(value: str) -> str:
    year, month, day = value.split("-")
    return f"date({int(year)},{int(month)},{int(day)})"


def policy_records_to_ergo_facts(records: list[dict[str, Any]]) -> str:
    fact_lines = ["/* ---- retrieved HTS policy facts ---- */"]

    for record in records:
        if record["kind"] == "tariff_rate":
            effective_to = record.get("effective_to", "9999-12-31")
            fact_lines.append(
                "tariff_rate("
                f"{record['import_country']}, {record['hs_code']}, {record['rate']}, "
                f"{_ergo_date(record['effective_from'])}, {_ergo_date(effective_to)}, "
                f"{record['source_atom']}"
                ")."
            )
            continue

        if record["kind"] == "exec_override":
            fact_lines.append(
                "exec_override("
                f"{record['id']}, {record['import_country']}, {record['origin']}, {record['hs_code']}, "
                f"{record['rate']}, {_ergo_date(record['effective_from'])}, {record['source_atom']}"
                ")."
            )
            continue

        if record["kind"] == "exempt_rule":
            fact_lines.append(
                "exempt_rule("
                f"{record['id']}, {record['origin']}, {record['import_country']}, {record['hs_code']}, "
                f"{_ergo_date(record['effective_from'])}, {record['source_atom']}"
                ")."
            )

    return "\n".join(fact_lines) + "\n"
