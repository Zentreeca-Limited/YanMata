import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';

import 'widget_test.dart' show MemoryStore;

void main() {
  Map<String, dynamic> signedInStore() => {
    'schema_version': 2,
    'entries': <dynamic>[],
    'outbox': <dynamic>[],
    'conflicts': <dynamic>[],
    'cursor': null,
    'token': 'test-token',
    'owner_id': 42,
    'user_name': 'Demo Member',
    'user_role': 'member',
  };

  test(
    'logout revokes the session before clearing local account data',
    () async {
      final store = MemoryStore()..value = jsonEncode(signedInStore());
      final repository = LocalJournalRepository(
        store,
        Api(
          client: MockClient((request) async {
            expect(request.method, 'POST');
            expect(request.url.path, '/api/v1/logout');
            expect(request.headers['authorization'], 'Bearer test-token');
            return http.Response('', 204);
          }),
        ),
      );

      await repository.logout();

      expect(store.value, isNull);
      expect((await repository.read()).signedIn, isFalse);
    },
  );

  test('account deletion sends re-authentication before local wipe', () async {
    final store = MemoryStore()..value = jsonEncode(signedInStore());
    final repository = LocalJournalRepository(
      store,
      Api(
        client: MockClient((request) async {
          expect(request.method, 'DELETE');
          expect(request.url.path, '/api/v1/account');
          expect(request.headers['authorization'], 'Bearer test-token');
          expect(jsonDecode(request.body), {
            'password': 'Sturdy-pass-2026',
            'confirmation': 'DELETE',
          });
          return http.Response('', 204);
        }),
      ),
    );

    await repository.deleteAccount('Sturdy-pass-2026');

    expect(store.value, isNull);
  });

  test('failed account deletion keeps local account data', () async {
    final store = MemoryStore()..value = jsonEncode(signedInStore());
    final repository = LocalJournalRepository(
      store,
      Api(client: MockClient((_) async => http.Response('{}', 422))),
    );

    await expectLater(
      repository.deleteAccount('wrong-password'),
      throwsException,
    );

    expect(store.value, isNotNull);
    expect((await repository.read()).signedIn, isTrue);
  });
}
