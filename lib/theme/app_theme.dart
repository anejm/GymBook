import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xFF4D6EB6),
      onPrimary: Colors.white,

      secondary: Color(0xFF22C55E),
      onSecondary: Colors.white,

      surface: Color(0xFFF8FAFC),
      onSurface: Color(0xFF0F172A),

      error: Color(0xFFDC2626),
      onError: Colors.white,

      outline: Color(0xFFCBD5E1),
      shadow: Colors.black,
    ),

    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
      ),

      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0F172A),
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0F172A),
      ),

      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF0F172A),
      ),

      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF64748B),
      ),

      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      centerTitle: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: const Color(0xFF4D6EB6),
        foregroundColor: Colors.white,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),

        foregroundColor: const Color(0xFF4D6EB6),

        side: const BorderSide(
          color: Color(0xFF4D6EB6),
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),

    cardTheme: const CardThemeData(
      elevation: 0,

      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF4D6EB6),
      unselectedItemColor: Color(0xFF64748B),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xFF7B95D1),
      onPrimary: Color(0xFF0F172A),

      secondary: Color(0xFF4ADE80),
      onSecondary: Color(0xFF0F172A),

      surface: Color(0xFF0F172A),
      onSurface: Color(0xFFF1F5F9),

      error: Color(0xFFEF4444),
      onError: Colors.white,

      outline: Color(0xFF334155),
      shadow: Colors.black,
    ),

    scaffoldBackgroundColor: const Color(0xFF0F172A),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFF1F5F9)),
      headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFFF1F5F9)),
      titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFFF1F5F9)),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFFF1F5F9)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF94A3B8)),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F172A),
      foregroundColor: Color(0xFFF1F5F9),
      elevation: 0,
      centerTitle: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: const Color(0xFF7B95D1),
        foregroundColor: const Color(0xFF0F172A),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        foregroundColor: const Color(0xFF7B95D1),
        side: const BorderSide(color: Color(0xFF7B95D1)),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    ),

    cardTheme: const CardThemeData(
      elevation: 0,
      color: Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      selectedItemColor: Color(0xFF7B95D1),
      unselectedItemColor: Color(0xFF94A3B8),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}