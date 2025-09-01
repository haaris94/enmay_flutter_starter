# Paywall Configuration Guide

This guide explains how to customize your paywall to match your app's branding and subscription strategy.

## Basic Configuration

The paywall is configured through the `PaywallConfig` model. You can customize it in the `PaywallLocalDataSource.getDefaultConfig()` method.

```dart
PaywallConfig getDefaultConfig() {
  return const PaywallConfig(
    title: 'Unlock Premium Access',
    features: [
      // Your features here
    ],
    products: [
      // Your subscription products here
    ],
    heroImagePath: 'assets/images/paywall_hero.png',
    cooldownDuration: 5.0,
    hasCooldown: true,
    termsUrl: 'https://your-app.com/terms',
    privacyUrl: 'https://your-app.com/privacy',
  );
}
```

## Customizing the Title

Change the main paywall title to match your app:

```dart
// Examples for different app types

// Productivity App
title: 'Unlock Pro Features',

// Photo Editor
title: 'Go Premium',

// Fitness App
title: 'Upgrade to Premium',

// Learning App
title: 'Get Unlimited Access',

// Entertainment App
title: 'Remove Ads & More',
```

## Configuring Features

### Feature Icons

The paywall supports various icons. Here are the available options:

```dart
features: [
  // Common icons
  PaywallFeature(title: 'Remove ads', iconName: 'shield'),
  PaywallFeature(title: 'Unlimited access', iconName: 'infinity'),
  PaywallFeature(title: 'Premium content', iconName: 'star'),
  PaywallFeature(title: 'Priority support', iconName: 'rocket'),
  PaywallFeature(title: 'Advanced features', iconName: 'gear'),
  PaywallFeature(title: 'Cloud backup', iconName: 'cloud'),
  PaywallFeature(title: 'HD quality', iconName: 'diamond'),
  PaywallFeature(title: 'Exclusive content', iconName: 'crown'),
  PaywallFeature(title: 'Magic tools', iconName: 'magic.wand'),
  PaywallFeature(title: 'Creative brushes', iconName: 'paintbrush'),
  PaywallFeature(title: 'Camera features', iconName: 'camera'),
  PaywallFeature(title: 'Audio features', iconName: 'music.note'),
  PaywallFeature(title: 'Global access', iconName: 'globe'),
  PaywallFeature(title: 'Verified account', iconName: 'checkmark.circle'),
  PaywallFeature(title: 'Add features', iconName: 'plus.circle'),
  PaywallFeature(title: 'Security', iconName: 'lock'),
  PaywallFeature(title: 'Love it', iconName: 'heart'),
  PaywallFeature(title: 'Fast performance', iconName: 'flash'),
],
```

### Custom Colors

You can customize feature colors:

```dart
PaywallFeature(
  title: 'Premium Feature',
  iconName: 'star',
  colorValue: 0xFF6366F1, // Custom color (hex)
),
```

### Feature Templates by App Category

#### Photo/Video Editor

```dart
features: [
  PaywallFeature(title: 'Remove watermarks', iconName: 'shield'),
  PaywallFeature(title: 'HD export quality', iconName: 'diamond'),
  PaywallFeature(title: 'Premium filters', iconName: 'magic.wand'),
  PaywallFeature(title: 'Advanced editing tools', iconName: 'paintbrush'),
  PaywallFeature(title: 'Cloud storage', iconName: 'cloud'),
],
```

#### Productivity App

```dart
features: [
  PaywallFeature(title: 'Unlimited projects', iconName: 'infinity'),
  PaywallFeature(title: 'Advanced analytics', iconName: 'gear'),
  PaywallFeature(title: 'Team collaboration', iconName: 'globe'),
  PaywallFeature(title: 'Priority support', iconName: 'rocket'),
  PaywallFeature(title: 'Export options', iconName: 'checkmark.circle'),
],
```

#### Fitness/Health App

