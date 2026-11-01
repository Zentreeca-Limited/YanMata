import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/account/application/account_provider.dart';
import 'package:yanmata/features/account/domain/health_profile.dart';
import 'package:yanmata/features/account/presentation/auth_page.dart';
import 'package:yanmata/features/account/presentation/complete_profile_page.dart';
import 'package:yanmata/features/account/presentation/personalized_insights_page.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';

import 'widget_test.dart' show MemoryStore;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'onboarding_done': true});
  });

  testWidgets('AuthPage renders tabs and validates age requirements', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(
            LocalJournalRepository(MemoryStore(), Api()),
          ),
        ],
        child: const MaterialApp(home: AuthPage(isSignUp: true)),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Tabs
    expect(find.text('Create Account'), findsWidgets);
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Switch to Sign In tab
    await tester.tap(find.text('Sign In').first);
    await tester.pumpAndSettle();

    // Full Name and Date of Birth should not be present on Login tab
    expect(find.text('Full Name'), findsNothing);
    expect(find.text('Date of Birth'), findsNothing);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets(
    'CompleteProfilePage renders assessment sections with minor tailoring',
    (tester) async {
      const adultProfile = HealthProfile(
        age: 24,
        isMinor: false,
        requiredSections: [
          'menstrual',
          'reproductive',
          'medical',
          'lifestyle',
          'family',
        ],
        answers: {},
        completed: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            healthProfileProvider.overrideWith(
              () => _FakeHealthProfileNotifier(adultProfile),
            ),
          ],
          child: const MaterialApp(home: CompleteProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Complete Your Health Profile'), findsOneWidget);
      expect(find.text('Menstrual Cycle'), findsOneWidget);
      expect(find.text('Reproductive History'), findsOneWidget);
      expect(find.text('Medical History'), findsOneWidget);
      expect(find.text('Lifestyle & Habits'), findsOneWidget);
      expect(find.text('Family History'), findsOneWidget);
    },
  );

  testWidgets(
    'CompleteProfilePage hides adult sections for minors (ages 9-17)',
    (tester) async {
      const minorProfile = HealthProfile(
        age: 15,
        isMinor: true,
        requiredSections: ['menstrual', 'lifestyle'],
        answers: {},
        completed: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            healthProfileProvider.overrideWith(
              () => _FakeHealthProfileNotifier(minorProfile),
            ),
          ],
          child: const MaterialApp(home: CompleteProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Complete Your Health Profile'), findsOneWidget);
      expect(find.text('Menstrual Cycle'), findsOneWidget);
      expect(find.text('Lifestyle & Habits'), findsOneWidget);

      // Adult-only sections should be absent for minors
      expect(find.text('Reproductive History'), findsNothing);
      expect(find.text('Medical History'), findsNothing);
      expect(find.text('Family History'), findsNothing);
    },
  );

  testWidgets(
    'PersonalizedInsightsPage displays clinical insights and priority tags',
    (tester) async {
      final fakeInsights = <PersonalizedInsight>[
        const PersonalizedInsight(
          id: 'cervical-screen-routine',
          category: 'preventive',
          priority: 'routine',
          title: 'Cervical Health Check (WHO Guidelines)',
          body: 'Regular screening is recommended every 3 years for women aged 21-65.',
          source: 'WHO Comprehensive Cervical Cancer Control Guidelines',
          reviewStatus: 'reviewed',
        ),
        const PersonalizedInsight(
          id: 'cycle-irregularity-eval',
          category: 'cycle',
          priority: 'discuss',
          title: 'Menstrual Cycle Evaluation',
          body: 'Cycles varying by more than 7-9 days should be discussed with a specialist.',
          source: 'ACOG Practice Bulletin No. 136',
          reviewStatus: 'reviewed',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            personalizedInsightsProvider.overrideWith(
              (ref) async => fakeInsights,
            ),
          ],
          child: const MaterialApp(home: PersonalizedInsightsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Personalized Health Insights'), findsOneWidget);
      expect(
        find.text('Cervical Health Check (WHO Guidelines)'),
        findsOneWidget,
      );
      expect(find.text('Menstrual Cycle Evaluation'), findsOneWidget);
      expect(find.text('Go to Dashboard'), findsOneWidget);
    },
  );
}

class _FakeHealthProfileNotifier extends HealthProfileNotifier {
  _FakeHealthProfileNotifier(this.initial);
  final HealthProfile initial;

  @override
  Future<HealthProfile> build() async => initial;
}
