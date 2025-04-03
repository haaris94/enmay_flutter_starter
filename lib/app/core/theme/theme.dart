import 'package:enmay_flutter_starter/app/core/theme/widget_themes/buttons/text_button_theme.dart';
import 'package:flutter/material.dart';
import '_colors.dart';
import '_typography.dart';
import 'widget_themes/card_theme.dart';
import 'widget_themes/appbar_theme.dart';
import 'widget_themes/divider_theme.dart';
import 'widget_themes/input_decoration.dart';
import 'widget_themes/buttons/elevated_button_theme.dart';
import 'widget_themes/buttons/outlined_button_theme.dart';
import 'widget_themes/switch_theme.dart';
import 'widget_themes/radio_theme.dart';
import 'widget_themes/checkbox_theme.dart';
import 'widget_themes/buttons/fab_theme.dart';

// --- Base Theme Configurations ---
ThemeData _buildBaseTheme(ColorScheme colorScheme, TextTheme textTheme) {
  // Common Button Style
  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
  // Increased vertical padding for a more modern feel
  final buttonPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14);

  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme, // Use updated text theme
    scaffoldBackgroundColor: colorScheme.surface,
    cardTheme: cardTheme(colorScheme),
    appBarTheme: appBarTheme(colorScheme), // Ensure AppBar uses theme correctly
    dividerTheme: dividerTheme(colorScheme),
    inputDecorationTheme: inputDecorationTheme(colorScheme, textTheme),
    elevatedButtonTheme: elevatedButtonTheme(colorScheme, textTheme, buttonShape, buttonPadding),
    textButtonTheme: textButtonTheme(colorScheme, textTheme, buttonShape, buttonPadding),
    outlinedButtonTheme: outlinedButtonTheme(colorScheme, textTheme, buttonShape, buttonPadding),
    switchTheme: switchTheme(colorScheme),
    radioTheme: radioTheme(colorScheme),
    checkboxTheme: checkboxTheme(colorScheme), // Checkbox will use primary color by default, which is fine
    floatingActionButtonTheme: fabTheme(colorScheme),
  );
}

// --- Light Theme ---
final ThemeData lightTheme = _buildBaseTheme(
  ColorScheme(
    brightness: Brightness.light,
    primary: LightColors.primary,
    onPrimary: LightColors.primaryForeground,
    secondary: LightColors.secondaryText,
    onSecondary: LightColors.primaryText,
    error: Colors.red,
    onError: white,
    surface: LightColors.background,
    onSurface: LightColors.primaryText,
    surfaceDim: LightColors.background,
    surfaceBright: LightColors.background,
    surfaceContainerLowest: LightColors.card,
    surfaceContainerLow: LightColors.card,
    surfaceContainer: LightColors.card,
    surfaceContainerHigh: LightColors.card,
    surfaceContainerHighest: LightColors.card,
    onSurfaceVariant: LightColors.secondaryText,
    outline: LightColors.border,
    outlineVariant: LightColors.border,
    shadow: black.withValues(alpha: 0.1),
    scrim: black.withValues(alpha: 0.3),
    inverseSurface: DarkColors.background,
    onInverseSurface: DarkColors.primaryText,
    inversePrimary: DarkColors.primary,
  ),
  lightTextTheme,
);

// --- Dark Theme ---
final ThemeData darkTheme = _buildBaseTheme(
  ColorScheme(
    brightness: Brightness.dark,
    primary: DarkColors.primary,
    onPrimary: DarkColors.primaryForeground,
    secondary: DarkColors.secondaryText,
    onSecondary: DarkColors.primaryText,
    error: Colors.redAccent,
    onError: black,
    surface: DarkColors.background,
    onSurface: DarkColors.primaryText,
    surfaceDim: DarkColors.background,
    surfaceBright: DarkColors.background,
    surfaceContainerLowest: DarkColors.card,
    surfaceContainerLow: DarkColors.card,
    surfaceContainer: DarkColors.card,
    surfaceContainerHigh: DarkColors.card,
    surfaceContainerHighest: DarkColors.card,
    onSurfaceVariant: DarkColors.secondaryText,
    outline: DarkColors.border,
    outlineVariant: DarkColors.border,
    shadow: black.withValues(alpha: 0.2),
    scrim: black.withValues(alpha: 0.4),
    inverseSurface: LightColors.background,
    onInverseSurface: LightColors.primaryText,
    inversePrimary: LightColors.primary,
  ),
  darkTextTheme,
);
