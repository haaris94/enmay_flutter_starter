import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static ThemeData lightTheme = FlexThemeData.light(
    // 1. USE COLORS FROM YOUR AppColors DEFINITION
    // We feed FlexColorScheme the key semantic colors from our AppColors class.
    // This ensures that built-in Flutter widgets (like FloatingActionButton)
    // use the same primary color as our custom components.
    primary: lightAppColors.primary,
    scaffoldBackground: lightAppColors.background,
    // Note: We don't need a full FlexSchemeColor. We'll control surfaces manually.

    // 2. STOP UNWANTED COLOR MIXING (CRUCIAL FOR SHADCN STYLE)
    // A blend level of 0 completely disables the feature where FlexColorScheme
    // mixes your primary color into surfaces, backgrounds, and containers.
    // This is the key to achieving a clean, predictable, non-Material look.
    blendLevel: 0,

    // We also set surfaceMode to `highScaffoldLowSurface` which is a good
    // starting point for a card-based UI, but our AppColors.container will
    // be the main way we control this.
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,

    // 3. DISABLE M3 KEY COLORS & HARMONIZATION
    // This prevents Flutter from algorithmically generating tones from your
    // primary color and tinting other UI elements with them.
    keyColors: const FlexKeyColors(useKeyColors: false),

    // 4. STYLE THE APP BAR FOR A MINIMALIST LOOK
    appBarStyle: FlexAppBarStyle.background,
    appBarElevation: 0,

    // 5. ATTACH YOUR CUSTOM THEME EXTENSION
    // This is the most important part. We are attaching our entire AppColors
    // definition to the theme, making it accessible throughout the app.
    extensions: <ThemeExtension<dynamic>>[lightAppColors],

    // 6. CONFIGURE SUB-THEMES FOR CONSISTENCY
    // These settings apply a consistent, shadcn-like feel (e.g., sharp corners,
    // no elevation) to all standard Material components.
    subThemesData: const FlexSubThemesData(
      // General
      defaultRadius: 8.0,
      // Buttons
      elevatedButtonElevation: 0,
      outlinedButtonBorderWidth: 1.0,
      // Inputs
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorBorderWidth: 1.0,
      // Cards
      cardElevation: 0,
    ),

    fontFamily: GoogleFonts.lexend().fontFamily,
    useMaterial3: true,
  );

  // --- DARK THEME ---
  static ThemeData darkTheme = FlexThemeData.dark(
    // 1. USE COLORS FROM YOUR AppColors DEFINITION
    primary: darkAppColors.primary,
    scaffoldBackground: darkAppColors.background,

    // 2. STOP UNWANTED COLOR MIXING
    blendLevel: 0,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,

    // 3. DISABLE M3 KEY COLORS & HARMONIZATION
    keyColors: const FlexKeyColors(useKeyColors: false),

    // 4. STYLE THE APP BAR
    appBarStyle: FlexAppBarStyle.background,
    appBarElevation: 0,

    // 5. ATTACH YOUR CUSTOM THEME EXTENSION
    extensions: <ThemeExtension<dynamic>>[darkAppColors],

    // 6. CONFIGURE SUB-THEMES
    subThemesData: const FlexSubThemesData(
      defaultRadius: 8.0,
      elevatedButtonElevation: 0,
      outlinedButtonBorderWidth: 1.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorBorderWidth: 1.0,
      cardElevation: 0,
    ),

    fontFamily: GoogleFonts.manrope().fontFamily,
    textTheme: GoogleFonts.manropeTextTheme().copyWith(
      displayLarge: GoogleFonts.manrope(letterSpacing: 0.3),
      displayMedium: GoogleFonts.manrope(letterSpacing: 0.3),
      displaySmall: GoogleFonts.manrope(letterSpacing: 0.3),
      headlineLarge: GoogleFonts.manrope(letterSpacing: 0.3),
      headlineMedium: GoogleFonts.manrope(letterSpacing: 0.3),
      headlineSmall: GoogleFonts.manrope(letterSpacing: 0.3),
      titleLarge: GoogleFonts.manrope(letterSpacing: 0.3),
      titleMedium: GoogleFonts.manrope(letterSpacing: 0.3),
      titleSmall: GoogleFonts.manrope(letterSpacing: 0.3),
      bodyLarge: GoogleFonts.manrope(letterSpacing: 0.3),
      bodyMedium: GoogleFonts.manrope(letterSpacing: 0.3),
      bodySmall: GoogleFonts.manrope(letterSpacing: 0.3),
      labelLarge: GoogleFonts.manrope(letterSpacing: 0.3),
      labelMedium: GoogleFonts.manrope(letterSpacing: 0.3),
      labelSmall: GoogleFonts.manrope(letterSpacing: 0.3),
    ),
    useMaterial3: true,
  );
}
