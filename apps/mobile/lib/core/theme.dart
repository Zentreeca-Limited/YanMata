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
  static const darkBackground = Color(0xFF120817);
  static const darkSurface = Color(0xFF1E0E26);
  static const darkCard = Color(0xFF2A1535);
  static const darkBorder = Color(0xFF422353);
  static const darkText = Color(0xFFFAF2FC);
  static const darkMuted = Color(0xFFC8B2CF);
  static const darkAccent = Color(0xFFD8B4E2);

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
      secondary: const Color(0xFFF472B6),
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
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.3,
        color: darkText,
      ),
      headlineSmall: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        letterSpacing: -.7,
        color: darkText,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.6, color: darkMuted),
      bodySmall: TextStyle(fontSize: 13, height: 1.4, color: darkMuted),
    ),
  );

  // Backward compatibility getter
  static ThemeData get theme => lightTheme;
}
