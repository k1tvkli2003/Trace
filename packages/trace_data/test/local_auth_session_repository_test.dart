import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';

void main() {
  late TraceDatabase db;
  late LocalAuthSessionRepository repository;

  setUp(() {
    db = TraceDatabase(NativeDatabase.memory());
    repository = LocalAuthSessionRepository(db);
  });
  tearDown(() async => db.close());

  test('auth session saves, restores, and clears a single row', () async {

    expect(await repository.current(), isNull);

    final future = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 3600;
    await repository.save(
      TraceAuthSession(
        email: 'user@example.com',
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
        expiresAtEpochSeconds: future,
        userId: 'user-1',
      ),
    );
    final restored = await repository.current();
    expect(restored, isNotNull);
    expect(restored!.email, 'user@example.com');
    expect(restored.accessToken, 'access-1');
    expect(restored.isExpired, isFalse);

    await repository.save(
      TraceAuthSession(
        email: 'other@example.com',
        accessToken: 'access-2',
        refreshToken: 'refresh-2',
        expiresAtEpochSeconds: future,
        userId: 'user-2',
      ),
    );
    final replaced = await repository.current();
    expect(replaced!.email, 'other@example.com');

    await repository.clear();
    expect(await repository.current(), isNull);
  });

  test('expired session reports expired for restore gate', () async {
    final past = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - 60;
    await repository.save(
      TraceAuthSession(
        email: 'old@example.com',
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
        expiresAtEpochSeconds: past,
        userId: 'user-old',
      ),
    );
    final restored = await repository.current();
    expect(restored, isNotNull);
    expect(restored!.isExpired, isTrue);
  });
}
