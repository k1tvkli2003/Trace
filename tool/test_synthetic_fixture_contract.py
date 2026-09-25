"""RED contract for Stage48: licensed synthetic fixture exists and matches its manifest.

Run from repo root:
  python -m unittest tool.test_synthetic_fixture_contract -v
"""

from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "test" / "fixtures" / "synthetic"
MANIFEST = FIXTURE / "manifest.json"


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class SyntheticFixtureContractTests(unittest.TestCase):
    def test_manifest_and_files_exist(self) -> None:
        self.assertTrue(MANIFEST.is_file(), f"missing manifest: {MANIFEST}")
        data = json.loads(MANIFEST.read_text(encoding="utf-8"))
        for name in ("pdf", "markdown"):
            path = FIXTURE / data["files"][name]["name"]
            self.assertTrue(path.is_file(), f"missing {name}: {path}")

    def test_hashes_pages_and_expected_strings(self) -> None:
        data = json.loads(MANIFEST.read_text(encoding="utf-8"))
        self.assertEqual(data["license"], "original-synthetic")
        self.assertIn("original", data["license_text"].lower())
        self.assertNotIn("harrison", data["license_text"].lower())

        pdf_path = FIXTURE / data["files"]["pdf"]["name"]
        md_path = FIXTURE / data["files"]["markdown"]["name"]
        self.assertEqual(_sha256(pdf_path), data["files"]["pdf"]["sha256"])
        self.assertEqual(_sha256(md_path), data["files"]["markdown"]["sha256"])

        doc = pymupdf.open(pdf_path)
        try:
            self.assertEqual(doc.page_count, data["expected"]["page_count"])
            text = "\n".join(page.get_text() for page in doc)
        finally:
            doc.close()

        markdown = md_path.read_text(encoding="utf-8")
        for needle in data["expected"]["strings"]:
            self.assertIn(needle, text)
            self.assertIn(needle, markdown)
        self.assertEqual(data["expected"]["figure"]["kind"], "labeled-box")
        self.assertIn(data["expected"]["figure"]["label"], text)


if __name__ == "__main__":
    unittest.main()
