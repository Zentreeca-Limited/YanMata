import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/core/legal_webview_sheet.dart';
import 'package:yanmata/main.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';

import 'widget_test.dart' show MemoryStore;

void main() {
  SharedPreferences.setMockInitialValues({'onboarding_done': true});
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope.ttf'));
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  testWidgets('Phone home and journal have stable accessible layouts', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(
            LocalJournalRepository(MemoryStore(), Api()),
          ),
          learningProvider.overrideWith((ref) async => []),
        ],
        child: const YanMataApp(),
      ),
    );
    await tester.pumpAndSettle();
    if (Platform.isMacOS) {
      await expectLater(
        find.byType(YanMataApp),
        matchesGoldenFile('goldens/today-phone.png'),
      );
    }
    await tester.tap(find.text('Track'));
    await tester.pumpAndSettle();
    if (Platform.isMacOS) {
      await expectLater(
        find.byType(YanMataApp),
        matchesGoldenFile('goldens/track-phone.png'),
      );
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets('Home supports large text without layout exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(
            LocalJournalRepository(MemoryStore(), Api()),
          ),
          learningProvider.overrideWith((ref) async => []),
        ],
        child: const YanMataApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Welcome -> Auth -> Continue as Guest navigates to Home and clears stack, and legal links open 75% modal sheet', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'onboarding_done': false});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalRepositoryProvider.overrideWithValue(
            LocalJournalRepository(MemoryStore(), Api()),
          ),
          learningProvider.overrideWith((ref) async => []),
        ],
        child: const YanMataApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Should be on WelcomePage
    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    // Now on AuthPage (Create Account)
    expect(find.text('Create My Account'), findsOneWidget);

    // Verify tapping Terms of Service opens a 75% height LegalWebViewSheet
    final richTexts = tester.widgetList<RichText>(find.byType(RichText));
    TapGestureRecognizer? termsRecognizer;
    for (final rt in richTexts) {
      rt.text.visitChildren((span) {
        if (span is TextSpan && span.text == 'Terms of Service' && span.recognizer is TapGestureRecognizer) {
          termsRecognizer = span.recognizer as TapGestureRecognizer;
          return false;
        }
        return true;
      });
    }
    expect(termsRecognizer, isNotNull);
    termsRecognizer!.onTap!();
    await tester.pumpAndSettle();
    expect(find.byType(LegalWebViewSheet), findsOneWidget);
    final fractionalBox = tester.widget<FractionallySizedBox>(
      find.ancestor(
        of: find.byType(LegalWebViewSheet),
        matching: find.byType(FractionallySizedBox),
      ),
    );
    expect(fractionalBox.heightFactor, 0.75);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Switch to Sign In tab and verify Forgot password? has FontWeight.w400
    await tester.tap(find.text('Sign In').first);
    await tester.pumpAndSettle();
    final forgotFinder = find.text('Forgot password?');
    expect(forgotFinder, findsOneWidget);
    final forgotText = tester.widget<Text>(forgotFinder);
    expect(forgotText.style?.fontWeight, FontWeight.w400);

    // Tap Continue as Guest -> should land on Home and have no back button
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Get started'), findsNothing);
    expect(find.text('Create My Account'), findsNothing);
    final navState = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navState.canPop(), isFalse);
  });
}
