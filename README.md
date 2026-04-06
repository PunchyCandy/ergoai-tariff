# ErgoAI Tariff Reasoner

Logic-based tariff evaluation with a Python CLI, a local HTS retrieval corpus, and ErgoAI rules.

## Overview

This project evaluates import duties in three stages:

1. A shipment is supplied through sample data or CLI arguments.
2. The app resolves the shipment's six-digit HTS code and retrieves matching policy records from a local corpus.
3. ErgoAI applies the active tariff rules and returns a structured result with the computed duty and explanation payload.

The current runtime path focuses on retrieved base tariff rates. The repository also contains source HTS data and transformation scripts used to build the local retrieval corpus.

## Current Architecture

- `app/main.py`: CLI entrypoint and runtime orchestration
- `app/data/`: sample shipment and product facts
- `app/rules/decision.ergo`: active Ergo rules used at runtime
- `rag/data/hts_policy.json`: local retrieval corpus consumed by the app
- `rag/ingest.py`: retrieval and fact-generation helpers
- `rag/transform_hts_json.py`: corpus preparation utility
- `docs/`: presentation and reference material

## CLI Commands

List sample shipments:

```bash
python3 app/main.py list
```

Evaluate a stored sample shipment:

```bash
python3 app/main.py sample s2
```

Evaluate a runtime shipment using an existing product id:

```bash
python3 app/main.py quote \
  --origin china \
  --import-country usa \
  --product-id p_router \
  --value 1000 \
  --date 2025-11-10
```

Evaluate a runtime shipment with a custom HTS code:

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

Run the prompt-driven flow:

```bash
python3 app/main.py interactive
```

## Requirements

- Python 3
- ErgoAI available through `ERGOROOT`
- XSB available through `XSBARCHDIR`

You can provide `ERGOROOT` and `XSBARCHDIR` through your shell environment or a local `.env` file.

## Testing

The repository includes a small regression suite for the CLI command flow:

```bash
python3 -m unittest discover -s tests
```

These tests use a fake `pyergo` module and mocks for the command handlers, so they validate the CLI behavior without requiring a live Ergo installation.
