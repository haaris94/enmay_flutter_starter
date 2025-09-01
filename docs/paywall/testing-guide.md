# Paywall Testing Guide

This guide covers how to test the paywall functionality during development and before production release.

## Development Testing (Without Store Integration)

### 1. Mock Mode Testing

For initial development, you can test the paywall UI without actual store integration:

```dart
// In PaywallLocalDataSource, modify getDefaultConfig() for testing
PaywallConfig getDefaultConfig() {
  return const PaywallConfig(
    title: 'Unlock Premium Access',
    features: [
      PaywallFeature(title: 'Remove ads', iconName: 'shield'),
      PaywallFeature(title: 'Unlimited exports', iconName: 'infinity'),
      PaywallFeature(title: 'Priority support', iconName: 'star'),
      PaywallFeature(title: 'Advanced features', iconName: 'rocket'),
    ],
    products: [
      PurchaseProduct(
        id: 'test_yearly',
        price: '\$29.99',
        duration: 'year',
        planName: 'Yearly Plan',
        hasTrial: false,
      ),
      PurchaseProduct(
        id: 'test_weekly_trial',
        price: '\$4.99',
        duration: 'week',
        planName: '3-Day Trial',
        hasTrial: true,
      ),
    ],
    heroImagePath: 'assets/images/paywall_hero.png',
    cooldownDuration: 3.0, // Shorter for testing
    termsUrl: 'https://your-app.com/terms',
    privacyUrl: 'https://your-app.com/privacy',
  );
}
```

### 2. Test Navigation

Add a button to your home screen to easily access the paywall:

```dart
// In HomeScreen, add this button for testing
ElevatedButton(
  onPressed: () => context.go('/paywall'),
  child: const Text('Test Paywall'),
),
```

### 3. Test Different States

Test various paywall states by modifying the initial state:

```dart
// Test loading state
return PaywallState(
  isLoading: true,
  products: [],
);

// Test error state
return PaywallState(
  errorMessage: 'Failed to load products',
  products: [],
);

// Test subscribed state
return PaywallState(
  isSubscribed: true,
  products: products,
);
```

## iOS Sandbox Testing

### 1. Set Up Test Users

1. Go to App Store Connect
2. Navigate to **Users and Access** → **Sandbox Testers**
3. Create test users with different regions/currencies

### 2. Configure Test Environment

```dart
// Add debug flag for testing
class PaywallConfig {
  static const bool isTestMode = true; // Set to false for production
  static const List<String> testProductIds = [
    'test_weekly_trial',
    'test_yearly',
  ];
  static const List<String> prodProductIds = [
    'your_app_weekly_trial',
    'your_app_yearly',
  ];
  
  static List<String> get productIds => 
    isTestMode ? testProductIds : prodProductIds;
}
```

### 3. Testing Scenarios

#### Purchase Flow Testing

1. Launch app on simulator/device
2. Sign out of App Store (Settings → App Store → Sign Out)
3. Open paywall in your app
4. Attempt purchase
5. Sign in with test user when prompted
6. Complete purchase flow

#### Subscription Testing

- Test trial start/end
- Test subscription renewal
- Test subscription cancellation
- Test family sharing (if enabled)

#### Restore Purchases Testing

1. Make a purchase with test user
2. Delete and reinstall app
3. Test restore purchases functionality

## Android Testing

### 1. Internal Testing Track

1. Upload APK to Google Play Console
2. Create internal testing track
3. Add test user emails
4. Share testing link with testers

### 2. License Testing

```dart
// Add test user emails to your app configuration
class PaywallConfig {
  static const List<String> testUsers = [
    'test1@example.com',
    'test2@example.com',
  ];
  
  static bool isTestUser(String email) {
    return testUsers.contains(email);
  }
}
```

### 3. Testing Scenarios

- Test purchases with different payment methods
- Test subscription management from Play Store
- Test grace period handling
- Test account hold scenarios

## Automated Testing

### 1. Widget Tests

Create widget tests for paywall components:

```dart
// test/paywall/paywall_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/screens/paywall_screen.dart';

void main() {
  group('PaywallScreen', () {
    testWidgets('displays loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PaywallScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays products when loaded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Mock the provider
            paywallNotifierProvider.overrideWith(() => MockPaywallNotifier()),
          ],
          child: MaterialApp(
            home: const PaywallScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Yearly Plan'), findsOneWidget);
      expect(find.text('3-Day Trial'), findsOneWidget);
    });
  });
}
```

### 2. Integration Tests

Test complete purchase flows:

```dart
// integration_test/paywall_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:enmay_flutter_starter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Paywall Integration Tests', () {
    testWidgets('complete purchase flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to paywall
      await tester.tap(find.text('Premium'));
      await tester.pumpAndSettle();

      // Select product
      await tester.tap(find.text('Yearly Plan'));
      await tester.pumpAndSettle();

      // Verify selection
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Note: Don't actually complete purchase in automated tests
    });
  });
}
```

