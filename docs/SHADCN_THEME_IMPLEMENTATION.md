# Shadcn Theme Implementation Plan

## Overview

This document outlines the changes needed to implement the shadcn color scheme in the Flutter theme system. The shadcn CSS variables will be converted to Flutter colors and integrated with the existing FlexColorScheme setup.

## Color Conversions

### Light Theme Colors (from CSS OKLCH to Flutter)

- **Background**: `oklch(0.9885 0.0057 84.5659)` → `Color(0xFFFCFBF9)`
- **Foreground**: `oklch(0.3660 0.0251 49.6085)` → `Color(0xFF3B3A37)`
- **Card**: `oklch(0.9686 0.0091 78.2818)` → `Color(0xFFF8F6F3)`
- **Primary**: `oklch(0.5553 0.1455 48.9975)` → `Color(0xFFB45F47)`
- **Secondary**: `oklch(0.8276 0.0752 74.4400)` → `Color(0xFFD4C4B0)`
- **Muted**: `oklch(0.9363 0.0218 83.2637)` → `Color(0xFFF2F0ED)`
- **Accent**: `oklch(0.9000 0.0500 74.9889)` → `Color(0xFFE8DED0)`
- **Destructive**: `oklch(0.4437 0.1613 26.8994)` → `Color(0xFF9B3B1C)`
- **Border**: `oklch(0.8866 0.0404 89.6994)` → `Color(0xFFE8E3D8)`

### Dark Theme Colors

- **Background**: `oklch(0.2161 0.0061 56.0434)` → `Color(0xFF1A1917)`
- **Foreground**: `oklch(0.9699 0.0013 106.4238)` → `Color(0xFFF7F7F6)`
- **Card**: `oklch(0.2685 0.0063 34.2976)` → `Color(0xFF232119)`
- **Primary**: `oklch(0.7049 0.1867 47.6044)` → `Color(0xFFD4855A)`
- **Secondary**: `oklch(0.4444 0.0096 73.6390)` → `Color(0xFF5A5A57)`
- **Muted**: `oklch(0.2685 0.0063 34.2976)` → `Color(0xFF232119)`
- **Accent**: `oklch(0.3598 0.0497 229.3202)` → `Color(0xFF3D4B5C)`
- **Destructive**: `oklch(0.5771 0.2152 27.3250)` → `Color(0xFFCB5A35)`
- **Border**: `oklch(0.3741 0.0087 67.5582)` → `Color(0xFF3E3C37)`

## Font Changes

- **Primary Font**: Change from 'Inter' to 'Oxanium'
- **Serif Font**: Add 'Merriweather' (optional)
- **Mono Font**: Add 'Fira Code' (optional)

## Radius Changes

- **Card Radius**: Change from 8 to 5 (0.3rem ≈ 4.8px, rounded to 5)
- **Button Radius**: Change from 6 to 5
- **Input Radius**: Change from 6 to 5
- **Dialog Radius**: Change from 12 to 8
- **FAB Radius**: Change from 12 to 8

## Implementation Changes Required

### 1. Update `colors.dart`

- Add new shadcn color palette alongside existing colors
- Create conversion utilities for OKLCH colors
- Maintain backward compatibility with existing semantic colors

### 2. Update `app_theme.dart`

- Replace existing color scheme with shadcn colors
- Update font family to Oxanium
- Adjust radius values to match shadcn design
- Add new color extension methods for shadcn-specific colors

### 3. Add to `pubspec.yaml`

- Add Oxanium font family
- Optionally add Merriweather and Fira Code fonts

### 4. New Color Categories to Add

- **Sidebar colors**: For potential sidebar components
- **Chart colors**: For data visualization
- **Input/Ring colors**: For form styling
- **Popover colors**: For overlay components

## Benefits

1. **Modern Design**: Shadcn's design system is widely adopted and modern
2. **Consistency**: Better color harmony across components
3. **Accessibility**: OKLCH color space provides better perceptual uniformity
4. **Extensibility**: Easy to add new shadcn components later

## Migration Strategy

1. Create new color definitions alongside existing ones
2. Update theme gradually, component by component
3. Test both light and dark themes thoroughly
4. Maintain existing semantic colors for backward compatibility

## Files to Modify

1. `lib/src/app/theme/colors.dart` - Add shadcn color palette
2. `lib/src/app/theme/app_theme.dart` - Update theme configuration
3. `pubspec.yaml` - Add new fonts
4. Test files - Verify color changes don't break existing UI

Would you like me to proceed with implementing these changes?
