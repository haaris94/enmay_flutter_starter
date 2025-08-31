import 'package:flutter/material.dart';

SwitchThemeData switchTheme(ColorScheme colorScheme) {
  return SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.onSurfaceVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary.withValues(alpha: 0.5);
      }
      return colorScheme.surfaceContainerHighest;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return colorScheme.outline;
    }),
  );
}
