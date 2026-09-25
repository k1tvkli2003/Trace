/// Stage 29 pure resume decision over a stored `PdfRenderCheckpoint`.
///
/// No file or database I/O here. Returns the requested pages that are still
/// unfinished, in the exact requested order. Any malformed input (empty or
/// out-of-range page, non-increasing request, unknown completed page) yields
/// an empty list: the caller must re-validate the checkpoint through
/// `PdfRenderBatchWorker` instead of guessing.
List<int> remainingRenderPages({
  required List<int> requested,
  required List<int> completed,
}) {
  if (requested.isEmpty || requested.length > 8) return const [];
  for (var i = 0; i < requested.length; i++) {
    if (requested[i] < 1) return const [];
    if (i > 0 && requested[i] <= requested[i - 1]) return const [];
  }
  final wanted = requested.toSet();
  final done = <int>{};
  for (final page in completed) {
    if (!wanted.contains(page)) return const [];
    if (!done.add(page)) return const [];
  }
  return List.unmodifiable(requested.where((page) => !done.contains(page)));
}
