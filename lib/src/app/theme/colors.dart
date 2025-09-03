// ignore_for_file: unused_field
import 'package:flutter/material.dart';

/// --------------------------------------------------------------------------
/// RAW COLOR PALETTE
/// --------------------------------------------------------------------------
/// This private class holds the static, raw color values from your design system.
/// Naming convention is `colorName` + `shade`. For example, `green90`, `neutral100`.
/// This class should not be used directly in widgets. Instead, it acts as the
/// single source of truth for the semantic color assignments in the AppColors class.
///
class _RawColors {
  _RawColors._();

  // --- Primary Green Palette ---
  static const Color green90 = Color(0xFFE9EEDD);
  static const Color green80 = Color(0xFFD3DBBB);
  static const Color green70 = Color(0xFFBCCBAA);
  static const Color green60 = Color(0xFFA6B478);
  static const Color green50 = Color(0xFF90A966);
  static const Color green40 = Color(0xFF6B8157);
  static const Color green30 = Color(0xFF566534);
  static const Color green20 = Color(0xFF3A4323);
  static const Color green10 = Color(0xFF1D2211);

  // --- Backgrounds ---
  static const Color lightBg = Color(0xFFF6F2EF);
  static const Color darkBg = Color(0xFF101214);

  // --- Neutrals (Generated to complement the backgrounds) ---
  // A neutral palette is crucial for text, borders, and subtle containers.
  // These are slightly warm to match the provided `lightBg`.
  static const Color neutral100 = Color(0xFFF3F4F6); // Very light gray
  static const Color neutral200 = Color(0xFFE5E7EB); // Light gray for borders
  static const Color neutral400 = Color(0xFF9CA3AF); // Mid-gray for muted text
  static const Color neutral700 = Color(0xFF374151); // Dark gray for secondary elements
  static const Color neutral800 = Color(0xFF1F2937); // Darker gray for containers in dark mode
  static const Color neutral900 = Color(0xFF111827); // Near-black for main text

  // --- Semantics ---
  // Standard colors for conveying meaning, like errors or warnings.
  // Using two shades ensures good contrast in both light and dark themes.
  static const Color semanticRed = Color(0xFFDC2626); // For "destructive" in light mode
  static const Color semanticRedDark = Color(0xFFF87171); // For "destructive" in dark mode
}


