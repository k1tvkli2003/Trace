import 'package:drift/drift.dart';

/// Single-row local session: Supabase Auth JWT for gateway calls.
///
/// Never stores password or service-role key. Email kept only so the
/// sign-in form can prefill. One row max (id = 'local'); login replaces.
class AuthSessions extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text()();
  IntColumn get expiresAtEpochSeconds => integer()();
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
