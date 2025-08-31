import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand color
  static const Color primary = Color(0xFFFF6348);

  // Semantic colors (same across themes)
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // shadcn-inspired grays (these get used by FlexColorScheme automatically)
  static const Color lightGray50 = Color(0xFFFAFAFA);
  static const Color lightGray100 = Color(0xFFF4F4F5);
  static const Color lightGray200 = Color(0xFFE4E4E7);
  static const Color lightGray300 = Color(0xFFD4D4D8);
  static const Color lightGray400 = Color(0xFFA1A1AA);
  static const Color lightGray500 = Color(0xFF71717A);
  static const Color lightGray600 = Color(0xFF52525B);
  static const Color lightGray700 = Color(0xFF3F3F46);
  static const Color lightGray800 = Color(0xFF27272A);
  static const Color lightGray900 = Color(0xFF18181B);

  // Dark theme grays
  static const Color darkGray50 = Color(0xFF18181B);
  static const Color darkGray100 = Color(0xFF27272A);
  static const Color darkGray200 = Color(0xFF3F3F46);
  static const Color darkGray300 = Color(0xFF52525B);
  static const Color darkGray400 = Color(0xFF71717A);
  static const Color darkGray500 = Color(0xFFA1A1AA);
  static const Color darkGray600 = Color(0xFFD4D4D8);
  static const Color darkGray700 = Color(0xFFE4E4E7);
  static const Color darkGray800 = Color(0xFFF4F4F5);
  static const Color darkGray900 = Color(0xFFFAFAFA);
}


// Semantic color widgets for consistent usage
class SemanticColors {
  static Color success(BuildContext context) => AppColors.success;
  static Color warning(BuildContext context) => AppColors.warning;
  static Color error(BuildContext context) => AppColors.error;
  static Color info(BuildContext context) => AppColors.info;

  // Background variants for semantic colors
  static Color successBackground(BuildContext context) => success(context).withValues(alpha: 0.1);
  static Color warningBackground(BuildContext context) => warning(context).withValues(alpha: 0.1);
  static Color errorBackground(BuildContext context) => error(context).withValues(alpha: 0.1);
  static Color infoBackground(BuildContext context) => info(context).withValues(alpha: 0.1);
}
