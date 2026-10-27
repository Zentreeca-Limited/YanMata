import 'tokens.dart';

import 'package:flutter/material.dart';

abstract final class Palette {
  static const plum = DesignColors.plum,
      ink = DesignColors.ink,
      muted = DesignColors.muted,
      cream = DesignColors.cream,
      lilac = DesignColors.lilac,
      blush = DesignColors.blush,
      teal = DesignColors.teal,
      line = DesignColors.line,
      slate = DesignColors.muted;
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: cream,
    colorScheme: ColorScheme.fromSeed(seedColor: plum, surface: cream),
    fontFamily: 'Manrope',
    appBarTheme: const AppBarTheme(
      backgroundColor: cream,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE9E2E9)),
      ),
      contentPadding: const EdgeInsets.all(18),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: plum,
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.3,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        letterSpacing: -.7,
        color: ink,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.6, color: muted),
    ),
  );
}
