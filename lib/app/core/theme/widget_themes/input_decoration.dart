import 'package:flutter/material.dart';

InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme, TextTheme textTheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.all(16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: colorScheme.outline, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: colorScheme.outline, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
    ),
    labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
  );
}