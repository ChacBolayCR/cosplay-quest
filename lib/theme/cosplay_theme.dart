import 'package:flutter/material.dart';

class CosplayTheme {
  static const Color voidBlack = Color(0xFF090B12);
  static const Color nightBlue = Color(0xFF101827);
  static const Color cardInk = Color(0xFF171B24);
  static const Color cardPurple = Color(0xFF211B2D);
  static const Color border = Color(0xFF2B3140);
  static const Color softPurple = Color(0xFF7B5BBE);
  static const Color softBlue = Color(0xFF4CA7D8);
  static const Color questGold = Color(0xFFE7B84B);
  static const Color mutedText = Color(0xFFAEB6C8);

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: voidBlack,
      colorScheme: const ColorScheme.dark(
        primary: softPurple,
        secondary: softBlue,
        tertiary: questGold,
        surface: cardInk,
        onSurface: Colors.white,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111620),
        selectedItemColor: questGold,
        unselectedItemColor: mutedText,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF121722),
        labelStyle: const TextStyle(color: mutedText),
        hintStyle: const TextStyle(color: mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: softBlue, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: questGold,
        contentTextStyle: const TextStyle(
          color: Color(0xFF17111F),
          fontWeight: FontWeight.w800,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return questGold;
          return const Color(0xFF252B37);
        }),
        checkColor: const WidgetStatePropertyAll(voidBlack),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: questGold,
          foregroundColor: voidBlack,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
