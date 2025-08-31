import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom AppBar theme configurations
class CustomAppBarTheme {
  CustomAppBarTheme._();

  /// Light theme AppBar configuration
  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 4,
    centerTitle: true,
    titleSpacing: 16,
    toolbarHeight: 64,
    
    // Surface tint for Material 3
    surfaceTintColor: Colors.transparent,
    
    // Shadow and elevation
    shadowColor: Colors.black26,
    
    // Title text styling
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    
    // Action icon theme
    actionsIconTheme: IconThemeData(
      size: 24,
      color: null, // Uses colorScheme.onSurface
    ),
    
    // Leading icon theme
    iconTheme: IconThemeData(
      size: 24,
      color: null, // Uses colorScheme.onSurface
    ),
    
    // System overlay styling for status bar
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  /// Dark theme AppBar configuration
  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 4,
    centerTitle: true,
    titleSpacing: 16,
    toolbarHeight: 64,
    
    // Surface tint for Material 3
    surfaceTintColor: Colors.transparent,
    
    // Shadow and elevation
    shadowColor: Colors.black54,
    
    // Title text styling
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    
    // Action icon theme
    actionsIconTheme: IconThemeData(
      size: 24,
      color: null, // Uses colorScheme.onSurface
    ),
    
    // Leading icon theme
    iconTheme: IconThemeData(
      size: 24,
      color: null, // Uses colorScheme.onSurface
    ),
    
    // System overlay styling for status bar
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}