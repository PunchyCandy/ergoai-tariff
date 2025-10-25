"""
app/main.py

Entry point for the ErgoAI Tariff Reasoner demo.

Right now this doesn't call ErgoAI or the retriever yet.
It just shows the shape of the final system:
  1. We have a shipment.
  2. We "look up" base duty.
  3. We "apply" any policy adjustments the RAG layer would have found.
  4. We print an explanation.

Later:
- Step 2 will come from ErgoAI rules in /ergo
- Step 3 will come from rag/retrieval.py + summarize_to_facts
"""

from datetime import date

def mock_ergo_compute_base_rate(hts_code: str, origin: str) -> dict:
    """
    Placeholder for ErgoAI reasoning.

    Returns what ErgoAI will eventually give us:
    - base_rate_pct: base % duty based on HTS and origin
    - legal_basis: citation / rule name
    """
    # TODO: replace with a real ErgoAI query
    return {
        "base_rate_pct": 0.0,
        "legal_basis": f"HTS {hts_code} base rate for origin {origin}"
    }

def mock_rag_adjustments(hts_code: str, origin: str, on_date: str) -> dict:
    """
    Placeholder for the RAG layer.

    Returns any temporary surcharges, exclusions, etc.
    Eventually this will come from rag/retrieval.py and summarize_to_facts.py.
    """
    # For now we just fake: no additional surcharges
    return {
        "surcharges_pct": 0.0,
        "explanation": f"No temporary surcharges found for {hts_code} from {origin} as of {on_date}."
    }

def compute_total_duty(value_usd: float, base_rate_pct: float, surcharges_pct: float) -> float:
    """
    Compute the total duty owed in dollars.
    total_rate = base_rate_pct + surcharges_pct
    duty = value_usd * total_rate/100
    """
    total_rate_pct = base_rate_pct + surcharges_pct
    duty_amount = value_usd * (total_rate_pct / 100.0)
    return round(duty_amount, 2)

def main():
    # Example shipment (eventually this will come from user input / API request)
    shipment = {
        "hts_code": "8542.31.0000",     # Example: integrated circuits
        "origin": "TW",                 # Taiwan
        "dest": "US",
        "declared_value_usd": 10000.00,
        "import_date": str(date.today())
    }

    # 1. Ask ErgoAI (base tariff logic)
    ergo_result = mock_ergo_compute_base_rate(
        hts_code=shipment["hts_code"],
        origin=shipment["origin"]
    )

    # 2. Ask RAG (policy adjustments like Section 301, exclusions, etc.)
    rag_result = mock_rag_adjustments(
        hts_code=shipment["hts_code"],
        origin=shipment["origin"],
        on_date=shipment["import_date"]
    )

    # 3. Compute final duty
    duty_due = compute_total_duty(
        value_usd=shipment["declared_value_usd"],
        base_rate_pct=ergo_result["base_rate_pct"],
        surcharges_pct=rag_result["surcharges_pct"]
    )

    # 4. Pretty-print result
    print("=== ErgoAI Tariff Reasoner Demo ===")
    print(f"HTS Code:              {shipment['hts_code']}")
    print(f"Country of Origin:     {shipment['origin']}")
    print(f"Declared Value (USD):  {shipment['declared_value_usd']}")
    print(f"Import Date:           {shipment['import_date']}")
    print()
    print(f"Base Rate (%):         {ergo_result['base_rate_pct']}%")
    print(f"Policy Surcharges (%): {rag_result['surcharges_pct']}%")
    print(f"=> Total Duty Owed:    ${duty_due}")
    print()
    print("Explanation:")
    print(f"- Base rule: {ergo_result['legal_basis']}")
    print(f"- RAG note:  {rag_result['explanation']}")

if __name__ == "__main__":
    main()
