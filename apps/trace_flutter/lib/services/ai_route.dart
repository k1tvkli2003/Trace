/// Dual-route AI status probe. No secret handling.
///
/// Priority: 9Router `AMuse` when reachable on this device, else the
/// per-device local OpenCode runtime when healthy, else offline.
/// Fail-closed: probe errors never throw; they degrade to the next route.
library;

/// Stable, safe code only. Never carries key, token, or provider data.
final class AiRouteFailure implements Exception {
  const AiRouteFailure(this.code);
  final String code;
  @override
  String toString() => 'AiRouteFailure($code)';
}

enum AiRouteKind { nineRouter, localRuntime, offline }

final class AiRouteStatus {
  const AiRouteStatus({
    required this.kind,
    required this.model,
    required this.label,
    required this.detail,
  });

  final AiRouteKind kind;
  final String model;
  final String label;
  final String detail;

  bool get online => kind != AiRouteKind.offline;
}

/// Injectable fetchers keep the probe testable with zero dependencies.
final class AiRouteProbe {
  const AiRouteProbe({
    required this.nineRouterModels,
    required this.localHealth,
  });

  final Future<List<String>> Function() nineRouterModels;
  final Future<(bool, String)> Function() localHealth;

  static const nineRouterModel = 'AMuse';
  static const localModel = 'muse-spark-1.3-contributor-free';

  Future<AiRouteStatus> detect() async {
    try {
      final models = await nineRouterModels();
      if (models.contains(nineRouterModel)) {
        return const AiRouteStatus(
          kind: AiRouteKind.nineRouter,
          model: nineRouterModel,
          label: 'AI: 9Router AMuse',
          detail: '9Router reachable on this device; model AMuse in catalog.',
        );
      }
    } on AiRouteFailure {
      // Fall through to the local runtime route.
    } catch (_) {
      // Unknown probe error degrades, never throws.
    }
    try {
      final (healthy, version) = await localHealth();
      if (healthy) {
        return AiRouteStatus(
          kind: AiRouteKind.localRuntime,
          model: localModel,
          label: 'AI: local runtime',
          detail: 'Local OpenCode runtime healthy (version $version).',
        );
      }
    } on AiRouteFailure {
      // Fall through to offline.
    } catch (_) {
      // Unknown probe error degrades, never throws.
    }
    return const AiRouteStatus(
      kind: AiRouteKind.offline,
      model: '',
      label: 'AI offline',
      detail: 'No 9Router AMuse and no healthy local runtime on this device.',
    );
  }
}
