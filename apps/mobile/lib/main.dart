import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: YanMataApp()));
}

class YanMataApp extends StatelessWidget {
  const YanMataApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'YanMata',
    debugShowCheckedModeBanner: false,
    theme: Palette.theme,
    home: const YanMataShell(),
  );
}