/// --------------------------------------------------------------------------
/// SEMANTIC THEME EXTENSION: AppColors
/// --------------------------------------------------------------------------
/// This is the heart of your color system. It's a Flutter `ThemeExtension`
/// that defines semantic color roles, abstracting away the raw hex values.
///
/// Instead of using `Colors.blue` or a raw `Color(0xFF...)`, you'll access colors
/// via context like this: `Theme.of(context).extension<AppColors>()!.primary`.
///
/// This makes your UI code readable, maintainable, and theme-aware.
///
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.foreground,
    required this.container,
    required this.containerForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.border,
    required this.input,
    required this.ring,
  });

  /// The primary background color for the entire application scaffold.
  ///
  /// **Design Convention:** In light mode, this is your lightest color (e.g., white or off-white).
  /// In dark mode, it's your darkest color (e.g., near-black).
  final Color? background;

  /// The primary text and icon color that sits on top of `background`.
  ///
  /// **Design Convention:** This should have a high contrast ratio with `background`
  /// for accessibility (e.g., black on white, white on black).
  final Color? foreground;

  /// A surface color for elements that sit on top of the main `background`.
  ///
  /// **Usage:** This single variable is used for Cards, Sidebars, Popovers, and Dialogs
  /// to ensure a consistent layering effect in the UI.
  /// It's often the same as `background` or a very subtle shade different.
  final Color? container;

  /// The default text color for content within a `container`.
  ///
  /// **Design Convention:** Typically the same as `foreground`.
  final Color? containerForeground;

  /// The main brand color, used for primary interactive elements.
  ///
  /// **Usage:** Primary buttons, active navigation links, focused input borders, etc.
  /// This color should be prominent and signal the main call-to-action.
  final Color? primary;

  /// The color for text and icons placed on top of `primary` background elements.
  ///
  /// **Design Convention:** Must have high contrast with `primary`. If `primary` is a
  /// dark green, `primaryForeground` should be white.
  final Color? primaryForeground;

  /// A color for secondary interactive elements that need to be less prominent.
  ///
  /// **Usage:** Secondary buttons, inactive tabs, or filter chips.
  /// Often a lighter shade of the primary color or a subtle gray.
  final Color? secondary;

  /// The color for text and icons placed on top of `secondary` background elements.
  final Color? secondaryForeground;
  
  /// A subtle text color for non-interactive, de-emphasized content.
  ///
  /// **Usage:** Helper text below an input field, placeholder text, subtitles, or metadata.
  final Color? mutedForeground;

  /// A subtle background color for elements that are hovered or selected.
  ///
  /// **Usage:** Hover state on list items, background of a selected navigation item.
  /// Often the same color as `secondary`.
  final Color? accent;

  /// The text color for content on top of an `accent` background.
  final Color? accentForeground;

  /// A color used to indicate a destructive or dangerous action.
  ///
  /// **Usage:** Delete buttons, error messages, and critical alerts. Almost always a shade of red.
  final Color? destructive;

  /// A color for subtle borders, dividers, and separators.
  ///
  ///**Usage:** `<hr>` lines, borders on cards, or separating list items.
  final Color? border;

  /// The border color for input fields like `TextField`.
  ///
  /// **Design Convention:** Often the same as `border`, but can be different to make
  /// inputs stand out more.
  final Color? input;

  /// The color of the focus indicator outline.
  ///
  /// **Usage:** Displayed when a user tabs onto an interactive element.
  /// This is crucial for accessibility. It should be a high-contrast color, often `primary`.
  final Color? ring;


  @override
  AppColors copyWith({
    Color? background,
    Color? foreground,
    Color? container,
    Color? containerForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? border,
    Color? input,
    Color? ring,
  }) {
    return AppColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      container: container ?? this.container,
      containerForeground: containerForeground ?? this.containerForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t),
      foreground: Color.lerp(foreground, other.foreground, t),
      container: Color.lerp(container, other.container, t),
      containerForeground: Color.lerp(containerForeground, other.containerForeground, t),
      primary: Color.lerp(primary, other.primary, t),
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t),
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t),
      accent: Color.lerp(accent, other.accent, t),
      accentForeground: Color.lerp(accentForeground, other.accentForeground, t),
      destructive: Color.lerp(destructive, other.destructive, t),
      border: Color.lerp(border, other.border, t),
      input: Color.lerp(input, other.input, t),
      ring: Color.lerp(ring, other.ring, t),
    );
  }
}


/// --------------------------------------------------------------------------
/// THEME DEFINITIONS
/// --------------------------------------------------------------------------
/// These are the concrete implementations of your AppColors for light and dark themes.
/// You will pass these instances to your `ThemeData` objects.

final AppColors lightAppColors = AppColors(
  background: _RawColors.lightBg,
  foreground: _RawColors.neutral900,
  container: _RawColors.neutral100,
  containerForeground: _RawColors.neutral900,
  primary: _RawColors.green50,
  primaryForeground: _RawColors.green10,
  secondary: _RawColors.green90,
  secondaryForeground: _RawColors.green20,
  mutedForeground: _RawColors.neutral400,
  accent: _RawColors.green90,
  accentForeground: _RawColors.green20,
  destructive: _RawColors.semanticRed,
  border: _RawColors.neutral200,
  input: _RawColors.neutral200,
  ring: _RawColors.green50,
);

final AppColors darkAppColors = AppColors(
  background: _RawColors.darkBg,
  foreground: _RawColors.neutral100,
  container: _RawColors.neutral800,
  containerForeground: _RawColors.neutral100,
  primary: _RawColors.green60, // Brighter for better contrast in dark mode
  primaryForeground: _RawColors.green10,
  secondary: _RawColors.neutral700,
  secondaryForeground: _RawColors.neutral100,
  mutedForeground: _RawColors.neutral400,
  accent: _RawColors.neutral700,
  accentForeground: _RawColors.neutral100,
  destructive: _RawColors.semanticRedDark,
  border: _RawColors.neutral700,
  input: _RawColors.neutral700,
  ring: _RawColors.green60,
);
