# Flutter Starter - Cross-Platform Development Guide

This project is configured for seamless development across multiple machines (Windows PC and M1 Mac) with minimal setup friction.

## Quick Start (After Git Pull)

```bash
# First time setup on new machine
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# iOS only (Mac only)
cd ios && pod install
```

## Development Scripts

Use these consistent commands across all platforms:

### Code Generation
```bash
# Generate all files (run this after pulling changes)
flutter pub run generate

# Watch for changes during development  
flutter pub run generate:watch

# Clean generated files
flutter pub run generate:clean
```

### Testing & Quality
```bash
# Run tests
flutter pub run test

# Run tests with coverage
flutter pub run test:coverage

# Analyze code
flutter pub run analyze

# Format code
flutter pub run format

# Check formatting
flutter pub run format:check
```

### Platform-Specific Commands
```bash
# iOS (Mac only)
flutter pub run ios:pods        # Update pods
flutter pub run ios:clean       # Clean and reinstall pods

# Android
flutter pub run android:clean   # Clean Android build
```

### Full Reset Commands
```bash
# Quick setup after pull
flutter pub run setup

# Full fresh install (includes iOS pods)
flutter pub run fresh
```

## Cross-Platform Workflow

### When Switching Machines

1. **Commit your changes** on current machine:
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

2. **On the other machine**:
   ```bash
   git pull
   flutter pub run setup    # Auto-generates all files
   ```

3. **iOS-specific (Mac only)**:
   ```bash
   flutter pub run ios:pods  # Only if iOS dependencies changed
   ```

### What's Already Configured

✅ **Generated files**: All `*.g.dart` and `*.freezed.dart` files are ignored in git  
✅ **Dependencies**: `pubspec.lock` is committed for version consistency  
✅ **iOS Dependencies**: `Podfile.lock` is committed for consistent iOS builds  
✅ **Firebase**: Configuration is already committed and ready to use  
✅ **Build runner**: Automatically generates required files  

### Dependencies Used

- **State Management**: Riverpod with code generation
- **Routing**: Go Router  
- **JSON Serialization**: json_annotation + build_runner
- **Immutable Models**: Freezed
- **UI**: Material 3 with Flex Color Scheme
- **Firebase**: Auth, Firestore, Crashlytics
- **Forms**: Reactive Forms
- **Payments**: In-App Purchase

## Troubleshooting

### Generated Files Missing
```bash
dart run build_runner build --delete-conflicting-outputs
```

### iOS Build Issues (Mac)
```bash
cd ios
pod deintegrate
pod install
```

### Clean Slate Reset
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ios && pod install  # Mac only
```

### Windows-Specific Issues
- Ensure Flutter is in PATH
- Run commands in PowerShell or CMD as Administrator if needed
- Use `flutter doctor` to verify setup

### Mac-Specific Issues  
- Ensure Xcode Command Line Tools are installed: `xcode-select --install`
- For M1 Macs, ensure CocoaPods is compatible: `arch -x86_64 pod install`

## Git Hooks (Optional)

To automatically run code generation on git operations, you can add these hooks:

### Pre-commit hook
```bash
#!/bin/sh
dart run build_runner build --delete-conflicting-outputs
git add **/*.g.dart **/*.freezed.dart
```

### Post-merge hook  
```bash
#!/bin/sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## IDE Configuration

### VS Code
Recommended extensions:
- Flutter
- Dart
- Awesome Flutter Snippets

### Android Studio/IntelliJ
- Flutter plugin
- Dart plugin

## Commands Reference

| Task | Command |
|------|---------|
| Initial setup | `flutter pub run setup` |
| Generate code | `flutter pub run generate` |
| Watch changes | `flutter pub run generate:watch` |
| Run tests | `flutter pub run test` |
| Format code | `flutter pub run format` |
| iOS pods update | `flutter pub run ios:pods` |
| Full reset | `flutter pub run fresh` |