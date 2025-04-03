import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '_colors.dart'; // Import colors for text styling

// Define base TextTheme for light mode
TextTheme lightTextTheme = TextTheme(
  displayLarge: GoogleFonts.manrope(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: LightColors.primaryText,
  ),
  displayMedium: GoogleFonts.manrope(fontSize: 45, fontWeight: FontWeight.w400, color: LightColors.primaryText),
  displaySmall: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w400, color: LightColors.primaryText),
  headlineLarge: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w400, color: LightColors.primaryText),
  headlineMedium: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w400, color: LightColors.primaryText),
  headlineSmall: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w400, color: LightColors.primaryText),
  titleLarge: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w500, color: LightColors.primaryText),
  titleMedium: GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: LightColors.primaryText,
  ),
  titleSmall: GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: LightColors.primaryText,
  ),
  bodyLarge: GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: LightColors.primaryText,
  ),
  bodyMedium: GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: LightColors.primaryText,
  ),
  bodySmall: GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: LightColors.secondaryText,
  ), // Often used for captions
  labelLarge: GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    color: LightColors.primaryText,
  ), // Buttons
  labelMedium: GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: LightColors.secondaryText,
  ),
  labelSmall: GoogleFonts.manrope(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: LightColors.secondaryText,
  ), // Overlines
);

// Define base TextTheme for dark mode (adjust colors)
TextTheme darkTextTheme = TextTheme(
  displayLarge: lightTextTheme.displayLarge?.copyWith(color: DarkColors.primaryText),
  displayMedium: lightTextTheme.displayMedium?.copyWith(color: DarkColors.primaryText),
  displaySmall: lightTextTheme.displaySmall?.copyWith(color: DarkColors.primaryText),
  headlineLarge: lightTextTheme.headlineLarge?.copyWith(color: DarkColors.primaryText),
  headlineMedium: lightTextTheme.headlineMedium?.copyWith(color: DarkColors.primaryText),
  headlineSmall: lightTextTheme.headlineSmall?.copyWith(color: DarkColors.primaryText),
  titleLarge: lightTextTheme.titleLarge?.copyWith(color: DarkColors.primaryText),
  titleMedium: lightTextTheme.titleMedium?.copyWith(color: DarkColors.primaryText),
  titleSmall: lightTextTheme.titleSmall?.copyWith(color: DarkColors.primaryText),
  bodyLarge: lightTextTheme.bodyLarge?.copyWith(color: DarkColors.primaryText),
  bodyMedium: lightTextTheme.bodyMedium?.copyWith(color: DarkColors.primaryText),
  bodySmall: lightTextTheme.bodySmall?.copyWith(color: DarkColors.secondaryText),
  labelLarge: lightTextTheme.labelLarge?.copyWith(color: DarkColors.primaryText),
  labelMedium: lightTextTheme.labelMedium?.copyWith(color: DarkColors.secondaryText),
  labelSmall: lightTextTheme.labelSmall?.copyWith(color: DarkColors.secondaryText),
);
