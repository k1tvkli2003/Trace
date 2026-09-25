"""RED contract for Stage50: an E2E scaffold plan exists and claims no run.

Run from repo root:
  python -m unittest tool.test_e2e_scaffold_contract -v
"""

from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
E2E = ROOT / "test" / "e2e"
README = E2E / "README.md"


class E2EScaffoldContractTests(unittest.TestCase):
    def test_e2e_readme_exists(self) -> None:
        self.assertTrue(README.is_file(), f"missing {README}")

    def test_readme_lists_flows_as_not_run(self) -> None:
        self.assertTrue(README.is_file(), "no README to validate")
        text = README.read_text(encoding="utf-8").lower()
        self.assertIn("not run", text)
        for token in (
            "import",
            "tree",
            "vision",
            "slice",
            "lesson",
            "review",
            "highlight",
            "note",
            "sync",
        ):
            self.assertIn(token, text, f"README missing flow: {token}")


if __name__ == "__main__":
    unittest.main()
