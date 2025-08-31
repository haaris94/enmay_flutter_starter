import 'package:flutter/material.dart';

FloatingActionButtonThemeData fabTheme(ColorScheme colorScheme) {
  return FloatingActionButtonThemeData(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  );
}