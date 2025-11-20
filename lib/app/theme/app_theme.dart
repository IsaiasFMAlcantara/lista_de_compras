import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF004D40); // Um verde bem escuro
  static const Color secondaryColor = Color(0xFF00796B); // Um verde azulado
  static const Color accentColor = Color(0xFFFF9800); // Laranja para destaque
  static const Color backgroundColor = Color(0xFFF5F5F5); // Um cinza bem claro
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color destructiveColor = Color(0xFFB71C1C); // Vermelho escuro para ações de exclusão
  static const Color successColor = Color(0xFF388E3C); // Verde para sucesso
  static const Color infoColor = Color(0xFF1976D2);    // Azul para informações

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onError: Colors.white,
      brightness: Brightness.light,
      tertiary: accentColor,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      headlineLarge: GoogleFonts.lato(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleMedium: GoogleFonts.lato( // Adicionado
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14.0,
        color: Colors.black54,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        textStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
      ),
      labelStyle: const TextStyle(
        color: Colors.black54,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: 1,
    ),
  );
}
