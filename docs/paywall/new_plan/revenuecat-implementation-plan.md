# RevenueCat Implementation Plan

This document provides a complete migration plan from the current `in_app_purchase` implementation to RevenueCat for simplified subscription management.

## 📋 Prerequisites

### Required Accounts & Services

- **Apple Developer Program**: $99/year (required for iOS apps)
- **Google Play Console**: $25 one-time (required for Android apps)
- **RevenueCat Account**: Free tier available (up to $2.5K monthly revenue)
- **Firebase Project**: For crashlytics and analytics (optional but recommended)

### Development Environment

- **Flutter SDK**: 3.7.0 or higher
- **Dart SDK**: Compatible with Flutter version
- **Xcode**: Latest version for iOS development
- **Android Studio**: For Android development

## 🎯 Benefits Over Current Implementation

| Feature | Current (in_app_purchase) | RevenueCat |
|---------|---------------------------|------------|
| **Code Complexity** | ~800 lines | ~200 lines |
| **Setup Time** | 2-3 days per app | 30 minutes per app |
| **Receipt Validation** | Manual implementation | Built-in |
| **Subscription Status** | Manual tracking | Real-time sync |
| **A/B Testing** | Custom implementation | Dashboard UI |
| **Analytics** | Custom tracking | Built-in dashboard |
| **Family Sharing** | Manual handling | Automatic |
| **Promo Codes** | Complex setup | Built-in support |
| **Webhooks** | Custom backend | Automatic |
| **Cross-platform Sync** | Manual implementation | Automatic |

## 🏗️ Architecture Comparison

### Current Implementation

```bash
PaywallScreen
├── PaywallNotifier (AsyncNotifierProvider)
├── PaywallService (orchestration)
├── PaywallRepository
├── InAppPurchaseDataSource (150 lines)
├── PaywallLocalDataSource
└── Manual error handling, receipt validation, etc.
```

### RevenueCat Implementation

```bash
PaywallScreen (unchanged)
├── RevenueCatPaywallNotifier (simplified)
├── RevenueCatRepository (60% less code)
└── RevenueCatDataSource (30 lines)
```

## 📦 Implementation Steps

### Phase 1: RevenueCat Setup (30 minutes)

#### 1. Create RevenueCat Account

