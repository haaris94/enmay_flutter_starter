# Flutter Theme System with FlexColorScheme

This directory contains a comprehensive theming system built with FlexColorScheme and Riverpod state management.

## 🏗️ Architecture

```bash
lib/core/theme/
├── app_theme.dart              # Main theme configurations
├── theme_providers.dart        # Riverpod providers for theme management
├── widgets/
│   └── theme_switcher.dart     # Theme switching UI components
├── widget_themes/              # Individual widget theme configurations
│   ├── app_bar_theme.dart
│   ├── card_theme.dart
│   ├── elevated_button_theme.dart
│   ├── floating_action_button_theme.dart
│   ├── input_decoration_theme.dart
│   ├── outlined_button_theme.dart
│   └── text_button_theme.dart
└── README.md                   # This file
```

## ✨ Features

### Theme Modes

- **Light Theme**: Standard light theme with Material 3 colors
- **Dark Theme**: Dark theme with appropriate contrast adjustments  
- **System Theme**: Follows system theme preference
- **High Contrast**: Accessibility-focused high contrast variants for both light and dark

### FlexColorScheme Integration

- Material 3 compliance out of the box
- Advanced color scheme generation
- Professional surface tinting and elevation
- Consistent component theming across the app

### Riverpod State Management

- Reactive theme switching
- Persistent theme preferences
- Type-safe theme providers
- Automatic UI updates when theme changes

## 🚀 Usage

### Basic Setup

The theme system is already integrated into `main.dart`:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final lightTheme = ref.watch(lightThemeProvider);
  final darkTheme = ref.watch(darkThemeProvider);
  final themeMode = ref.watch(themeModeProvider);

  return MaterialApp.router(
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: themeMode,
    // ... other properties
  );
}
```

### Theme Switching

Use the provided theme providers to change themes:

```dart
// Toggle between light and dark
ref.read(themeModeNotifierProvider.notifier).toggleTheme();

// Set specific theme mode
ref.read(themeModeNotifierProvider.notifier).setThemeMode(AppThemeMode.dark);

// Enable high contrast
ref.read(themeModeNotifierProvider.notifier).enableHighContrast(true);
```

### Theme-Aware Colors

Access theme-aware colors using the `appColorsProvider`:

```dart
final appColors = ref.watch(appColorsProvider);

Container(
  color: appColors.success, // Automatically adapts to current theme
  child: Text('Success message'),
)
```

### UI Components

#### Theme Switcher

Full-featured theme selection widget:

```dart
import 'package:flutter_starter/core/theme/widgets/theme_switcher.dart';

ThemeSwitcher() // Complete theme switching interface
```

#### Theme Toggle Button

Simple toggle button for app bars:

```dart
ThemeToggleButton() // Simple light/dark toggle
```

#### Theme Preview

Preview widget showing current theme:

```dart
ThemePreviewCard() // Shows colors and components in current theme
```

## 🎨 Customization

### Adding New Theme Modes

- Add new mode to `AppThemeMode` enum:

```dart
enum AppThemeMode {
  light,
  dark,
  system,
  highContrastLight,
  highContrastDark,
  customMode, // New mode
}
```

- Implement theme in `AppTheme` class:

```dart
static ThemeData get customTheme {
  return FlexThemeData.light(
    // Your custom theme configuration
  );
}
```

- Update providers to handle new mode.

### Customizing Colors

Update the seed colors in `AppTheme`:

```dart
static const Color primarySeedColor = Color(0xYOUR_COLOR);
static const Color secondarySeedColor = Color(0xYOUR_COLOR);
static const Color tertiarySeedColor = Color(0xYOUR_COLOR);
```

### Widget-Specific Themes

Each widget theme is modular and can be customized independently:

```dart
// In widget_themes/card_theme.dart
static CardThemeData customCardTheme = CardThemeData(
  elevation: 8,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  // ... other properties
);
```

## 🔧 Advanced Configuration

### FlexColorScheme Options

The theme system uses FlexColorScheme with these key configurations:

- **Surface Mode**: `FlexSurfaceMode.levelSurfacesLowScaffold` for subtle surface tinting
- **Blend Level**: `7` for optimal color blending
- **Visual Density**: Comfortable platform density for better touch targets
- **Component Themes**: Consistent styling across all Material components

### Accessibility Features

- High contrast modes for improved visibility
- Appropriate color contrast ratios
- Semantic color usage (success, warning, error, info)
- Touch-friendly component sizing

## 📱 Responsive Design

The theme system works seamlessly across different screen sizes and orientations:

- Adaptive component sizing
- Appropriate elevation levels
- Platform-specific visual density
- Touch target optimization

## 🧪 Testing

Test theme changes using provider overrides:

```dart
ProviderScope(
  overrides: [
    themeModeNotifierProvider.overrideWith(
      () => ThemeModeNotifier()..state = AppThemeMode.dark,
    ),
  ],
  child: MyApp(),
)
```

## 🔮 Future Enhancements

- Dynamic color extraction from wallpaper (Android 12+)
- Custom color scheme generator
- Theme animation transitions
- Per-feature theme customization
- Theme marketplace/presets

## 📚 Resources

- [FlexColorScheme Documentation](https://docs.flexcolorscheme.com/)
- [Material 3 Design System](https://m3.material.io/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Theming Guide](https://docs.flutter.dev/cookbook/design/themes)
