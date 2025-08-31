import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:enmay_flutter_starter/src/app/theme/colors.dart';

class AppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.custom,
    colors: const FlexSchemeColor(
      primary: AppColors.primary,
      primaryContainer: Color(0xFFFFE8E5),
      secondary: AppColors.primary,
      secondaryContainer: Color(0xFFFFE8E5),
      tertiary: Color(0xFF6366F1),
      tertiaryContainer: Color(0xFFEEF2FF),
      appBarColor: Color(0xFFFFE8E5),
      error: AppColors.error,
      errorContainer: Color(0xFFFFEDEA),
    ),
    // shadcn-inspired surface colors
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 1,
    // Clean, minimal appearance
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 1.0,
    transparentStatusBar: true,
    appBarElevation: 0,
    // Typography
    fontFamily: 'Inter', // Add Inter font to pubspec.yaml
    // Custom component themes for shadcn look
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 1,
      useM2StyleDividerInM3: false,
      // Card styling
      cardRadius: 8,
      cardElevation: 0,
      // Button styling
      elevatedButtonRadius: 6,
      elevatedButtonElevation: 0,
      elevatedButtonSchemeColor: SchemeColor.primary,
      outlinedButtonRadius: 6,
      textButtonRadius: 6,
      // Input styling
      inputDecoratorRadius: 6,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      // Other components
      fabRadius: 12,
      chipRadius: 6,
      dialogRadius: 12,
      bottomSheetRadius: 12,
    ),
    keyColors: const FlexKeyColors(useSecondary: false, useTertiary: false),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.custom,
    colors: const FlexSchemeColor(
      primary: AppColors.primary,
      primaryContainer: Color(0xFF4C1D16),
      secondary: AppColors.primary,
      secondaryContainer: Color(0xFF4C1D16),
      tertiary: Color(0xFF6366F1),
      tertiaryContainer: Color(0xFF2D2D5F),
      appBarColor: Color(0xFF4C1D16),
      error: AppColors.error,
      errorContainer: Color(0xFF5F1F1F),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 2,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 1.0,
    transparentStatusBar: true,
    appBarElevation: 0,
    fontFamily: 'Inter',
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 1,
      useM2StyleDividerInM3: false,
      cardRadius: 8,
      cardElevation: 0,
      elevatedButtonRadius: 6,
      elevatedButtonElevation: 0,
      elevatedButtonSchemeColor: SchemeColor.primary,
      outlinedButtonRadius: 6,
      textButtonRadius: 6,
      inputDecoratorRadius: 6,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabRadius: 12,
      chipRadius: 6,
      dialogRadius: 12,
      bottomSheetRadius: 12,
    ),
    keyColors: const FlexKeyColors(useSecondary: false, useTertiary: false),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );
}

// Extension for easy access to theme colors (shadcn-inspired)
extension AppThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  // Surface colors (the new background)
  Color get background => colors.surface;
  Color get surface => colors.surface;
  Color get surfaceVariant => colors.surfaceContainerHighest;
  Color get surfaceContainer => colors.surfaceContainer;
  Color get surfaceContainerHigh => colors.surfaceContainerHigh;
  Color get surfaceContainerLow => colors.surfaceContainerLow;

  // Text colors
  Color get onSurface => colors.onSurface;
  Color get onSurfaceVariant => colors.onSurfaceVariant;

  // Primary
  Color get primary => colors.primary;
  Color get onPrimary => colors.onPrimary;
  Color get primaryContainer => colors.primaryContainer;
  Color get onPrimaryContainer => colors.onPrimaryContainer;

  // Semantic
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => colors.error;
  Color get info => AppColors.info;

  // Outline/borders (shadcn style)
  Color get outline => colors.outline;
  Color get outlineVariant => colors.outlineVariant;

  // Quick access to common patterns
  Color get mutedText => colors.onSurfaceVariant;
  Color get mutedBackground => colors.surfaceContainerHighest;
  Color get cardBackground => colors.surfaceContainer;
}
