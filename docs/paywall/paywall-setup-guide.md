# Paywall Setup Guide

This guide will walk you through setting up in-app purchases for your paywall feature on both iOS App Store and Google Play Store.

## Prerequisites

Before you begin, make sure you have:

- Developer accounts for Apple App Store and Google Play Store
- Your app uploaded to both stores (can be in development/testing phase)
- Firebase project set up (for crashlytics and analytics)

## iOS App Store Connect Setup

### 1. Create App Store Connect Account

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Sign in with your Apple Developer account
3. Create a new app or select your existing app

### 2. Set Up In-App Purchases

1. In App Store Connect, go to your app
2. Navigate to **Features** → **In-App Purchases**
3. Click the **+** button to create a new in-app purchase

### 3. Create Subscription Products

Create the following subscription products (matching the demo configuration):

#### Weekly Trial Subscription

- **Product ID**: `your_app_weekly_trial` (replace with your app's identifier)
- **Type**: Auto-Renewable Subscription
- **Reference Name**: Weekly Trial
- **Subscription Group**: Create a new group (e.g., "Premium Subscriptions")
- **Duration**: 1 Week
- **Price**: $4.99
- **Free Trial**: 3 days
- **Subscription Benefits**: List your premium features
- **Review Information**: Provide test user credentials and instructions

#### Yearly Subscription

- **Product ID**: `your_app_yearly` (replace with your app's identifier)
- **Type**: Auto-Renewable Subscription
- **Reference Name**: Yearly Plan
- **Subscription Group**: Use the same group as above
- **Duration**: 1 Year
- **Price**: $25.99
- **Review Information**: Provide test user credentials and instructions

### 4. Configure Tax and Banking

1. Go to **Agreements, Tax, and Banking**
2. Complete all required information
3. Set up your bank account for payments
4. Accept the necessary agreements

### 5. Update App Configuration

Update your app configuration with the product IDs:

```dart
// In PaywallLocalDataSource.getDefaultConfig()
products: [
  PurchaseProduct(
    id: 'your_app_yearly',  // Replace with your actual product ID
    price: '\$25.99',
    duration: 'year',
    planName: 'Yearly Plan',
    hasTrial: false,
  ),
  PurchaseProduct(
    id: 'your_app_weekly_trial',  // Replace with your actual product ID
    price: '\$4.99',
    duration: 'week',
    planName: '3-Day Trial',
    hasTrial: true,
  ),
],
```

## Google Play Console Setup

### 1. Create Google Play Console Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Sign in with your Google account
3. Create a new app or select your existing app

### 2. Set Up Play Billing

1. In Play Console, go to your app
2. Navigate to **Monetization** → **Subscriptions**
3. Click **Create subscription**

### 3. Create Subscription Productss

Create subscriptions matching your iOS products:

#### Weekly Trial Subscriptions

- **Product ID**: `your_app_weekly_trial` (must match iOS)
- **Name**: Weekly Trial
- **Description**: 3-day free trial, then $4.99/week
- **Billing Period**: Weekly
- **Price**: $4.99
- **Free Trial**: 3 days
- **Grace Period**: 3 days (recommended)

#### Yearly Subscriptions

- **Product ID**: `your_app_yearly` (must match iOS)
- **Name**: Yearly Plan
- **Description**: Annual subscription for $25.99
- **Billing Period**: Yearly
- **Price**: $25.99
- **Grace Period**: 3 days (recommended)

### 4. Configure Licensing & Billing

1. Go to **Setup** → **Licensing**
2. Set up your public key (this will be used for purchase verification)
3. Configure server-side verification if needed

## Firebase Configuration

### 1. Add Firebase to Your Project

If you haven't already:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Add your iOS and Android apps
3. Download configuration files:
   - `GoogleService-Info.plist` for iOS
   - `google-services.json` for Android

### 2. Enable Firebase Crashlytics

For better error tracking:

1. In Firebase Console, enable Crashlytics
2. Follow the setup instructions for both platforms

## Testing Your Implementation

### iOS Testing

1. Create a test user in App Store Connect
2. Add the test user to your app's TestFlight
3. Build and upload to TestFlight
4. Test purchases with the test user account

### Android Testing

1. Create a test track in Google Play Console
2. Upload your app to the test track
3. Add test user email addresses
4. Test purchases with test user accounts

## Environment Configuration

Create different configurations for development, staging, and production:

### Development

Use test product IDs and test accounts

### Staging/Production

Use actual product IDs from your store configurations

### Environment Variables

Consider using a configuration file or environment variables:

```dart
class PaywallConfig {
  static const String weeklyProductId = 
    String.fromEnvironment('WEEKLY_PRODUCT_ID', defaultValue: 'demo_w');
  static const String yearlyProductId = 
    String.fromEnvironment('YEARLY_PRODUCT_ID', defaultValue: 'demo_y');
}
```

## Revenue and Analytics

### 1. Revenue Tracking

- Set up Firebase Analytics to track purchase events
- Implement custom events for paywall views, dismissals, and conversions
- Monitor conversion rates and optimize accordingly

### 2. A/B Testing

Consider testing different:

- Feature lists
- Pricing strategies
- Trial periods
- UI variations

## Compliance and Guidelines

### Apple App Store

- Follow [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Ensure your paywall doesn't use misleading terms like "FREE" excessively
- Provide clear terms of service and privacy policy

### Google Play Store

- Follow [Google Play Developer Policy](https://support.google.com/googleplay/android-developer/answer/9857348)
- Implement proper subscription management
- Provide clear billing terms

## Common Issues and Solutions

### Issue: Products not loading

- **Solution**: Verify product IDs match exactly between app and store
- Check that products are approved and available in your test environment

### Issue: Purchases not completing

- **Solution**: Ensure proper purchase flow implementation
- Check network connectivity and error handling

### Issue: Restore purchases not working

- **Solution**: Implement proper receipt validation
- Handle edge cases for family sharing and account transfers

## Next Steps

1. Implement server-side receipt validation for production
2. Set up automated testing for purchase flows
3. Monitor crash reports and user feedback
4. Optimize paywall conversion based on analytics data

## Support Resources

- [Apple In-App Purchase Programming Guide](https://developer.apple.com/in-app-purchase/)
- [Google Play Billing Documentation](https://developer.android.com/google/play/billing)
- [Flutter in_app_purchase Plugin Documentation](https://pub.dev/packages/in_app_purchase)
