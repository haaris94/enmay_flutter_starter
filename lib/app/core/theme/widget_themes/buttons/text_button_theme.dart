import 'package:flutter/material.dart';

TextButtonThemeData textButtonTheme(
  ColorScheme colorScheme,
  TextTheme textTheme,
  dynamic buttonShape,
  dynamic buttonPadding,
) {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: colorScheme.secondary,
      shape: buttonShape,
      padding: buttonPadding,
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}
