import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class Palette {
  static const plum = DesignColors.plum;
  static const ink = DesignColors.ink;
  static const muted = DesignColors.muted;
  static const cream = DesignColors.cream;
  static const lilac = DesignColors.lilac;
  static const blush = DesignColors.blush;
  static const teal = DesignColors.teal;
  static const line = DesignColors.line;
  static const slate = DesignColors.muted;

  // Semantic Dark Mode Colors
  static const darkBackground = Color(0xFF1A0B14);
  static const darkSurface = Color(0xFF26121D);
  static const darkCard = Color(0xFF34192A);
  static const darkBorder = Color(0xFF55304A);
  static const darkText = Color(0xFFFFF1F6);
  static const darkMuted = Color(0xFFD9B8C8);
  static const darkAccent = Color(0xFFF4A6C4);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: plum,
      brightness: Brightness.light,
      surface: cream,
      primary: plum,
      secondary: blush,
      tertiary: lilac,
    ),
    fontFamily: 'Manrope',
    appBarTheme: const AppBarTheme(
      backgroundColor: cream,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: ink),
    ),
    cardColor: Colors.white,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: blush,
      elevation: 8,
      shadowColor: plum.withValues(alpha: .25),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 11,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: s.contains(WidgetState.selected) ? plum : muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? plum : muted,
        ),
      ),
    ),
    dividerColor: line,
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
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -.6,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 25,
        fontWeight: FontWeight.w600,
        letterSpacing: -.3,
        color: ink,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.6, color: muted),
      bodySmall: TextStyle(fontSize: 13, height: 1.4, color: muted),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lilac,
      brightness: Brightness.dark,
      surface: darkSurface,
      primary: darkAccent,
      secondary: const Color(0xFFFFC2A8),
      tertiary: darkCard,
    ),
    fontFamily: 'Manrope',
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
    ),
    cardColor: darkCard,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkSurface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: darkCard,
      elevation: 8,
      shadowColor: Colors.black,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 11,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: s.contains(WidgetState.selected) ? darkAccent : darkMuted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? darkAccent : darkMuted,
        ),
      ),
    ),
    dividerColor: darkBorder,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: darkBorder),
      ),
      contentPadding: const EdgeInsets.all(18),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: darkAccent,
        foregroundColor: darkBackground,
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -.6,
        color: darkText,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 25,
        fontWeight: FontWeight.w600,
        letterSpacing: -.3,
        color: darkText,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.6, color: darkMuted),
      bodySmall: TextStyle(fontSize: 13, height: 1.4, color: darkMuted),
    ),
  );

  // Backward compatibility getter
  static ThemeData get theme => lightTheme;
}
