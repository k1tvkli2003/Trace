# Source manifest v1

Stage 11 immutable source manifest and provenance contract. Stage 10 import validation remains the byte-ingest boundary.

## Supported input

- PDF: `.pdf`, MIME `application/pdf`, retained as immutable original bytes. PDF text is not accepted from text layers or OCR.
- Markdown: `.md` / `.markdown`, MIME `text/markdown`, direct UTF-8 parser input.
- Plain text: `.txt`, MIME `text/plain`, direct UTF-8 parser input.
- Independent images: `.png` / `.jpg` / `.jpeg`, MIME `image/png` or `image/jpeg`, retained as immutable page-evidence originals pending Vision.

ZIP and other archive formats are rejected in this stage. No archive member is persisted until an adapter proves path traversal, compressed-size, entry-count, nesting, and decompression-limit safety.

## Logical path

`relativePath` is forward-slash separated and relative to import root. Empty segments, `.`, `..`, backslashes, drive prefixes, NUL, and absolute paths fail closed. The path is identity metadata, not an instruction to access the host filesystem.

## Immutable identity and revision

Each accepted item has a SHA-256 `sourceHash`, immutable source bytes, `libraryId`, logical path, MIME, format, byte size, import version, and monotonically assigned filename revision. Re-importing same library/path/hash returns same ID and does not overwrite bytes. Changed bytes retain prior revisions and create a new immutable ID/version.

Provenance fields are captured with the original import:

- `modifiedAt`: nullable source-origin timestamp. Wire form is ISO-8601 UTC ending in `Z`; exact accepted token is round-tripped. It is metadata only and never participates in source identity or revision selection.
- `logicalRole`: non-empty text; defaults to `primary` and is omitted from JSON when default.
- `exclusionReason`: nullable non-empty text. Presence records why an otherwise retained source is excluded from lesson input; it never deletes or mutates original bytes.

## Batch contract

A batch validates every item before opening its write transaction. Items are sorted by logical path, source hash, modification time, logical role, and exclusion reason. Duplicate `(path, hash)` entries with identical provenance collapse to one manifest. Duplicate `(path, hash)` entries with conflicting provenance reject the complete batch. Any unsupported, unsafe, oversized, empty, malformed, or provenance-invalid item rejects the complete batch; no row is written.

## Derived origin map

`originMapFor` is a deterministic read-only view: for each logical path it selects the highest persisted revision and returns paths sorted lexicographically. It does not replace immutable per-revision rows.

## Explicit non-scope

This stage does not implement ZIP extraction, PDF rendering, contact sheets, OCR, Vision, AI, sync, or an ingestion worker. `services/ingestion_worker/README.md` remains an explicit unimplemented boundary for later stages.