```dart
features: [
  PaywallFeature(title: 'Personalized workouts', iconName: 'star'),
  PaywallFeature(title: 'Nutrition tracking', iconName: 'plus.circle'),
  PaywallFeature(title: 'Progress analytics', iconName: 'gear'),
  PaywallFeature(title: 'Ad-free experience', iconName: 'shield'),
  PaywallFeature(title: 'Premium content', iconName: 'crown'),
],
```

#### Learning/Education App

```dart
features: [
  PaywallFeature(title: 'Unlimited courses', iconName: 'infinity'),
  PaywallFeature(title: 'Offline downloads', iconName: 'cloud'),
  PaywallFeature(title: 'Certificates', iconName: 'checkmark.circle'),
  PaywallFeature(title: 'Expert support', iconName: 'rocket'),
  PaywallFeature(title: 'Ad-free learning', iconName: 'shield'),
],
```

## Subscription Products

### Product Configuration

```dart
products: [
  // Weekly trial product
  PurchaseProduct(
    id: 'your_app_weekly_trial',
    price: '\$4.99',
    duration: 'week',
    planName: '7-Day Free Trial',
    hasTrial: true,
    description: '7 days free, then \$4.99/week',
  ),
  
  // Monthly product
  PurchaseProduct(
    id: 'your_app_monthly',
    price: '\$9.99',
    duration: 'month',
    planName: 'Monthly Plan',
    hasTrial: false,
  ),
  
  // Yearly product (best value)
  PurchaseProduct(
    id: 'your_app_yearly',
    price: '\$79.99',
    duration: 'year',
    planName: 'Yearly Plan',
    hasTrial: false,
  ),
],
```

### Pricing Strategies

#### Standard Freemium

```dart
products: [
  PurchaseProduct(
    id: 'monthly',
    price: '\$9.99',
    planName: 'Monthly Premium',
  ),
  PurchaseProduct(
    id: 'yearly',
    price: '\$99.99',
    planName: 'Yearly Premium',
  ),
],
```

#### Trial-First Strategy

```dart
products: [
  PurchaseProduct(
    id: 'trial_then_monthly',
    price: '\$9.99',
    planName: '7-Day Free Trial',
    hasTrial: true,
  ),
  PurchaseProduct(
    id: 'yearly_discount',
    price: '\$79.99',
    planName: 'Yearly (Save 33%)',
  ),
],
```

#### Multiple Tiers

```dart
products: [
  PurchaseProduct(
    id: 'basic_monthly',
    price: '\$4.99',
    planName: 'Basic Monthly',
  ),
  PurchaseProduct(
    id: 'pro_monthly',
    price: '\$9.99',
    planName: 'Pro Monthly',
  ),
  PurchaseProduct(
    id: 'pro_yearly',
    price: '\$99.99',
    planName: 'Pro Yearly',
  ),
],
```

## Visual Customization

### Hero Image

Add a custom hero image to your assets:

```dart
// In pubspec.yaml, make sure you have:
flutter:
  assets:
    - assets/images/
    - assets/images/paywall/

// Then configure:
heroImagePath: 'assets/images/paywall/hero.png',
```

#### Image Guidelines

- **Size**: 300x300px minimum
- **Format**: PNG with transparency preferred
- **Style**: Should match your app's visual style
- **Content**: Avoid text (for international compatibility)

### Colors and Theming

The paywall automatically uses your app's theme colors, but you can customize:

```dart
// In your app theme, the paywall will use:
// - Primary color for buttons and selection
// - Surface colors for background
// - OnSurface colors for text
// - Error colors for error states

// To customize paywall-specific colors, modify the widgets directly
```

## Cooldown Timer

### Enable/Disable Cooldown

```dart
// Enable cooldown (prevents immediate dismissal)
hasCooldown: true,
cooldownDuration: 5.0, // seconds

// Disable cooldown (show close button immediately)
hasCooldown: false,
```

### Cooldown Strategies

```dart
// Short cooldown for better UX
cooldownDuration: 3.0,

// Standard cooldown
cooldownDuration: 5.0,

// Longer cooldown for higher conversion
cooldownDuration: 8.0,

// No cooldown (immediate close)
hasCooldown: false,
```

## Legal Links

### Configure Terms and Privacy URLs

