import 'package:flutter/material.dart';

/// Custom ElevatedButton theme configurations
class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  /// Light theme ElevatedButton configuration
  static ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      
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

  /// Dark theme ElevatedButton configuration
  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      
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

  /// Small button variant
  static ButtonStyle smallButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minimumSize: const Size(48, 36),
    maximumSize: const Size(double.infinity, 40),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  /// Large button variant
  static ButtonStyle largeButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    minimumSize: const Size(120, 56),
    maximumSize: const Size(double.infinity, 64),
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.75,
    ),
  );

  /// Icon button variant
  static ButtonStyle iconButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    minimumSize: const Size(56, 56),
    maximumSize: const Size(56, 56),
    shape: const CircleBorder(),
  );
}