import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryDark = Color(0xFF0D1117);
  static const Color secondaryDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF21262D);
  
  static const Color primaryBlue = Color(0xFF1F6FEB);
  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color lightBlue = Color(0xFF0969DA);
  
  static const Color successGreen = Color(0xFF238636);
  static const Color lightGreen = Color(0xFF3FB950);
  
  static const Color warningOrange = Color(0xFFD29922);
  static const Color lightOrange = Color(0xFFF59E0B);
  
  static const Color errorRed = Color(0xFFDC2626);
  static const Color lightRed = Color(0xFFEF4444);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  
  static const Color borderColor = Color(0xFF30363D);
  
  // Map Colors
  static const Color mapBackground = Color(0xFFE8E4D8);
  static const Color mapStreet = Color(0xFFFFFFFF);
  static const Color mapBlock = Color(0xFFD4D4C4);
  static const Color mapGreen = Color(0xFFC9E4CA);
  
  static const Color routeCompleted = Color(0xFF22C55E);
  static const Color routeCurrent = Color(0xFFF59E0B);
  static const Color routePending = Color(0xFF9CA3AF);
  static const Color routePlanned = Color(0xFF8B5CF6);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentBlue,
        surface: secondaryDark,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      fontFamily: 'SF Pro Display',
    );
  }
}
