"""Stage49: clock one host-local baseline over the original synthetic fixture.

Stdlib only. Local-only baseline, NOT a perf budget or release claim.

Run from repo root:
  python benchmarks/run_local_baseline.py

Writes benchmarks/baseline-<host>-<YYYYMMDD>.json with provenance
(host, date, fixture manifest SHA-256) and min/median/max timings
over N iterations of manifest read + SHA-256 rehash + PDF byte scan.
"""

from __future__ import annotations

import datetime
import hashlib
import json
import re
import socket
import statistics
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "test" / "fixtures" / "synthetic"
BENCH = ROOT / "benchmarks"
N = 20

PAGE_MARKER = re.compile(rb"/Type\s*/Page[^s]")


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _timeit(fn, n: int = N) -> dict:
    samples = []
    for _ in range(n):
        t0 = time.perf_counter()
        fn()
        samples.append((time.perf_counter() - t0) * 1000.0)
    samples.sort()
    mid = len(samples) // 2
    median = samples[mid] if len(samples) % 2 else (samples[mid - 1] + samples[mid]) / 2
    return {
        "iterations": n,
        "min_ms": round(samples[0], 4),
        "median_ms": round(median, 4),
        "max_ms": round(samples[-1], 4),
        "mean_ms": round(statistics.fmean(samples), 4),
    }


def main() -> Path:
    manifest = FIXTURE / "manifest.json"
    data = json.loads(manifest.read_text(encoding="utf-8"))
    pdf_path = FIXTURE / data["files"]["pdf"]["name"]
    md_path = FIXTURE / data["files"]["markdown"]["name"]
    manifest_sha = _sha256(manifest)

    measures = {
        "manifest_read_json": _timeit(lambda: json.loads(manifest.read_text(encoding="utf-8"))),
        "sha256_pdf": _timeit(lambda: hashlib.sha256(pdf_path.read_bytes()).hexdigest()),
        "sha256_markdown": _timeit(lambda: hashlib.sha256(md_path.read_bytes()).hexdigest()),
        "pdf_byte_scan": _timeit(
            lambda: (len(pdf_path.read_bytes()), len(PAGE_MARKER.findall(pdf_path.read_bytes())))
        ),
    }

    host = socket.gethostname()
    safe_host = re.sub(r"[^A-Za-z0-9-]+", "-", host).strip("-") or "host"
    now = datetime.datetime.now(datetime.timezone.utc)
    baseline = {
        "scope": "local-only-baseline",
        "note": "NOT-A-BUDGET: machine-specific local timings only; never a release perf claim.",
        "provenance": {
            "host": host,
            "date": now.isoformat(),
            "fixture_manifest_sha256": manifest_sha,
            "fixture_pdf_sha256": data["files"]["pdf"]["sha256"],
            "fixture_markdown_sha256": data["files"]["markdown"]["sha256"],
            "python": __import__("sys").version.split()[0],
        },
        "measures": measures,
    }

    BENCH.mkdir(parents=True, exist_ok=True)
    out = BENCH / f"baseline-{safe_host}-{now.strftime('%Y%m%d')}.json"
    out.write_text(json.dumps(baseline, indent=2), encoding="utf-8")
    print(f"wrote {out}")
    for name, stats in measures.items():
        print(f"  {name}: median {stats['median_ms']} ms (min {stats['min_ms']}, max {stats['max_ms']}, n={stats['iterations']})")
    return out


if __name__ == "__main__":
    main()
