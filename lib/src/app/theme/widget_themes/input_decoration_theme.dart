import 'package:flutter/material.dart';

/// Custom InputDecoration theme configurations
class CustomInputDecorationTheme {
  CustomInputDecorationTheme._();

  /// Light theme InputDecoration configuration
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    // Border styling
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1),
    ),
    
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 1,
      ),
    ),
    
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
    
    // Content padding
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    
    // Filled styling
    filled: true,
    fillColor: Colors.grey.shade50,
    
    // Label and hint styling
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    
    floatingLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    
    hintStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade600,
    ),
    
    helperStyle: TextStyle(
      fontSize: 12,
      color: Colors.grey.shade600,
    ),
    
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Colors.red,
      fontWeight: FontWeight.w500,
    ),
    
    // Icon styling
    prefixIconColor: Colors.grey.shade600,
    suffixIconColor: Colors.grey.shade600,
    
    // Constraints
    constraints: const BoxConstraints(
      minHeight: 56,
      maxHeight: 200,
    ),
    
    // Behavior
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
  );

  /// Dark theme InputDecoration configuration
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    // Border styling
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1),
    ),
    
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade600,
        width: 1,
      ),
    ),
    
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade700,
        width: 1,
      ),
    ),
    
    // Content padding
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    
    // Filled styling
    filled: true,
    fillColor: Colors.grey.shade800.withValues(alpha: 0.3),
    
    // Label and hint styling
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    
    floatingLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    
    hintStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade400,
    ),
    
    helperStyle: TextStyle(
      fontSize: 12,
      color: Colors.grey.shade400,
    ),
    
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Colors.red,
      fontWeight: FontWeight.w500,
    ),
    
    // Icon styling
    prefixIconColor: Colors.grey.shade400,
    suffixIconColor: Colors.grey.shade400,
    
    // Constraints
    constraints: const BoxConstraints(
      minHeight: 56,
      maxHeight: 200,
    ),
    
    // Behavior
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
  );

  /// Dense input decoration for compact forms
  static InputDecorationTheme denseInputDecorationTheme = InputDecorationTheme(
    isDense: true,
    
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 1),
    ),
    
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    
    constraints: const BoxConstraints(
      minHeight: 40,
      maxHeight: 40,
    ),
    
    labelStyle: const TextStyle(fontSize: 14),
    hintStyle: const TextStyle(fontSize: 14),
  );

  /// Search input decoration theme
  static InputDecorationTheme searchInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
    
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
    
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 1,
      ),
    ),
    
    filled: true,
    fillColor: Colors.grey.shade100,
    
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    
    hintStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16,
    ),
    
    prefixIconColor: Colors.grey.shade600,
    suffixIconColor: Colors.grey.shade600,
  );
}