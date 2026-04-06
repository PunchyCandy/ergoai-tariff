import contextlib
import importlib.util
import io
import json
import os
import pathlib
import sys
import types
import unittest
from unittest import mock


ROOT = pathlib.Path(__file__).resolve().parents[1]
MAIN_PATH = ROOT / "app" / "main.py"


def load_main_module():
    module_name = "test_app_main"
    sys.modules.pop(module_name, None)

    fake_pyergo = types.ModuleType("pyergo")
    fake_pyergo.pyergo_command = lambda *_args, **_kwargs: None
    fake_pyergo.pyergo_end_session = lambda: None
    fake_pyergo.pyergo_query = lambda *_args, **_kwargs: []
    fake_pyergo.pyergo_start_session = lambda *_args, **_kwargs: None

    with mock.patch.dict(
        os.environ,
        {"ERGOROOT": "/tmp/ergo", "XSBARCHDIR": "/tmp/xsb"},
        clear=False,
    ):
        with mock.patch.dict(sys.modules, {"pyergo": fake_pyergo}):
            spec = importlib.util.spec_from_file_location(module_name, MAIN_PATH)
            module = importlib.util.module_from_spec(spec)
            assert spec.loader is not None
            spec.loader.exec_module(module)
            return module


class CliRegressionTests(unittest.TestCase):
    def test_list_command_prints_shipments(self):
        main = load_main_module()
        shipments = [{"shipment_id": "s1", "origin": "china"}]

        with mock.patch.object(main, "ergo_session", return_value=contextlib.nullcontext()):
            with mock.patch.object(main.TariffApp, "list_shipments", return_value=shipments):
                stdout = io.StringIO()
                stderr = io.StringIO()
                with mock.patch.object(sys, "argv", ["main.py", "list"]):
                    with contextlib.redirect_stdout(stdout), contextlib.redirect_stderr(stderr):
                        exit_code = main.main()

        self.assertEqual(exit_code, 0)
        self.assertEqual(json.loads(stdout.getvalue()), shipments)
        self.assertEqual(stderr.getvalue(), "")

    def test_quote_json_command_returns_payload(self):
        main = load_main_module()
        payload = {
            "shipment_id": "runtime_quote",
            "input": {"origin": "japan"},
            "product": {"product_id": "p_parts"},
            "retrieved_policy": [{"hs_code": "hs8504_40"}],
            "result": {"duty_usd": 0.0, "rate": 0.0},
        }

        with mock.patch.object(main, "ergo_session", return_value=contextlib.nullcontext()):
            with mock.patch.object(main.TariffApp, "evaluate_runtime_input", return_value=payload):
                stdout = io.StringIO()
                with mock.patch.object(
                    sys,
                    "argv",
                    [
                        "main.py",
                        "quote",
                        "--origin",
                        "japan",
                        "--import-country",
                        "usa",
                        "--product-id",
                        "p_parts",
                        "--value",
                        "1200",
                        "--date",
                        "2026-02-02",
                        "--json",
                    ],
                ):
                    with contextlib.redirect_stdout(stdout):
                        exit_code = main.main()

        self.assertEqual(exit_code, 0)
        self.assertEqual(json.loads(stdout.getvalue()), payload)

    def test_invalid_quote_args_return_error(self):
        main = load_main_module()

        with mock.patch.object(main, "ergo_session", return_value=contextlib.nullcontext()):
            stdout = io.StringIO()
            stderr = io.StringIO()
            with mock.patch.object(
                sys,
                "argv",
                [
                    "main.py",
                    "quote",
                    "--origin",
                    "china",
                    "--value",
                    "1000",
                    "--date",
                    "2025-11-10",
                ],
            ):
                with contextlib.redirect_stdout(stdout), contextlib.redirect_stderr(stderr):
                    exit_code = main.main()

        self.assertEqual(exit_code, 1)
        self.assertIn("Provide either --product-id", stderr.getvalue())
        self.assertEqual(stdout.getvalue(), "")

    def test_load_kb_uses_unique_consult_paths(self):
        main = load_main_module()
        consult_commands = []

        def record_command(command_text):
            consult_commands.append(command_text)

        with mock.patch.object(main, "pyergo_command", side_effect=record_command):
            app = main.TariffApp()
            try:
                app.load_kb()
                app.load_kb()
            finally:
                app.close()

        self.assertEqual(len(consult_commands), 2)
        self.assertNotEqual(consult_commands[0], consult_commands[1])


if __name__ == "__main__":
    unittest.main()
