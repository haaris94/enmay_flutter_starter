import 'package:flutter/material.dart';

/// Custom FloatingActionButton theme configurations
class CustomFloatingActionButtonTheme {
  CustomFloatingActionButtonTheme._();

  /// Light theme FloatingActionButton configuration
  static FloatingActionButtonThemeData lightFabTheme = const FloatingActionButtonThemeData(
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    disabledElevation: 0,
    
    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    
    // Size constraints
    sizeConstraints: BoxConstraints.tightFor(
      width: 56,
      height: 56,
    ),
    
    // Icon size
    iconSize: 24,
    
    // Enable Material 3 features
    enableFeedback: true,
  );

  /// Dark theme FloatingActionButton configuration
  static FloatingActionButtonThemeData darkFabTheme = const FloatingActionButtonThemeData(
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    disabledElevation: 0,
    
    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    
    // Size constraints
    sizeConstraints: BoxConstraints.tightFor(
      width: 56,
      height: 56,
    ),
    
    // Icon size
    iconSize: 24,
    
    // Enable Material 3 features
    enableFeedback: true,
  );

  /// Small FAB theme
  static const FloatingActionButtonThemeData smallFabTheme = FloatingActionButtonThemeData(
    elevation: 4,
    focusElevation: 6,
    hoverElevation: 6,
    highlightElevation: 8,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    
    sizeConstraints: BoxConstraints.tightFor(
      width: 40,
      height: 40,
    ),
    
    iconSize: 20,
    enableFeedback: true,
  );

  /// Large FAB theme
  static const FloatingActionButtonThemeData largeFabTheme = FloatingActionButtonThemeData(
    elevation: 8,
    focusElevation: 10,
    hoverElevation: 10,
    highlightElevation: 14,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    
    sizeConstraints: BoxConstraints.tightFor(
      width: 96,
      height: 96,
    ),
    
    iconSize: 36,
    enableFeedback: true,
  );

  /// Extended FAB theme
  static const FloatingActionButtonThemeData extendedFabTheme = FloatingActionButtonThemeData(
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    
    sizeConstraints: BoxConstraints(
      minHeight: 48,
      minWidth: 80,
    ),
    
    iconSize: 24,
    enableFeedback: true,
  );
}