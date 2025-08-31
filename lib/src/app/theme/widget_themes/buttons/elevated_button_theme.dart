import 'package:flutter/material.dart';

ElevatedButtonThemeData elevatedButtonTheme(
  ColorScheme colorScheme,
  TextTheme textTheme,
  dynamic buttonShape,
  dynamic buttonPadding,
) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: buttonShape,
      padding: buttonPadding,
      elevation: 2,
      textStyle: textTheme.labelLarge,
    ),
  );
}
