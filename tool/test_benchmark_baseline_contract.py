"""RED contract for Stage49: a host-local benchmark baseline exists and is well-formed.

Run from repo root:
  python -m unittest tool.test_benchmark_baseline_contract -v
"""

from __future__ import annotations

import glob
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BENCH = ROOT / "benchmarks"


class BenchmarkBaselineContractTests(unittest.TestCase):
    def test_baseline_file_exists(self) -> None:
        files = sorted(glob.glob(str(BENCH / "baseline-*.json")))
        self.assertTrue(files, f"missing benchmarks/baseline-*.json in {BENCH}")

    def test_baseline_wellformed_with_provenance(self) -> None:
        files = sorted(glob.glob(str(BENCH / "baseline-*.json")))
        self.assertTrue(files, "no baseline file to validate")
        data = json.loads(Path(files[-1]).read_text(encoding="utf-8"))
        self.assertEqual(data.get("scope"), "local-only-baseline")
        self.assertIn("not-a-budget", data.get("note", "").lower())
        prov = data.get("provenance", {})
        for key in ("host", "date", "fixture_manifest_sha256"):
            self.assertIn(key, prov, f"provenance missing: {key}")
        measures = data.get("measures", {})
        self.assertTrue(measures, "no measures recorded")
        for name, stats in measures.items():
            for key in ("iterations", "min_ms", "median_ms", "max_ms"):
                self.assertIn(key, stats, f"{name} missing {key}")
            self.assertGreaterEqual(stats["median_ms"], 0)
            self.assertGreaterEqual(stats["max_ms"], stats["min_ms"])


if __name__ == "__main__":
    unittest.main()