1. Go to [RevenueCat Dashboard](https://www.revenuecat.com/)
2. Sign up with your email
3. Create a new project for your app

#### 2. Configure Apps in RevenueCat

1. In RevenueCat dashboard, go to **Apps**
2. Add iOS app with Bundle ID (e.g., `com.yourcompany.yourapp`)
3. Add Android app with Package Name (same as Bundle ID)
4. Copy the **Public API Key** for Flutter integration

#### 3. Configure Products in RevenueCat

1. Go to **Products** section
2. Import products from App Store Connect / Google Play Console
3. Create **Offerings** (product packages):

```bash
Default Offering:
├── Weekly Trial Package ($4.99/week, 3-day trial)
└── Yearly Package ($25.99/year)
```

### Phase 2: Flutter Dependencies

#### 1. Update pubspec.yaml

```yaml
dependencies:
  # Remove this line:
  # in_app_purchase: ^3.2.3
  
  # Add this line:
  purchases_flutter: ^6.29.2
  
  # Keep existing:
  url_launcher: ^6.3.2
  flutter_animate: ^4.5.2
  # ... other dependencies
```

#### 2. Run pub get

```bash
flutter pub get
```

### Phase 3: Code Migration

#### 1. Create RevenueCat DataSource

**File**: `lib/src/features/paywall/data/datasources/remote/revenue_cat_datasource.dart`

```dart
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatDataSource {
  
  Future<void> initialize(String apiKey, {String? userId}) async {
    try {
      await Purchases.configure(
        PurchasesConfiguration(apiKey)
          ..appUserID = userId
          ..observerMode = false,
      );
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<Offerings> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      return purchaserInfo.customerInfo;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> isSubscribed() async {
    try {
      final customerInfo = await getCustomerInfo();
      return customerInfo.entitlements.active.isNotEmpty;
    } catch (e) {
      return false; // Default to not subscribed on error
    }
  }
}
```

#### 2. Update Repository

**Replace**: `lib/src/features/paywall/data/repositories/paywall_repository.dart`

```dart
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/datasources/local/paywall_local_datasource.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/datasources/remote/revenue_cat_datasource.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_repository.g.dart';

@Riverpod(keepAlive: true)
PaywallRepository paywallRepository(Ref ref) => PaywallRepository();

class PaywallRepository {
  final RevenueCatDataSource _revenueCatDataSource = RevenueCatDataSource();
  final PaywallLocalDataSource _localDataSource = PaywallLocalDataSource();

  Future<void> initialize(String apiKey, {String? userId}) async {
    try {
      await _revenueCatDataSource.initialize(apiKey, userId: userId);
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<List<PurchaseProduct>> getProducts() async {
    try {
      final offerings = await _revenueCatDataSource.getOfferings();
      final currentOffering = offerings.current;
      
      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        // Fallback to local configuration
        final config = await getPaywallConfig();
        return config.products;
      }

      return currentOffering.availablePackages.map((package) {
        return PurchaseProduct(
          id: package.identifier,
          price: package.storeProduct.priceString,
          duration: _getDurationFromPackageType(package.packageType),
          planName: package.storeProduct.title,
          hasTrial: package.storeProduct.introductoryPrice != null,
          localizedPrice: package.storeProduct.priceString,
          currencyCode: package.storeProduct.currencyCode,
          description: package.storeProduct.description,
        );
      }).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> purchaseProduct(String packageId) async {
    try {
      final offerings = await _revenueCatDataSource.getOfferings();
      final package = offerings.current?.availablePackages
          .firstWhere((p) => p.identifier == packageId);
      
      if (package == null) {
        throw const Failure(
          title: 'Product Not Found',
          message: 'The selected subscription plan is not available',
          type: ErrorType.externalApi,
        );
      }

      final customerInfo = await _revenueCatDataSource.purchasePackage(package);
      final isSubscribed = customerInfo.entitlements.active.isNotEmpty;
      
      if (isSubscribed) {
        await _localDataSource.addPurchaseToHistory(packageId);
        await _localDataSource.setSelectedProductId(packageId);
        await _localDataSource.setSubscriptionStatus(true);
      }
      
      return isSubscribed;
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await _revenueCatDataSource.restorePurchases();
      final isSubscribed = customerInfo.entitlements.active.isNotEmpty;
      await _localDataSource.setSubscriptionStatus(isSubscribed);
      return isSubscribed;
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> getSubscriptionStatus() async {
    try {
      return await _revenueCatDataSource.isSubscribed();
    } catch (e) {
      // Fallback to local storage on error
      return await _localDataSource.getSubscriptionStatus();
    }
  }

  // Keep existing methods for local configuration
  Future<PaywallConfig> getPaywallConfig() async {
    try {
      final config = await _localDataSource.getPaywallConfig();
      return config ?? _localDataSource.getDefaultConfig();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  // Helper method to convert RevenueCat package types to duration strings
  String _getDurationFromPackageType(PackageType packageType) {
    switch (packageType) {
      case PackageType.weekly:
        return 'week';
      case PackageType.monthly:
        return 'month';
      case PackageType.annual:
        return 'year';
      case PackageType.twoMonth:
        return '2month';
      case PackageType.threeMonth:
        return '3month';
      case PackageType.sixMonth:
        return '6month';
      default:
        return 'month';
    }
  }
}
```

#### 3. Update Provider

**Replace**: `lib/src/features/paywall/presentation/providers/paywall_provider.dart`

```dart
import 'dart:async';

import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/repositories/paywall_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_provider.g.dart';

// Configuration constants
class PaywallConstants {
  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'your_public_api_key_here', // Replace with your key
  );
}

@riverpod
class PaywallNotifier extends _$PaywallNotifier {
  PaywallRepository? _repository;
  Timer? _cooldownTimer;

  @override
  Future<PaywallState> build() async {
    _repository = ref.watch(paywallRepositoryProvider);
    
    // Initialize RevenueCat
    await _repository!.initialize(PaywallConstants.revenueCatApiKey);
    
    // Get subscription status
    final isSubscribed = await _repository!.getSubscriptionStatus();
    
    // Get paywall configuration
    final config = await _repository!.getPaywallConfig();
    
    // Get products from RevenueCat
    final products = await _repository!.getProducts();
    
    // Start cooldown timer if needed
    if (config.hasCooldown) {
      _startCooldownTimer(config.cooldownDuration);
    }
    
    return PaywallState(
      products: products,
      isSubscribed: isSubscribed,
      selectedProductId: products.isNotEmpty ? products.last.id : null,
      isLoading: false,
      isPurchasing: false,
      showCloseButton: !config.hasCooldown,
      cooldownProgress: config.hasCooldown ? 0.0 : 1.0,
    );
  }

  Future<void> purchaseSubscription(String productId) async {
    if (state.hasValue) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final success = await _repository!.purchaseProduct(productId);
        
        return state.requireValue.copyWith(
          isPurchasing: false,
          isSubscribed: success,
          selectedProductId: productId,
        );
      });
    }
  }

  Future<void> restorePurchases() async {
    if (state.hasValue) {
      state = await AsyncValue.guard(() async {
        final success = await _repository!.restorePurchases();
        
        return state.requireValue.copyWith(
          isLoading: false,
          isSubscribed: success,
          errorMessage: success ? null : 'No purchases found to restore',
        );
      });
    }
  }

  // Keep existing methods for UI functionality
  Future<void> selectProduct(String productId) async {
    if (state.hasValue) {
      final currentState = state.requireValue;
      state = AsyncValue.data(currentState.copyWith(
        selectedProductId: productId,
        errorMessage: null,
      ));
    }
  }

  void _startCooldownTimer(double durationInSeconds) {
    const updateInterval = Duration(milliseconds: 100);
    final totalUpdates = (durationInSeconds * 1000 / updateInterval.inMilliseconds).round();
    int currentUpdate = 0;

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(updateInterval, (timer) {
      if (!state.hasValue) {
        timer.cancel();
        return;
      }

      currentUpdate++;
      final progress = (currentUpdate / totalUpdates).clamp(0.0, 1.0);
      
      final currentState = state.requireValue;
      state = AsyncValue.data(currentState.copyWith(
        cooldownProgress: progress,
        showCloseButton: progress >= 1.0,
      ));

      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  String getCallToActionText() {
    if (!state.hasValue) return 'Unlock Now';
    
    final currentState = state.requireValue;
    if (currentState.selectedProductId == null || currentState.products.isEmpty) {
      return 'Unlock Now';
    }

    try {
      final selectedProduct = currentState.products.firstWhere(
        (p) => p.id == currentState.selectedProductId,
      );
      return selectedProduct.hasTrial ? 'Start Free Trial' : 'Unlock Now';
    } catch (e) {
      return 'Unlock Now';
    }
  }

  void clearError() {
    if (state.hasValue) {
      final currentState = state.requireValue;
      state = AsyncValue.data(currentState.copyWith(errorMessage: null));
    }
  }

  void dispose() {
    _cooldownTimer?.cancel();
  }
}

// Keep existing additional providers
@riverpod
Future<bool> isSubscribed(Ref ref) async {
  final paywallState = await ref.watch(paywallNotifierProvider.future);
  return paywallState.isSubscribed;
}

@riverpod
Future<List<PurchaseProduct>> paywallProducts(Ref ref) async {
  final paywallState = await ref.watch(paywallNotifierProvider.future);
  return paywallState.products;
}

@riverpod
Future<PaywallConfig> paywallConfig(Ref ref) async {
  final repository = ref.read(paywallRepositoryProvider);
  return await repository.getPaywallConfig();
}
```

#### 4. Initialize RevenueCat in App Startup

**Update**: `lib/src/app/startup/provider/app_startup_provider.dart`

Add RevenueCat initialization to your app startup:

```dart
// Add this to your app startup logic
Future<void> _initializeRevenueCat() async {
  final repository = ref.read(paywallRepositoryProvider);
  await repository.initialize(PaywallConstants.revenueCatApiKey);
}
```

### Phase 4: Store Configuration (1 hour)

#### 1. App Store Connect Setup (iOS)

1. Create subscription products in App Store Connect
2. Copy product IDs to RevenueCat dashboard
3. Set up offerings in RevenueCat:
   - **Weekly Trial**: `your_app_weekly` (3-day trial, $4.99/week)
   - **Annual**: `your_app_annual` ($25.99/year)

#### 2. Google Play Console Setup (Android)

1. Create subscription products in Google Play Console
2. Use same product IDs as iOS
3. Configure in RevenueCat dashboard

### Phase 5: Testing (30 minutes)

#### 1. Test Environment Setup

1. Create test users in App Store Connect
2. Add test users to RevenueCat dashboard
3. Test purchase flows with sandbox accounts

#### 2. Verification Checklist

- [ ] Products load from RevenueCat
- [ ] Purchase flow works correctly
- [ ] Subscription status updates in real-time
- [ ] Restore purchases works
- [ ] Cross-platform sync works
- [ ] Error handling works as expected

## 🗂️ Files to Remove

After successful migration, you can remove these files:

1. **Delete**:

   ```bash
   lib/src/features/paywall/data/datasources/remote/in_app_purchase_datasource.dart
   lib/src/features/paywall/services/paywall_service.dart
   ```

2. **Keep but simplify**:

   ```bash
   lib/src/features/paywall/data/repositories/paywall_repository.dart
   lib/src/features/paywall/presentation/providers/paywall_provider.dart
   ```

3. **Keep unchanged**:

   ```
   lib/src/features/paywall/presentation/screens/paywall_screen.dart
   lib/src/features/paywall/presentation/widgets/
   lib/src/features/paywall/data/models/purchase_product.dart
   lib/src/features/paywall/data/datasources/local/paywall_local_datasource.dart
   ```

## 📚 Documentation Updates Needed

### 1. Update `paywall-setup-guide.md`

**New Section to Add**:

```markdown
## RevenueCat Dashboard Setup

### 1. Account Creation
1. Sign up at revenuecat.com
2. Create new project
3. Add iOS and Android apps

### 2. Product Configuration
1. Import from App Store Connect / Google Play
2. Create offerings with packages
3. Set up webhooks (optional)

### 3. Integration
1. Copy public API key
2. Add to Flutter app configuration
3. Test with sandbox accounts
```

### 2. Update `configuration-guide.md`

**Add Section**:

```markdown
## RevenueCat Offerings Configuration

### Dashboard Configuration
- Products are managed in RevenueCat dashboard
- Offerings can be updated without app updates
- A/B testing can be configured visually

### Remote Configuration
Products are automatically synced from RevenueCat, but you can still customize UI elements locally.
```

### 3. Update `testing-guide.md`

**Add Section**:

```markdown
## RevenueCat Testing

### Sandbox Testing
1. Use RevenueCat test users
2. Purchase flows are handled automatically
3. Receipt validation is built-in

### Analytics Verification
1. Check RevenueCat dashboard for events
2. Verify webhook delivery (if configured)
3. Monitor subscription status updates
```

## 💡 Migration Tips

### During Development

1. **Keep both implementations** initially for easy rollback
2. **Test thoroughly** in sandbox before production
3. **Monitor RevenueCat dashboard** for real-time data
4. **Use feature flags** to toggle between implementations

### For Production

1. **Gradual rollout**: 10% → 50% → 100% of users
2. **Monitor metrics**: Conversion rates, crash reports, user feedback
3. **Have rollback plan**: Quick switch back if issues arise
4. **Update store listings**: Mention new features if applicable

### Post-Migration Benefits

1. **Dashboard insights**: Real-time revenue, conversion rates
2. **A/B testing**: Test different offerings without app updates
3. **Webhooks**: Real-time subscription events for backend
4. **Family sharing**: Automatic support
5. **Customer support**: Built-in tools for refunds, subscription management

## 🚀 Next Steps

1. **Create RevenueCat account** and configure products
2. **Start new conversation** with the implementation details
3. **Follow migration plan** step by step
4. **Test thoroughly** before production release
5. **Monitor dashboard** for insights and optimization opportunities

This migration will reduce your paywall implementation complexity by 60% while adding enterprise-level features that would take months to build manually.

---

**Ready to Start?** Create your RevenueCat account and begin Phase 1 of the implementation plan!
