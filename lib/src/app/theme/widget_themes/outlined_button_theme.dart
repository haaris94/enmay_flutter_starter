import 'package:flutter/material.dart';

/// Custom OutlinedButton theme configurations
class CustomOutlinedButtonTheme {
  CustomOutlinedButtonTheme._();

  /// Light theme OutlinedButton configuration
  static OutlinedButtonThemeData lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      
      // Border styling
      side: const BorderSide(width: 1.5),
      
      // Minimum size
      minimumSize: const Size(64, 48),
      maximumSize: const Size(double.infinity, 56),
      
      // Text styling
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      
      // Animation duration
      animationDuration: const Duration(milliseconds: 200),
    ),
  );

  /// Dark theme OutlinedButton configuration
  static OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      
      // Border styling
      side: const BorderSide(width: 1.5),
      
      // Minimum size
      minimumSize: const Size(64, 48),
      maximumSize: const Size(double.infinity, 56),
      
      // Text styling
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      
      // Animation duration
      animationDuration: const Duration(milliseconds: 200),
    ),
  );

  /// Small outlined button variant
  static ButtonStyle smallOutlinedButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minimumSize: const Size(48, 36),
    maximumSize: const Size(double.infinity, 40),
    side: const BorderSide(width: 1),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  /// Large outlined button variant
  static ButtonStyle largeOutlinedButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    minimumSize: const Size(120, 56),
    maximumSize: const Size(double.infinity, 64),
    side: const BorderSide(width: 2),
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.75,
    ),
  );

  /// Danger/Error outlined button variant
  static ButtonStyle dangerOutlinedButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    side: const BorderSide(width: 1.5, color: Colors.red),
    foregroundColor: Colors.red,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}