import 'package:flutter/material.dart';

CheckboxThemeData checkboxTheme(ColorScheme colorScheme) {
  return CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
    side: BorderSide(color: colorScheme.outline, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
  );
}