## Manual Testing Checklist

### UI/UX Testing

- [ ] Paywall loads correctly on all screen sizes
- [ ] Hero animation plays smoothly
- [ ] Product selection works properly
- [ ] Cooldown timer functions correctly
- [ ] Close button appears after cooldown
- [ ] Loading states are handled gracefully
- [ ] Error states display helpful messages

### Functionality Testing

- [ ] Products load from store
- [ ] Purchase flow completes successfully
- [ ] Restore purchases works
- [ ] Subscription status updates correctly
- [ ] Trial eligibility is tracked properly
- [ ] Terms and Privacy links work

### Edge Cases

- [ ] No internet connection
- [ ] App Store/Play Store unavailable
- [ ] Invalid product configurations
- [ ] Payment method failures
- [ ] Account switching scenarios

### Performance Testing

- [ ] Paywall loads quickly (< 3 seconds)
- [ ] Animations are smooth (60fps)
- [ ] Memory usage is reasonable
- [ ] No memory leaks after multiple opens

## Testing Different Configurations

### Feature Variations

Test different feature configurations:

```dart
// Short feature list
features: [
  PaywallFeature(title: 'Ad-free experience', iconName: 'shield'),
  PaywallFeature(title: 'Premium content', iconName: 'star'),
],

// Long feature list
features: [
  PaywallFeature(title: 'Remove all advertisements', iconName: 'shield'),
  PaywallFeature(title: 'Access premium content library', iconName: 'star'),
  PaywallFeature(title: 'Unlimited cloud storage', iconName: 'cloud'),
  PaywallFeature(title: 'Priority customer support', iconName: 'rocket'),
  PaywallFeature(title: 'Advanced analytics dashboard', iconName: 'gear'),
],
```

### Price Testing

Test different price points and currencies:

```dart
// Different price points
products: [
  PurchaseProduct(id: 'low_price', price: '\$1.99', ...),
  PurchaseProduct(id: 'medium_price', price: '\$4.99', ...),
  PurchaseProduct(id: 'high_price', price: '\$9.99', ...),
],
```

## Debugging Common Issues

### Products Not Loading

```dart
// Add debug logging
@override
Future<List<PurchaseProduct>> getProducts(List<String> productIds) async {
  print('Requesting products: $productIds');
  try {
    final products = await _purchaseDataSource.getProducts(productIds);
    print('Received products: ${products.map((p) => p.id).toList()}');
    return products;
  } catch (e) {
    print('Error loading products: $e');
    rethrow;
  }
}
```

### Purchase Flow Issues

```dart
// Add purchase logging
Future<bool> purchaseProduct(String productId) async {
  print('Starting purchase for product: $productId');
  try {
    final result = await _purchaseDataSource.purchaseProduct(productId);
    print('Purchase result: $result');
    return result;
  } catch (e) {
    print('Purchase error: $e');
    rethrow;
  }
}
```

## Performance Monitoring

### Analytics Events

Track key metrics:

```dart
// In your analytics service
void trackPaywallShown() {
  FirebaseAnalytics.instance.logEvent(name: 'paywall_shown');
}

void trackPurchaseAttempted(String productId) {
  FirebaseAnalytics.instance.logEvent(
    name: 'purchase_attempted',
    parameters: {'product_id': productId},
  );
}

void trackPurchaseCompleted(String productId, double price) {
  FirebaseAnalytics.instance.logEvent(
    name: 'purchase_completed',
    parameters: {
      'product_id': productId,
      'price': price,
    },
  );
}
```

## Pre-Launch Testing

### Final Checklist

- [ ] All store products are approved and available
- [ ] Test with real payment methods
- [ ] Verify receipt validation works
- [ ] Test subscription management flows
- [ ] Confirm analytics tracking works
- [ ] Test with different user types (new, returning, churned)
- [ ] Verify compliance with store guidelines

### Soft Launch Testing

1. Release to limited audience
2. Monitor conversion rates
3. Track crash reports
4. Collect user feedback
5. Iterate based on findings

## Troubleshooting Guide

### Common Issues

1. **"Products not available"** - Check product IDs and store approval status
2. **"Purchase failed"** - Verify payment method and account status
3. **"Restore failed"** - Check receipt validation and user account
4. **Animation stuttering** - Optimize widget rebuilds and animations

### Debug Commands

```bash
# iOS debugging
flutter logs --device-id [iOS_DEVICE_ID]

# Android debugging
flutter logs --device-id [ANDROID_DEVICE_ID]

# Build for testing
flutter build ios --debug
flutter build apk --debug
```

This comprehensive testing approach ensures your paywall works correctly across all scenarios before going live.
