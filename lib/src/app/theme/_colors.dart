import 'package:flutter/material.dart';

// --- Core Palette ---
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);

// --- Light Mode Colors ---
abstract class LightColors {
  // Backgrounds
  static const Color background = white; // White background
  static const Color card = Color(0xFFF2F2F7); // Slightly off-white for cards/surfaces

  // Text & Icons
  static const Color primaryText = black; // Black text
  static const Color secondaryText = Color(0xFF6B7280); // Gray for secondary text/icons
  static const Color tertiaryText = Color(0xFF9CA3AF); // Lighter gray

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB); // Light gray border

  // Primary Accent (Blue)
  static const Color primary = Color(0xFF3B82F6); // Blue accent
  static const Color primaryForeground = white; // Text/icons on primary color

  // Destructive (Red - Optional but common)
  // static const Color destructive = Color(0xFFEF4444);
  // static const Color destructiveForeground = _white;
}

// --- Dark Mode Colors ---
abstract class DarkColors {
  // Backgrounds
  static const Color background = black; // Black background
  static const Color card = Color(0xFF1C1C1E); // Dark gray for cards/surfaces

  // Text & Icons
  static const Color primaryText = white; // White text
  static const Color secondaryText = Color(0xFF9CA3AF); // Gray for secondary text/icons
  static const Color tertiaryText = Color(0xFF6B7280); // Darker gray

  // Borders & Dividers
  static const Color border = Color(0xFF374151); // Dark gray border

  // Primary Accent (Blue)
  static const Color primary = Color(0xFF60A5FA); // Lighter blue accent for dark mode
  static const Color primaryForeground = black; // Text/icons on primary color

  // Destructive (Red - Optional but common)
  // static const Color destructive = Color(0xFFF87171);
  // static const Color destructiveForeground = _black;
}
