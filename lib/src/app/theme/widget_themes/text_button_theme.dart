import 'package:flutter/material.dart';

/// Custom TextButton theme configurations
class CustomTextButtonTheme {
  CustomTextButtonTheme._();

  /// Light theme TextButton configuration
  static TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      // Minimum size
      minimumSize: const Size(48, 40),
      maximumSize: const Size(double.infinity, 48),
      
      // Text styling
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      
      // Tap target size
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      
      // Animation duration
      animationDuration: const Duration(milliseconds: 200),
    ),
  );

  /// Dark theme TextButton configuration
  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      // Shape and padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      // Minimum size
      minimumSize: const Size(48, 40),
      maximumSize: const Size(double.infinity, 48),
      
      // Text styling
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      
      // Tap target size
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      
      // Animation duration
      animationDuration: const Duration(milliseconds: 200),
    ),
  );

  /// Small text button variant
  static ButtonStyle smallTextButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: const Size(36, 32),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  /// Large text button variant
  static ButtonStyle largeTextButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    minimumSize: const Size(64, 48),
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.75,
    ),
  );

  /// Danger/Error text button variant
  static ButtonStyle dangerTextButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.red,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  /// Success text button variant
  static ButtonStyle successTextButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.green,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  /// Link-style text button
  static ButtonStyle linkTextButtonStyle = TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
    ),
  );
}