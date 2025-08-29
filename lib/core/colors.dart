import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3B3C9C); // Indigo/Blue
  static const Color accent = Color(0xFF2FD6C9);  // Teal
  static const Color error = Color(0xFFFF6F61);   // Coral/Red
  static const Color warning = Color(0xFFFFD166); // Yellow
  static const Color dark = Color(0xFF2E2E2E);    // Dark Gray
  static const Color surface = Color(0xFFFFFDFA); // Off White
  static const Color backgroundW = Color(0xFFF5F6FA); // Light Gray
  static const Color backgroundB = Color(0xFF121212); // Light Gray

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF2FD6C9,
    <int, Color>{
      50: Color(0xFFE0F9F7),
      100: Color(0xFFB3F0EA),
      200: Color(0xFF80E6DD),
      300: Color(0xFF4DDCCF),
      400: Color(0xFF26D4C4),
      500: Color(0xFF2FD6C9),
      600: Color(0xFF28BFB3),
      700: Color(0xFF22A79C),
      800: Color(0xFF1C8F85),
      900: Color(0xFF147165),
    },
  );

}
