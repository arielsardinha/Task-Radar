
final class SyncCursor {
  final int nextSkip;
  final int? remoteTotal;
  final bool exhausted;

  const SyncCursor({
    required this.nextSkip,
    required this.remoteTotal,
    required this.exhausted,
  });
}
