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
      final first = LocalJournalRepository(TestStore(), Api());
      final second = LocalJournalRepository(TestStore(), Api());
      await first.add('Good', 'Synthetic live integration check');
      expect((await first.read()).pending, 1);
      await first.connect('member@demo.yanmata.test', password);
      await second.connect('member@demo.yanmata.test', password);
      try {
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
        await first.disconnect();
        await second.disconnect();
      }
    },
    skip: Platform.environment['YANMATA_DEMO_PASSWORD'] == null
        ? 'Opt-in live test; requires seeded local API and environment password.'
        : false,
  );
}
