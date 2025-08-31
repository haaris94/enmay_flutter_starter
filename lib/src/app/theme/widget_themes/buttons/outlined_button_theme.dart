import 'package:flutter/material.dart';

OutlinedButtonThemeData outlinedButtonTheme(
  ColorScheme colorScheme,
  TextTheme textTheme,
  dynamic buttonShape,
  dynamic buttonPadding,
) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      side: BorderSide(color: colorScheme.primary, width: 1.5),
      shape: buttonShape,
      padding: buttonPadding,
      textStyle: textTheme.labelLarge,
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return BorderSide(color: colorScheme.primary, width: 2.0);
        }
        return BorderSide(color: colorScheme.primary, width: 1.5);
      }),
    ),
  );
}