# New Project Setup

Follow these steps when setting up a new project from this starter template:

## 1. Initial Setup

```bash
# Basic setup (dependencies + code generation)
flutter pub run setup:new

# Full setup (includes iOS pods)
flutter pub run setup:full
```

## 2. Change Package Name

- Use this command to change package name: `flutter pub run change:package com.new.package.name`
- Replace `com.new.package.name` with your desired package name

## 3. Update Project Metadata

- Update `name` and `description` in `pubspec.yaml`
- Update app name in platform-specific files:
  - Android: `android/app/src/main/res/values/strings.xml`
  - iOS: Open `ios/Runner.xcworkspace` and update display name

## 4. Firebase Configuration

- Create a new Firebase project in Firebase console
- Enable Authentication, Firestore, and Crashlytics
- Use `flutterfire configure` to connect the project to your app
- This will generate/update:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`

## 5. Platform-Specific Setup

### iOS Setup

```bash
flutter pub run ios:setup
```

### Android Setup

- Verify `android/app/google-services.json` is properly configured
- Update app icon and splash screen if needed

## 6. Revenue Cat (Optional)

If using the paywall feature:

- Create a RevenueCat account
- Configure your products and entitlements
- Update the RevenueCat API keys in your environment variables

## 7. Environment Configuration

- Create `.env` file for environment variables
- Configure development vs production settings
- Update theme colors and branding in `lib/src/app/theme/`

## 8. Final Verification

```bash
# Run analysis and tests
flutter pub run setup:verify

# Test on both platforms
flutter run
```

## 9. Version Control

- Update this README with project-specific information
- Remove template-specific content
- Set up your Git repository and make initial commit
