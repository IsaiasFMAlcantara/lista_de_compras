import 'package:flutter/material.dart';

// Define ColorSchemes first
final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue, // Primary color for light theme
  brightness: Brightness.light,
);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo, // Primary color for dark theme
  brightness: Brightness.dark,
);

// Light Theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
    elevation: 4,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(fontSize: 57.0, fontWeight: FontWeight.normal),
    displayMedium: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.normal),
    displaySmall: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.normal),
    headlineLarge: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
    headlineMedium: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.normal),
    headlineSmall: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
    titleLarge: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    titleMedium: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
    bodyMedium: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    bodySmall: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
    labelLarge: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
  ).apply(
    bodyColor: lightColorScheme.onSurface,
    displayColor: lightColorScheme.onSurface,
  ),
  // Add more customizations as needed
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
    elevation: 4,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(fontSize: 57.0, fontWeight: FontWeight.normal),
    displayMedium: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.normal),
    displaySmall: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.normal),
    headlineLarge: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
    headlineMedium: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.normal),
    headlineSmall: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
    titleLarge: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    titleMedium: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
    bodyMedium: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    bodySmall: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
    labelLarge: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
  ).apply(
    bodyColor: darkColorScheme.onSurface,
    displayColor: darkColorScheme.onSurface,
  ),
  // Add more customizations as needed
);