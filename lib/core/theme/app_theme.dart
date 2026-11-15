
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFF28C45);
  static const Color background = Color(0xFFFFF8F0);
  static const Color darkBrown = Color(0xFF493629);
  static const Color green = Color(0xFF5B9B70);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: background,
      ),
      fontFamily: 'Roboto',
    );
  }
}
