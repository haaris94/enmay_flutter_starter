# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

All commands use the scripts defined in `pubspec.yaml`:

### Code Generation

- `dart run build_runner build --delete-conflicting-outputs` - Generate code (Riverpod, Freezed, JSON serialization)
- `dart run build_runner watch --delete-conflicting-outputs` - Watch mode for continuous generation
- `dart run build_runner clean` - Clean generated files

### Testing & Analysis

- `flutter test` - Run all tests
- `flutter test --coverage` - Run tests with coverage
- `flutter analyze` - Run static analysis
- `dart format lib/ test/` - Format code
- `dart format --set-exit-if-changed lib/ test/` - Check code formatting

### Platform-Specific

- `cd ios && pod install --repo-update` - Install iOS dependencies
- `cd ios && pod deintegrate && pod install` - Clean iOS pods
- `cd android && ./gradlew clean` - Clean Android build

### Setup Commands

- `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs` - Basic setup
- `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs && cd ios && pod install` - Full setup with iOS

## Architecture

### State Management

- Uses **Riverpod 3.0** with code generation
- All providers use `@Riverpod()` annotation and generate `.g.dart` files
- Providers are organized in feature-specific directories
- Service providers are centralized in `lib/src/providers/services/`

### Project Structure

```
lib/src/
├── app/                        # App-level configuration
│   ├── routing/               # GoRouter configuration with route guards
│   ├── startup/               # App initialization logic
│   └── theme/                 # FlexColorScheme theme system
├── core/                      # Shared utilities and widgets
│   ├── constants/             # App constants and enums
│   ├── exceptions/            # Error handling and custom exceptions
│   ├── network/               # Dio HTTP client and interceptors
│   ├── utils/                 # Utility functions and extensions
│   └── widgets/               # Reusable UI components
├── data/                      # Data layer
│   ├── models/                # Data models with Freezed
│   └── repositories/          # Repository implementations
├── features/                  # Feature modules
│   ├── auth/                  # Authentication feature
│   ├── home/                  # Home screen feature
│   └── paywall/               # In-app purchase paywall
└── providers/                 # Global providers
    └── services/              # Service provider definitions
```

### Key Features

#### Authentication

- Firebase Auth integration with Google Sign-In
- Route guards prevent unauthorized access
- Auth state managed through Riverpod providers
- Supports email/password and Google OAuth

#### Paywall System

- Complete RevenueCat integration for in-app purchases
- Configurable paywall UI with hero animations
- Product management and subscription handling
- Comprehensive testing guide in `docs/paywall/testing-guide.md`

#### Theming

- FlexColorScheme with Material 3 support
- Dynamic theme switching (light/dark/system/high contrast)
- Theme state persisted with SharedPreferences
- Detailed theme documentation in `lib/src/app/theme/README.md`

#### Routing

- GoRouter with declarative routing
- Route guards for authentication
- Centralized route definitions with type-safe navigation

#### Error Handling

- Global error handling with custom exceptions
- Crashlytics integration for production error tracking
- Context-aware error messages
- Comprehensive failure types and error recovery

### Code Generation Dependencies

This project heavily uses code generation. Always run code generation after:

- Adding new Riverpod providers
- Modifying Freezed models
- Updating JSON serializable classes
- Changing route definitions

### Testing

- Widget tests for UI components
- Unit tests for business logic
- Integration tests for complete user flows
- Paywall-specific testing scenarios documented
- Mock implementations available for testing

### Firebase Integration

- Firebase Core, Auth, Crashlytics, and Firestore
- Configuration files: `lib/firebase_options.dart`
- Development and production environments supported

### Dependencies Management

- Uses specific versions for core dependencies
- FlexColorScheme for theming
- Riverpod for state management
- GoRouter for navigation
- Dio for HTTP requests
- Freezed for immutable data classes

## Development Notes

### Before Making Changes

1. Run `flutter pub get` to ensure dependencies are installed
2. Run code generation if working with providers, models, or routes
3. Check existing patterns in similar features before implementing new functionality

### After Making Changes

1. Run `flutter analyze` to check for issues
2. Run `flutter test` to ensure tests pass
3. Re-run code generation if you modified generated code dependencies
4. Format code with `dart format`

### iOS Development

- Requires Xcode and CocoaPods
- Run pod install after dependency changes
- Firebase configuration: `ios/Runner/GoogleService-Info.plist`

### Android Development  

- Firebase configuration: `android/app/google-services.json`
- Minimum SDK version specified in build files
