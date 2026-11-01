import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'core/theme_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/presentation/welcome_page.dart';
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
      home: const _Gate(),
    );
  }
}

/// Shows onboarding on first launch, then the main shell.
class _Gate extends StatefulWidget {
  const _Gate();
  @override
  State<_Gate> createState() => _GateState();
}

class _GateState extends State<_Gate> {
  static const _key = 'onboarding_done';
  bool? _done;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((p) {
          if (mounted) setState(() => _done = p.getBool(_key) ?? false);
        })
        .catchError((_) {
          if (mounted) setState(() => _done = true);
        });
  }

  Future<void> _finish() async {
    setState(() => _done = true);
    try {
      (await SharedPreferences.getInstance()).setBool(_key, true);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final done = _done;
    if (done == null) return const Scaffold(body: SizedBox.shrink());
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: done ? const YanMataShell() : WelcomePage(onGetStarted: _finish),
    );
  }
}
