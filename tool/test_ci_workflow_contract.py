"""RED contract for Stage47: `.github/workflows/ci.yml` foundation exists and holds the CI-only contract.

Local-only; never claims a GitHub run. Run from repo root:
  python -m unittest tool.test_ci_workflow_contract -v
"""
import unittest
from pathlib import Path

try:
    import yaml
except ImportError:  # pragma: no cover
    yaml = None

ROOT = Path(__file__).resolve().parent.parent
WORKFLOW = ROOT / ".github" / "workflows" / "ci.yml"


class CiWorkflowContractTests(unittest.TestCase):
    def test_workflow_file_exists(self):
        self.assertTrue(WORKFLOW.is_file(), f"missing {WORKFLOW}")

    def test_workflow_parses_and_holds_contract(self):
        self.assertIsNotNone(yaml, "PyYAML required for contract check")
        doc = yaml.safe_load(WORKFLOW.read_text(encoding="utf-8"))
        self.assertIsInstance(doc, dict)

        on = doc.get("on", {})
        # `on` may parse as boolean True for YAML 1.1 ("on" == "yes"); normalize.
        if on is True:
            raw = WORKFLOW.read_text(encoding="utf-8")
            self.assertIn("workflow_dispatch", raw)
            self.assertIn("master", raw)
            self.assertIn("pull_request", raw)
        else:
            self.assertIn("push", on)
            self.assertIn("pull_request", on)
            self.assertIn("workflow_dispatch", on)
            push_branches = (on.get("push") or {}).get("branches", [])
            self.assertIn("master", push_branches)

        perms = doc.get("permissions", {})
        self.assertEqual(perms.get("contents"), "read")

        raw = WORKFLOW.read_text(encoding="utf-8")
        self.assertNotIn("secrets.", raw)
        for token in (
            "domain",
            "data",
            "gateway",
            "flutter",
            "docs",
            "diff-check",
        ):
            self.assertIn(token, raw.lower(), f"workflow missing job/surface: {token}")


if __name__ == "__main__":
    unittest.main()
