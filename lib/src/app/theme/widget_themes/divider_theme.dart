import 'package:flutter/material.dart';

DividerThemeData dividerTheme(ColorScheme colorScheme) {
  return DividerThemeData(color: colorScheme.outlineVariant, thickness: 1, space: 1);
}
