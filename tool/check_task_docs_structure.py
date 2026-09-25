"""CI replicate of `validate_task_docs.py --structure-only`.

Checks every `docs/codex/YYYY-MM-DD-*` task folder holds the required files
and exactly one `_index.md` row. Run from repo root: `python tool/check_task_docs_structure.py`.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent.parent
CODEX = ROOT / "docs" / "codex"
REQUIRED = (
    "00-brief.md",
    "01-plan.md",
    "02-state.md",
    "03-previews.md",
    "04-progress.md",
    "05-verification.md",
    "06-handoff.md",
    "assets",
    "logs",
)


def main() -> int:
    index = (CODEX / "_index.md").read_text(encoding="utf-8")
    tasks = sorted(
        p
        for p in CODEX.iterdir()
        if p.is_dir() and len(p.name) > 11 and p.name[4] == "-" and p.name[7] == "-"
    )
    if not tasks:
        print("no task folders found")
        return 1
    for task in tasks:
        for name in REQUIRED:
            if not (task / name).exists():
                print(f"{task.name} missing {name}")
                return 1
        if task.name not in index:
            print(f"{task.name} missing from _index.md")
            return 1
    print(f"docs structure OK: {len(tasks)} tasks")
    return 0


if __name__ == "__main__":
    sys.exit(main())
