import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App colors - Using a consistent purple color theme
  static const Color primaryColor = Color(0xFF6c5ce7);
  static const Color secondaryColor = Color(0xFF6c5ce7); // Changed to same as primary
  static const Color accentColor = Color(0xFF8378eb); // Lighter shade of primary
  static const Color backgroundColor = Color(0xFFF0EEFF); // Very light purple tint
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFff7675);
  static const Color successColor = Color(0xFF55efc4);
  
  // Priority colors - Modified to fit purple theme
  static const Color lowPriorityColor = Color(0xFFB3ACFA); // Light purple
  static const Color mediumPriorityColor = Color(0xFF8F83F3); // Medium purple
  static const Color highPriorityColor = Color(0xFF6c5ce7); // Same as primary
  
  // Category colors - All adjusted to be purple shades
  static final Map<String, Color> categoryColors = {
    'Personal': const Color(0xFF6c5ce7), // Primary
    'Work': const Color(0xFF5E50D9), // Darker purple
    'Shopping': const Color(0xFF7B6BEF), // Slightly lighter
    'Health': const Color(0xFF9589F0), // Even lighter
    'Financial': const Color(0xFF877AEF), // Medium light
    'Education': const Color(0xFF544BC7), // Darker purple
    'Other': const Color(0xFFAFA5F5), // Light purple
  };
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF2d3436);
  static const Color textSecondaryColor = Color(0xFF636e72);
  static const Color textLightColor = Color(0xFFb2bec3);
  
  // Get priority color based on priority level
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 0:
        return lowPriorityColor;
      case 1:
        return mediumPriorityColor;
      case 2:
        return highPriorityColor;
      default:
        return mediumPriorityColor;
    }
  }
  
  // Get category color based on category name
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? categoryColors['Other']!;
  }
  
  // Light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryColor, // Using primary color
        error: errorColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor, // Changed to primary
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFe0e0e0),
        thickness: 1,
        space: 24,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateProperty.all(primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor, // Changed to primary
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 