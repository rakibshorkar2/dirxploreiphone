import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Liquid Glass Color Palette
  static const Color darkBackground = Color(0xFF0A0E17);
  static const Color darkSurface = Color(0xFF161F30);
  static const Color darkCard = Color(0x1FFFFFFF); // Frosted/Glass effect
  static const Color darkAccent = Color(0xFF0A84FF); // iOS Blue
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0x99FFFFFF);

  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0x1A000000);
  static const Color lightAccent = Color(0xFF007AFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0x99000000);

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: darkAccent,
      barBackgroundColor: Color(0xCC161F30), // Translucent glass top/bottom bars
      scaffoldBackgroundColor: darkBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: darkText,
        textStyle: TextStyle(color: darkText, fontFamily: '.SF Pro Text'),
      ),
    );
  }

  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: lightAccent,
      barBackgroundColor: Color(0xCCFFFFFF),
      scaffoldBackgroundColor: lightBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: lightText,
        textStyle: TextStyle(color: lightText, fontFamily: '.SF Pro Text'),
      ),
    );
  }

  // Decoration helper for Liquid Glass look
  static BoxDecoration glassDecoration({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0x1AFFFFFF) : const Color(0x20000000),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? const Color(0x1FFFFFFF) : const Color(0x1A000000),
        width: 1,
      ),
    );
  }
}
