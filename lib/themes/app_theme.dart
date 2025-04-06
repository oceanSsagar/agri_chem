import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: kAppcolor),
      //   primaryColor: const Color(0xFF388E3C), // Deep Green
      //   colorScheme: const ColorScheme.light(
      //     primary: Color(0xFF388E3C), // Deep Green
      //     secondary: Color(0xFFFBC02D), // Golden Yellow
      //     surface: Color(0xFFFAFAF4), // Cream
      //     error: Color(0xFFD32F2F), // Reddish Brown
      //     onPrimary: Color(0xFFFFFFFF), // White for contrast
      //     onSecondary: Color(0xFF000000), // Black for text
      //     onSurface: Color(0xFF6D4C41), // Rich Brown
      //     onError: Color(0xFFFFFFFF), // White for contrast
      //   ),
      //   textTheme: const TextTheme(
      //     headlineLarge: TextStyle(
      //       fontSize: 32,
      //       fontWeight: FontWeight.bold,
      //       color: Color(0xFF388E3C),
      //     ), // Primary
      //     headlineSmall: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //       color: Color(0xFF6D4C41),
      //     ), // Surface text
      //     bodyLarge: TextStyle(
      //       fontSize: 16,
      //       color: Color(0xFF2E7D32),
      //     ), // Dark Green for body text
      //     bodySmall: TextStyle(
      //       fontSize: 14,
      //       color: Color(0xFF6D4C41),
      //     ), // Rich Brown for secondary text
      //   ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: kAppcolor,
        brightness: Brightness.dark,
      ),
      //   brightness: Brightness.dark,
      //   primaryColor: const Color(0xFF1B5E20), // Darker Green
      //   colorScheme: const ColorScheme.dark(
      //     primary: Color(0xFF1B5E20), // Darker Green
      //     secondary: Color(0xFFFBC02D), // Golden Yellow
      //     surface: Color(0xFF424242), // Gray
      //     error: Color(0xFFCF6679), // Reddish Pink
      //     onPrimary: Color(0xFFFFFFFF), // White for contrast
      //     onSecondary: Color(0xFF000000), // Black for text
      //     onSurface: Color(0xFFFFFFFF), // White text on surface
      //     onError: Color(0xFF000000), // Black for contrast
      //   ),
      //   textTheme: const TextTheme(
      //     headlineLarge: TextStyle(
      //       fontSize: 32,
      //       fontWeight: FontWeight.bold,
      //       color: Color(0xFFFFFFFF), // White text for headlines
      //     ),
      //     headlineSmall: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //       color: Color(0xFFFBC02D), // Golden Yellow text for smaller headlines
      //     ),
      //     bodyLarge: TextStyle(
      //       fontSize: 16,
      //       color: Color(0xFFFFFFFF), // White text for body
      //     ),
      //     bodySmall: TextStyle(
      //       fontSize: 14,
      //       color: Color(0xFFBDBDBD), // Light Gray for secondary body text
      //     ),
      //   ),
    );
  }
}
