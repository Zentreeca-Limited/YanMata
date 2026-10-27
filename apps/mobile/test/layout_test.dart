import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yanmata/core/api.dart';
import 'package:yanmata/main.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/journal/data/local_journal_repository.dart';
import 'package:yanmata/features/learning/application/learning_provider.dart';

import 'widget_test.dart' show MemoryStore;

void main() {
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
}
