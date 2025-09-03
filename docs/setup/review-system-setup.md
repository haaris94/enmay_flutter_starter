# App Review System Setup Guide

This guide helps you configure the app review system for your new Flutter app when cloning this starter template.

## Quick Setup (5 minutes)

### 1. Choose Your Review Strategy

The system comes with pre-configured options. Choose one that fits your app:

```dart
// In your main app initialization or service setup

// Option 1: Default (Recommended for most apps)
final reviewOptions = ReviewOptions.defaultOptions;

// Option 2: Conservative (For professional/business apps)
final reviewOptions = ReviewOptions.conservative;

// Option 3: Aggressive (For casual/gaming apps with high engagement)
final reviewOptions = ReviewOptions.aggressive;

// Option 4: Debug (For testing during development)
final reviewOptions = ReviewOptions.debug;
```

### 2. Initialize the Review Service

Add this to your app startup (typically in `main.dart` or app initialization):

```dart
// Initialize with your chosen options
final reviewService = await ReviewService.create(options: reviewOptions);

// Make it available through Riverpod (example)
// This will be handled automatically by the generated providers
```

### 3. Add Review Triggers

Add these calls in appropriate places in your app:

**App Launch (in main.dart or app startup):**

```dart
await reviewService.incrementLaunchCount();
```

**After Key User Actions:**

```dart
// Examples of key actions - choose 2-3 most important ones for your app:

// After user completes onboarding
await reviewService.incrementKeyAction();

// After user creates/saves content
await reviewService.incrementKeyAction();

// After user successfully uses core feature
await reviewService.incrementKeyAction();

// After user completes a tutorial
await reviewService.incrementKeyAction();
```

## Configuration Options

### Core Timing Settings

| Setting | Default | Conservative | Aggressive | Description |
|---------|---------|--------------|------------|-------------|
| `phase1MinDifferentDays` | 3 | 5 | 2 | Days user must use app in Phase 1 |
| `phase1MinUsageMinutes` | 10 | 15 | 5 | Total minutes of usage needed |
| `phase1MinKeyActions` | 2 | 3 | 1 | Key actions needed in Phase 1 |
| `phase2MinDaysActive` | 7 | 10 | 5 | Days active before Phase 2 triggers |
| `firstRetryDelayDays` | 14 | 21 | 10 | Days to wait after first "Later" |
| `secondRetryDelayDays` | 30 | 45 | 21 | Days to wait after second "Later" |

### Custom Configuration

For full control, create your own configuration:

```dart
const customOptions = ReviewOptions(
  // Phase 1: First week boost
  phase1MinDifferentDays: 4,        // User must use app on 4 different days
  phase1MinUsageMinutes: 12,        // At least 12 minutes total usage
  phase1MinKeyActions: 2,           // Complete 2 key actions
  phase1MaxDays: 7,                 // Only during first 7 days
  
  // Phase 2: Long-term strategy  
  phase2MinDaysActive: 8,           // After 8 days since first launch
  phase2MinLaunchCount: 6,          // Must have opened app 6 times
  phase2MinKeyActions: 4,           // Must have done 4 key actions
  
  // Retry timing
  firstRetryDelayDays: 18,          // Wait 18 days after "Later"
  secondRetryDelayDays: 35,         // Wait 35 days after second "Later"
  
  // General settings
  maxAttempts: 3,                   // Maximum 3 attempts total
  preventAskingAfterRateNowDays: 180, // Don't ask for 6 months after rating
);
```

## App-Specific Configuration

### 1. Define Your Key Actions

Identify 2-3 most important successful actions in your app:

**E-commerce App:**

- User completes first purchase
- User adds item to favorites
- User completes profile setup

**Productivity App:**

- User creates first project
- User exports/shares content
- User uses premium feature

**Social App:**

- User creates first post
- User connects with friends
- User completes profile

**Game:**

- User completes first level
- User unlocks achievement
- User makes in-game progress

### 2. Customize Messages (Optional)

You can customize the review dialog messages in the `ReviewDialog` widget:

```dart
// Default messages are user-friendly, but you can customize:
title: "Enjoying [Your App Name]?",
message: "Your feedback helps us improve. Would you mind taking a moment to rate us?",
rateButtonText: "Yes, Rate Now",
laterButtonText: "Later", 
dontAskButtonText: "Don't Ask Again",
```

## Testing Your Configuration

### 1. Enable Debug Mode

```dart
const debugOptions = ReviewOptions.debug;
// or
const testOptions = ReviewOptions(
  debugMode: true,
  debugIgnoreTimingConstraints: true,
  // ... other settings
);
```

### 2. Test Scenarios

With debug mode enabled:

1. **Test Immediate Trigger**: Launch app and perform 1 key action
2. **Test "Later" Flow**: Choose "Later" and verify it waits appropriate time
3. **Test "Don't Ask Again"**: Verify it never asks again after selection
4. **Test Max Attempts**: Verify it stops asking after 3 attempts

### 3. Production Readiness

Before release:

```dart
// Switch back to production options
const productionOptions = ReviewOptions.defaultOptions; // or your custom config
// Ensure debugMode: false (default)
```

## Best Practices

### ✅ DO

- Choose 2-3 meaningful key actions that indicate user satisfaction
- Trigger review requests after moments of success/completion
- Test thoroughly with debug mode before release
- Use conservative timing for professional apps
- Monitor your app store ratings and adjust if needed

### ❌ DON'T  

- Trigger on app launch or during user tasks
- Ask too frequently (respect the timing constraints)
- Ignore user's "Don't Ask Again" choice
- Use too many different key actions (causes dilution)
- Deploy without testing the flow

## Monitoring & Analytics

The system automatically tracks:

- Review request attempts
- User responses (Rate Now, Later, Don't Ask Again)
- Timing between requests
- User engagement metrics

Access this data through the `ReviewService` for analytics integration.

## Troubleshooting

### Review Dialog Not Showing

1. Check if user selected "Don't Ask Again"
2. Verify timing constraints are met
3. Confirm key actions are being tracked
4. Enable debug mode to test immediately

### Too Many/Few Review Requests

1. Adjust timing settings in `ReviewOptions`
2. Review your key action definitions
3. Consider switching between default/conservative/aggressive presets

### User Complaints About Frequency

1. Switch to `ReviewOptions.conservative`
2. Increase retry delay days
3. Review your key action triggers

---

## Quick Reference

**Minimum Setup (2 lines of code):**

```dart
// 1. Initialize (in app startup)
final reviewService = await ReviewService.create();

// 2. Add triggers (after key actions)
await reviewService.incrementKeyAction();
```

**That's it!** The system handles all timing, UI, and user preferences automatically.
