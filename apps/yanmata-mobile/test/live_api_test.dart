import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';
import 'package:yanmata/features/journal/domain/journal_repository.dart';

class TestStore implements PrivateStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async {
    value = v;
  }

  @override
  Future<void> delete() async {
    value = null;
  }
}

void main() {
  test(
    'Two independent mobile repositories sync through the real Laravel API',
    () async {
      final password = Platform.environment['YANMATA_DEMO_PASSWORD']!;
      final email =
          'live-mobile-${DateTime.now().microsecondsSinceEpoch}@test.yanmata.invalid';
      final firstStore = TestStore();
      final secondStore = TestStore();
      final first = LocalJournalRepository(firstStore, Api());
      final second = LocalJournalRepository(secondStore, Api());
      await first.add('Good', 'Synthetic live integration check');
      expect((await first.read()).pending, 1);
      await first.register(
        name: 'Synthetic Mobile Integration',
        email: email,
        password: password,
        dateOfBirth: '1990-01-01',
      );
      try {
        final session = await first.read();
        await first.api.request(
          '/consent/sync',
          method: 'PUT',
          token: session.token,
          body: {'enabled': true},
        );
        await secondStore.write(
          jsonEncode({
            'schema_version': 2,
            'entries': <dynamic>[],
            'outbox': <dynamic>[],
            'conflicts': <dynamic>[],
            'cursor': null,
            'token': session.token,
            'owner_id': session.ownerId,
            'user_name': session.userName,
            'user_role': session.userRole,
          }),
        );
        final id = (await first.read()).entries.single.id;
        await first.sync();
        expect((await first.read()).pending, 0);
        await second.sync();
        expect((await second.read()).entries.any((e) => e.id == id), true);
        await first.remove(id);
        await first.sync();
        await second.sync();
        expect((await second.read()).entries.any((e) => e.id == id), false);
      } finally {
        if ((await first.read()).signedIn) {
          try {
            await first.deleteAccount(password);
          } catch (error) {
            throw StateError('Synthetic account cleanup failed: $error');
          }
        }
        await secondStore.delete();
      }
    },
    skip: Platform.environment['YANMATA_DEMO_PASSWORD'] == null
        ? 'Opt-in live test; requires an environment password for its isolated synthetic account.'
        : false,
  );
}
