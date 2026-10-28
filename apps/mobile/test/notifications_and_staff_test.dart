import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/notifications.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/journal/domain/journal_repository.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/profile/presentation/you_page.dart';

class _FakeJournalRepo implements JournalRepository {
  _FakeJournalRepo({this.isStaff = false});
  final bool isStaff;

  @override
  Future<JournalState> read() async {
    return JournalState(
      signedIn: isStaff,
      ownerId: isStaff ? 2 : null,
      token: isStaff ? 'fake-token' : null,
      userName: isStaff ? 'Amina Author' : null,
      userRole: isStaff ? 'author' : 'member',
    );
  }

  @override
  Future<void> add(
    String mood,
    String note, {
    String? date,
    String flow = 'none',
    List<String> symptoms = const [],
    String energy = 'moderate',
    String? stage,
  }) async {}
  @override
  Future<void> connect(String email, String password) async {}
  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dateOfBirth,
  }) async {}
  @override
  Future<void> disconnect() async {}
  @override
  Future<void> erase() async {}
  @override
  Future<void> remove(String id) async {}
  @override
  Future<void> resolveConflict(
    String entryId, {
    required bool keepLocal,
  }) async {}
  @override
  Future<void> sync() async {}
}

void main() {
  group('NotificationPreferences domain & quiet hours tests', () {
    test('Quiet hours overnight calculation', () {
      const prefs = NotificationPreferences(
        quietHoursEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
      );

      // Late night
      expect(
        prefs.isInQuietHours(const TimeOfDay(hour: 23, minute: 15)),
        isTrue,
      );
      // Early morning before end
      expect(
        prefs.isInQuietHours(const TimeOfDay(hour: 5, minute: 30)),
        isTrue,
      );
      // Afternoon outside quiet hours
      expect(
        prefs.isInQuietHours(const TimeOfDay(hour: 14, minute: 0)),
        isFalse,
      );
      // Evening before start
      expect(
        prefs.isInQuietHours(const TimeOfDay(hour: 21, minute: 45)),
        isFalse,
      );
    });

    test('Discreet lock-screen notification privacy check', () {
      expect(NotificationPreferences.discreetLockScreenTitle, 'A quiet moment');
      expect(
        NotificationPreferences.discreetLockScreenBody,
        'How has your day felt so far?',
      );

      // Verify ZERO clinical/health terms in lockscreen copy
      for (final forbidden in [
        'period',
        'cycle',
        'cramp',
        'blood',
        'flow',
        'pregnant',
        'doctor',
      ]) {
        expect(
          NotificationPreferences.discreetLockScreenTitle
              .toLowerCase()
              .contains(forbidden),
          isFalse,
          reason: 'Lock-screen title must be strictly discreet',
        );
        expect(
          NotificationPreferences.discreetLockScreenBody.toLowerCase().contains(
            forbidden,
          ),
          isFalse,
          reason: 'Lock-screen body must be strictly discreet',
        );
      }
    });
  });

  group('You page notification and staff widgets tests', () {
    testWidgets('Displays discreet reminder notice and quiet hours toggles', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(430, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final fakeRepo = _FakeJournalRepo(isStaff: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [journalRepositoryProvider.overrideWithValue(fakeRepo)],
          child: MaterialApp(
            theme: Palette.theme,
            home: const Scaffold(body: You()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final reminderFinder = find.text('Reminders & quiet hours');
      await tester.scrollUntilVisible(
        reminderFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(reminderFinder, findsOneWidget);
      expect(find.text('Discreet lock-screen notice'), findsOneWidget);
      expect(find.text('A quiet moment'), findsOneWidget);
      expect(find.text('How has your day felt so far?'), findsOneWidget);
      expect(find.text('Daily reflection reminder'), findsOneWidget);
      expect(find.text('Quiet hours'), findsOneWidget);
      expect(find.text('Care message notifications'), findsOneWidget);
    });

    testWidgets(
      'Staff user sees Staff Editorial Studio card and can open portal',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(430, 1400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final fakeRepo = _FakeJournalRepo(isStaff: true);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [journalRepositoryProvider.overrideWithValue(fakeRepo)],
            child: MaterialApp(
              theme: Palette.theme,
              home: const Scaffold(body: You()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final staffFinder = find.text('Staff Editorial Studio');
        await tester.scrollUntilVisible(
          staffFinder,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        expect(staffFinder, findsOneWidget);
        final openButtonFinder = find.text('Open mobile editorial studio');
        expect(openButtonFinder, findsOneWidget);

        await tester.ensureVisible(openButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(openButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('Content Pipeline'), findsOneWidget);
        expect(find.text('Care Inquiries'), findsOneWidget);
      },
    );
  });
}
