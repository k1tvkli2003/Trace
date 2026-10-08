import 'package:drift/drift.dart';

import 'trace_database.dart';

/// Local-first session store: one row max, single source of truth for
/// the signed-in user. Stores tokens only — never passwords, never keys.
final class LocalAuthSessionRepository {
  LocalAuthSessionRepository(this.database);

  final TraceDatabase database;

  static const _rowId = 'local';

  Future<TraceAuthSession?> current() async {
    final row = await (database.select(
      database.authSessions,
    )..where((table) => table.id.equals(_rowId))).getSingleOrNull();
    if (row == null) return null;
    return TraceAuthSession(
      email: row.email,
      accessToken: row.accessToken,
      refreshToken: row.refreshToken,
      expiresAtEpochSeconds: row.expiresAtEpochSeconds,
      userId: row.userId,
    );
  }

  Future<void> save(TraceAuthSession session) async {
    await database
        .into(database.authSessions)
        .insertOnConflictUpdate(
          AuthSessionsCompanion.insert(
            id: _rowId,
            email: session.email,
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
            expiresAtEpochSeconds: session.expiresAtEpochSeconds,
            userId: session.userId,
          ),
        );
  }

  Future<void> clear() async {
    await (database.delete(
      database.authSessions,
    )..where((table) => table.id.equals(_rowId))).go();
  }
}

/// Signed-in session snapshot. Immutable value, safe to pass around.
final class TraceAuthSession {
  const TraceAuthSession({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtEpochSeconds,
    required this.userId,
  });

  final String email;
  final String accessToken;
  final String refreshToken;
  final int expiresAtEpochSeconds;
  final String userId;

  bool get isExpired {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return now >= expiresAtEpochSeconds - 30;
  }
}