```dart
termsUrl: 'https://your-app.com/terms-of-service',
privacyUrl: 'https://your-app.com/privacy-policy',

// For apps without websites, use store links:
termsUrl: 'https://apps.apple.com/app/your-app/id123456789',
privacyUrl: 'https://your-website.com/privacy',
```

## Dynamic Configuration

### Load from Remote Config

For apps that need dynamic paywall updates:

```dart
class PaywallRemoteConfig {
  static Future<PaywallConfig> loadFromFirebase() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    
    final configJson = remoteConfig.getString('paywall_config');
    if (configJson.isNotEmpty) {
      final configMap = json.decode(configJson);
      return PaywallConfig.fromJson(configMap);
    }
    
    return getDefaultConfig();
  }
}
```

### A/B Testing Configuration

```dart
class PaywallVariants {
  static PaywallConfig getVariantA() {
    return PaywallConfig(
      title: 'Unlock Premium Features',
      features: [
        // Variant A features
      ],
    );
  }
  
  static PaywallConfig getVariantB() {
    return PaywallConfig(
      title: 'Go Pro Now!',
      features: [
        // Variant B features
      ],
    );
  }
}
```

## Localization

### Multi-language Support

```dart
// Use your app's localization system
title: context.l10n.paywallTitle,
features: [
  PaywallFeature(
    title: context.l10n.featureRemoveAds,
    iconName: 'shield',
  ),
  PaywallFeature(
    title: context.l10n.featureUnlimitedAccess,
    iconName: 'infinity',
  ),
],
```

### Currency Formatting

The `in_app_purchase` plugin automatically handles currency formatting based on the user's locale and the store's configuration.

## Best Practices

### Feature List Guidelines

- **Keep it concise**: 3-5 features work best
- **Use benefits, not features**: "Remove ads" vs "Ad-free experience"
- **Order by importance**: Most compelling feature first
- **Use action words**: "Unlock", "Get", "Access"

### Pricing Psychology

- **Anchor with highest price**: Show yearly savings
- **Use trial periods**: Lower commitment barrier
- **Highlight value**: "Save 60%" badges
- **Keep options simple**: Don't overwhelm with choices

### Visual Design

- **Consistent branding**: Match your app's style
- **Clear hierarchy**: Important elements stand out
- **Smooth animations**: Professional feel
- **Loading states**: Handle network delays gracefully

## Testing Different Configurations

### Configuration Variants

Test different configurations to optimize conversion:

```dart
// Variant A: Feature-focused
PaywallConfig variantA = PaywallConfig(
  title: 'Unlock All Features',
  features: [
    PaywallFeature(title: 'Advanced photo filters', iconName: 'magic.wand'),
    PaywallFeature(title: 'HD video export', iconName: 'diamond'),
    PaywallFeature(title: 'Cloud storage sync', iconName: 'cloud'),
  ],
);

// Variant B: Benefit-focused
PaywallConfig variantB = PaywallConfig(
  title: 'Create Like a Pro',
  features: [
    PaywallFeature(title: 'Professional results', iconName: 'star'),
    PaywallFeature(title: 'Save time editing', iconName: 'flash'),
    PaywallFeature(title: 'Never lose your work', iconName: 'shield'),
  ],
);
```

## Migration Guide

### Updating Existing Configuration

When updating your paywall configuration:

1. **Test thoroughly**: Changes affect revenue directly
2. **Use gradual rollout**: Deploy to small percentage first
3. **Monitor metrics**: Watch conversion rates and user feedback
4. **Have rollback plan**: Quick revert if issues arise

### Version Compatibility

```dart
class PaywallConfigVersion {
  static const int currentVersion = 2;
  
  static PaywallConfig migrate(Map<String, dynamic> oldConfig) {
    final version = oldConfig['version'] ?? 1;
    
    switch (version) {
      case 1:
        return migrateFromV1(oldConfig);
      default:
        return PaywallConfig.fromJson(oldConfig);
    }
  }
}
```

This configuration guide helps you create a paywall that converts well and provides great user experience for your specific app category and audience.
