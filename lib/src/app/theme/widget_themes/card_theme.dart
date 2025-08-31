import 'package:flutter/material.dart';

/// Custom Card theme configurations
class CustomCardTheme {
  CustomCardTheme._();

  /// Light theme Card configuration
  static CardThemeData lightCardTheme = CardThemeData(
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.15),
    surfaceTintColor: Colors.transparent,
    
    // Shape and borders
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    
    // Margin and clip behavior
    margin: const EdgeInsets.all(8),
    clipBehavior: Clip.antiAlias,
  );

  /// Dark theme Card configuration
  static CardThemeData darkCardTheme = CardThemeData(
    elevation: 4, // Slightly higher for dark theme
    shadowColor: Colors.black.withValues(alpha: 0.3),
    surfaceTintColor: Colors.transparent,
    
    // Shape and borders
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    
    // Margin and clip behavior
    margin: const EdgeInsets.all(8),
    clipBehavior: Clip.antiAlias,
  );

  /// Compact card theme for list items
  static CardThemeData compactCardTheme = CardThemeData(
    elevation: 1,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    surfaceTintColor: Colors.transparent,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    clipBehavior: Clip.antiAlias,
  );

  /// Elevated card theme for important content
  static CardThemeData elevatedCardTheme = CardThemeData(
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.25),
    surfaceTintColor: Colors.transparent,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    
    margin: const EdgeInsets.all(16),
    clipBehavior: Clip.antiAlias,
  );
}