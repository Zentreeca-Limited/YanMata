import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';
import 'package:yanmata/main.dart';

import 'widget_test.dart' show MemoryStore;

void main() {
  testWidgets(
    'Tracking with flow and symptoms saves and displays correctly in history',
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

      await tester.tap(find.text('Track'));
      await tester.pumpAndSettle();

      // Select mood
      await tester.tap(find.text('Difficult'));
      await tester.pumpAndSettle();

      // Select flow
      await tester.ensureVisible(find.text('Medium'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      // Select symptom
      await tester.ensureVisible(find.text('Cramps'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cramps'));
      await tester.pumpAndSettle();

      // Enter note
      await tester.ensureVisible(find.byType(TextField).first);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'Feeling cramps on day 2.',
      );

      // Save
      await tester.ensureVisible(find.text('Save my check-in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save my check-in'));
      await tester.pumpAndSettle();

      // Verify saved in repository
      final state = await repository.read();
      expect(state.entries.length, 1);
      final entry = state.entries.first;
      expect(entry.mood, 'Difficult');
      expect(entry.flow, 'medium');
      expect(entry.symptoms, contains('Cramps'));
      expect(entry.note, 'Feeling cramps on day 2.');

      // Verify displayed in history
      expect(find.text('Difficult'), findsWidgets);
      expect(find.text('Medium flow'), findsOneWidget);
      expect(find.text('Cramps'), findsWidgets);
    },
  );
}
