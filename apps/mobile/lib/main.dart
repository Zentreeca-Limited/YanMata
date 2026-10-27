import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'core/theme_provider.dart';
import 'features/shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: YanMataApp()));
}

class YanMataApp extends ConsumerWidget {
  const YanMataApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'YanMata',
      debugShowCheckedModeBanner: false,
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      themeMode: themeMode,
      home: const YanMataShell(),
    );
  }
}
