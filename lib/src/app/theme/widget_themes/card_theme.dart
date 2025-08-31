import 'package:flutter/material.dart';

CardThemeData cardTheme(ColorScheme colorScheme) {
  return CardThemeData(
    elevation: 0,
    color: colorScheme.surfaceContainer,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
}
