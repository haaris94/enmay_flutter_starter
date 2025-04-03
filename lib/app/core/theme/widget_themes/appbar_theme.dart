import 'package:flutter/material.dart';

AppBarTheme appBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    elevation: 0,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    iconTheme: IconThemeData(color: colorScheme.onSurface),
    actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
    toolbarHeight: 56,
  );
}