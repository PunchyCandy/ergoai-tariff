import sys, os, json
from dotenv import load_dotenv

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
    from pyergo import \
        pyergo_start_session, pyergo_end_session,       \
        pyergo_command, pyergo_query,                   \
        HILOGFunctor, PROLOGFunctor,                    \
        ERGOVariable, ERGOString, ERGOIRI, ERGOSymbol,  \
        ERGOIRI, ERGOCharlist, ERGODatetime,            \
        ERGODuration, ERGOUserDatatype,                 \
        pyxsb_query, pyxsb_command,                     \
        XSBFunctor, XSBVariable, XSBAtom, XSBString,    \
        PYERGOException, PYXSBException
except Exception as e:
    raise ImportError(
        f"Failed to import ErgoAI Python bindings from "
        f"{ERGO_PY_PATH}. If you're using a virtualenv, "
        "install missing dependencies (e.g., `pip install six`) "
        "or ensure ERGOAI_3.0 is present at the expected path."
    ) from e


def term_to_python(term):
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


def main():
    pyergo_start_session(XSBARCHDIR, ERGOROOT)
    try:
        base_dir = os.path.dirname(os.path.abspath(__file__))

        rule_files = [
            os.path.join(base_dir, "data/products.ergo"),
            os.path.join(base_dir, "data/shipments.ergo"),
            os.path.join(base_dir, "policy/usa_base.ergo"),
            os.path.join(base_dir, "policy/usa_exec_overrides.ergo"),
            os.path.join(base_dir, "policy/exemptions.ergo"),
            os.path.join(base_dir, "rules/decision.ergo"),
        ]

        combined_path = os.path.join(base_dir, "tmp_combined_rules.ergo")
        with open(combined_path, "w", encoding="utf-8") as out:
            for path in rule_files:
                out.write(f"/* ---- {path} ---- */\n")
                with open(path, "r", encoding="utf-8") as src:
                    out.write(src.read())
                out.write("\n\n")

        res = pyergo_command(f"['{combined_path}'].")
        print(f"Loaded import-tax KB (result: {res})")

        queries = [
            # Main demo: duty owed + rate + structured explanation
            "duty(s1, ?Duty, ?Rate, ?Expl).",
            "duty(s2, ?Duty, ?Rate, ?Expl).",
            "duty(s3, ?Duty, ?Rate, ?Expl).",
            "duty(s4, ?Duty, ?Rate, ?Expl).",
            "duty(s5, ?Duty, ?Rate, ?Expl).",

            # Show why: rate-only derivation
            "applicable_rate(s1, ?Rate, ?Expl).",
            "applicable_rate(s3, ?Rate, ?Expl).",

            # Inspect input data for a shipment
            "shipment(s1, ?O, ?I, ?P, ?V, ?D).",
            "product(?P, ?H, ?C, ?Desc).",
        ]

        for query in queries:
            answers = pyergo_query(query)
            if not answers:
                print("No solutions found for:", query)
                continue

            for i, ans in enumerate(answers, start=1):
                bindings = {name: val for (name, val) in ans[0]}
                pretty = {k: term_to_python(v) for k, v in bindings.items()}
                print(f"{query} Solution {i}: {json.dumps(pretty, indent=2, sort_keys=True)}")

    finally:
        pyergo_end_session()

if __name__ == "__main__":
    main()
