import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_flutter/main.dart';
import 'package:trace_flutter/services/trace_auth_client.dart';

class _FakeAuthResponse implements TraceAuthHttpResponse {
  const _FakeAuthResponse(this.statusCode, this.body);
  @override
  final int statusCode;
  @override
  final String body;
}

void main() {
  testWidgets('signed-out app shows email sign-in first', (tester) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      MainApp(database: database, startSignedOut: true),
    );
    await tester.pumpAndSettle();
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('unified sign-in stores session and opens library', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final authClient = TraceAuthClient(
      supabaseUrl: Uri.parse('https://example.invalid'),
      anonKey: 'anon-1',
      post: (uri, headers, body) async => const _FakeAuthResponse(
        200,
        '{"access_token":"access-1","refresh_token":"refresh-1",'
        '"expires_in":3600,"user":{"id":"user-1"}}',
      ),
    );
    await tester.pumpWidget(
      MainApp(
        database: database,
        startSignedOut: true,
        authClient: authClient,
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Email').first,
      'new@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password').first,
      'secret12',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('new@example.com'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    final stored = await LocalAuthSessionRepository(database).current();
    expect(stored, isNotNull);
    expect(stored!.accessToken, 'access-1');
  });

  testWidgets('expired session refreshes silently and skips sign-in', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final past = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - 60;
    await LocalAuthSessionRepository(database).save(
      TraceAuthSession(
        email: 'back@example.com',
        accessToken: 'access-old',
        refreshToken: 'refresh-good',
        expiresAtEpochSeconds: past,
        userId: 'user-9',
      ),
    );
    final authClient = TraceAuthClient(
      supabaseUrl: Uri.parse('https://example.invalid'),
      anonKey: 'anon-1',
      post: (uri, headers, body) async {
        expect(uri.queryParameters['grant_type'], 'refresh_token');
        return const _FakeAuthResponse(
          200,
          '{"access_token":"access-new","refresh_token":"refresh-new",'
          '"expires_in":3600,"user":{"id":"user-9"}}',
        );
      },
    );
    await tester.pumpWidget(
      MainApp(database: database, authClient: authClient),
    );
    await tester.pumpAndSettle();
    expect(find.text('back@example.com'), findsOneWidget);
    expect(find.text('Email'), findsNothing);
    final stored = await LocalAuthSessionRepository(database).current();
    expect(stored, isNotNull);
    expect(stored!.accessToken, 'access-new');
  });

  testWidgets('rejected refresh clears stale session and shows sign-in', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final past = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - 60;
    await LocalAuthSessionRepository(database).save(
      TraceAuthSession(
        email: 'stale@example.com',
        accessToken: 'access-old',
        refreshToken: 'refresh-bad',
        expiresAtEpochSeconds: past,
        userId: 'user-9',
      ),
    );
    final authClient = TraceAuthClient(
      supabaseUrl: Uri.parse('https://example.invalid'),
      anonKey: 'anon-1',
      post: (uri, headers, body) async => const _FakeAuthResponse(
        400,
        '{"msg":"Refresh token is not valid"}',
      ),
    );
    await tester.pumpWidget(
      MainApp(database: database, authClient: authClient),
    );
    await tester.pumpAndSettle();
    expect(find.text('Email'), findsOneWidget);
    expect(await LocalAuthSessionRepository(database).current(), isNull);
  });
}
