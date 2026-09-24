# Source manifest v1

Stage 10 import boundary.

## Supported input

- PDF: `.pdf`, MIME `application/pdf`, retained as immutable original bytes. PDF text is not accepted from text layers or OCR.
- Markdown: `.md` / `.markdown`, MIME `text/markdown`, direct UTF-8 parser input.
- Plain text: `.txt`, MIME `text/plain`, direct UTF-8 parser input.
- Independent images: `.png` / `.jpg` / `.jpeg`, MIME `image/png` or `image/jpeg`, retained as immutable page-evidence originals pending Vision.

ZIP and other archive formats are rejected in this stage. No archive member is persisted until an adapter proves path traversal, compressed-size, entry-count, nesting, and decompression-limit safety.

## Logical path

`relativePath` is forward-slash separated and relative to import root. Empty segments, `.`, `..`, backslashes, drive prefixes, NUL, and absolute paths fail closed. The path is identity metadata, not an instruction to access the host filesystem.

## Identity

Each accepted item has a SHA-256 `sourceHash`, immutable source bytes, `libraryId`, logical path, MIME, format, byte size, import version, and monotonically assigned filename revision. Re-importing same library/path/hash returns same ID. Changed bytes retain prior revision and create a new immutable ID.

## Batch contract

A batch validates every item before opening its write transaction. Items are sorted by normalized logical path and then source hash. Duplicate `(path, hash)` entries collapse to one manifest. Any unsupported, unsafe, oversized, empty, or malformed item rejects the complete batch; no row is written. A persisted original is never overwritten.
