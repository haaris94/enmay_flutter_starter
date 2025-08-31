import 'package:flutter/material.dart';

RadioThemeData radioTheme(ColorScheme colorScheme) {
  return RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.outline;
    }),
    // Optional: Specify splash radius, hover color etc.
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Smaller tap target
  );
}
