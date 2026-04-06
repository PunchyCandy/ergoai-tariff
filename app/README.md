# ErgoAI Tariff Application

`app/main.py` is the active runtime entrypoint for the project.

## What It Does

The CLI:

- loads the base product, shipment, and rule facts from `app/data/` and `app/rules/`
- resolves the shipment HTS code from either the product catalog or a runtime `--hs-code`
- retrieves matching policy records from `rag/data/hts_policy.json`
- converts those retrieved records into temporary Ergo facts
- evaluates duty and explanation output through ErgoAI

The current runtime rule set applies retrieved `tariff_rate(...)` facts to compute duty.

## Commands

List sample shipments:

```bash
python3 app/main.py list
```

Evaluate a sample shipment:

```bash
python3 app/main.py sample s4
```

Evaluate a runtime shipment using an existing product id:

```bash
python3 app/main.py quote \
  --origin japan \
  --import-country usa \
  --product-id p_parts \
  --value 1200 \
  --date 2026-02-02 \
  --json
```

Evaluate a runtime shipment using a custom HTS code:

```bash
python3 app/main.py quote \
  --origin taiwan \
  --import-country usa \
  --product-id custom_chip \
  --hs-code 8542.31.0000 \
  --category electronics \
  --description integrated_circuit \
  --value 2500 \
  --date 2025-11-10 \
  --json
```

Run interactive mode:

```bash
python3 app/main.py interactive
```

## Output

The CLI returns structured data with these sections:

- `input`: shipment facts used for reasoning
- `product`: resolved product metadata
- `retrieved_policy`: policy records pulled from the local corpus
- `result`: duty, rate, and explanation payload

## Notes

- Runtime knowledge bases are generated in unique temporary files to avoid cross-run collisions.
- Retrieval uses exact six-digit HTS normalization such as `8517.62.0000 -> hs8517_62`.
- The active runtime path depends on retrieved `tariff_rate` records from the local corpus.
- Override and exemption facts can be retrieved, but they are not yet part of the active duty rule selection logic.
