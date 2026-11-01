import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/main.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/domain/journal_repository.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';

class MemoryStore implements PrivateStore {
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
  SharedPreferences.setMockInitialValues({'onboarding_done': true});
  testWidgets(
    'Private check-in saves locally and survives repository recreation',
    (tester) async {
      final store = MemoryStore();
      final repository = LocalJournalRepository(store, Api());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalRepositoryProvider.overrideWithValue(repository),
            learningProvider.overrideWith((ref) async => []),
          ],
          child: const YanMataApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('A moment,\njust for you.'), findsOneWidget);
      await tester.tap(find.text('Track'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Good'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Good'));
      await tester.enterText(
        find.byType(TextField).first,
        'A synthetic check-in.',
      );
      await tester.ensureVisible(find.text('Save my check-in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save my check-in'));
      await tester.pumpAndSettle();
      final restored = await LocalJournalRepository(store, Api()).read();
      expect(restored.entries.single.note, 'A synthetic check-in.');
      expect(restored.entries.single.mood, 'Good');
      expect(restored.pending, 1);
      expect(restored.signedIn, false);
    },
  );
}
