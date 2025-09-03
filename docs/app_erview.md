# Guiding Principles

1. **Never Interrupt:** A review prompt should never interrupt a user's task. It should appear after a moment of success or completion.
2. **Ask, Don't Demand:** The language should be a gentle request, not a demand.
3. **Provide an Escape Hatch:** The "Don't Ask Again" option is your most important tool for respecting users.
4. **Be Intelligent:** Don't just count app opens. Use a combination of metrics to identify happy, engaged users.
5. **Use the Native Prompt:** Always use the official `in_app_review` package. It uses the native iOS/Android prompts, which are less intrusive, familiar to users, and have their own built-in logic to prevent overuse. You can't control if they appear, but you can control *when you ask for them to appear*.

## The Two-Step Prompting System (The Core of the Strategy)

Instead of directly triggering the OS-level review prompt (which you can't control and which has no "Don't Ask Again" option), we'll first show a custom, non-intrusive dialog. This gives us full control.

**Step 1: Your Custom "Sentiment" Dialog**
This is a simple, custom-built dialog within your app. It could look like this:

> **Enjoying [Your App Name]?**
>
> Your feedback helps us improve. Would you mind taking a moment to rate us?
>
> [**Yes, Rate Now**]   [**Later**]   [**Don't Ask Again**]

**Step 2: Action Based on User Choice**

* **"Yes, Rate Now"**: You then call the `in_app_review` package to trigger the official OS prompt. The user can rate right there without leaving the app.
* **"Later"**: Dismiss the dialog. Reset your timer/counter to ask again after a longer period.
* **"Don't Ask Again"**: Save a permanent flag in the user's preferences (`SharedPreferences` or similar). You will check this flag before ever showing the prompt again.

This two-step system is the key. It allows you to offer the "Don't Ask Again" option while still using the official, recommended review API.

---

### The Detailed Plan: When, Who, and How Often

We will define a set of conditions that must be met before we even show our custom "Sentiment" dialog.

#### Phase 1: The First Week Launch Boost (Days 1-7)

The goal here is to quickly identify your most engaged early adopters. They are the most likely to be excited about your app and leave a positive review.

* **When to Ask:** Trigger the prompt when a user meets **at least two** of these criteria:
  * Has opened the app on **3 different days**.
  * Has used the app for a total of **10+ minutes**.
  * Has successfully completed a "key positive action" **twice**. (e.g., saved an item, completed a level, exported a file, used a core feature).
* **Who to Ask:** All users (Free and Pro). At this stage, you just want engagement.
* **How Often:** Only show the prompt **once** during this first week. If they tap "Later", don't ask again until Phase 2 begins.

This strategy respects the user by waiting for clear signs of engagement but is aggressive enough to capitalize on the initial launch excitement.

#### Phase 2: The Long-Term Sustainable Strategy (Day 8 onwards)

This is your ongoing strategy for accumulating reviews over time.

* **When to Ask (First Prompt):**
  * The user has been using the app for at least **7 days**.
  * Has opened the app at least **5 times**.
  * Has completed a "key positive action" at least **3 times**.
  * **Crucially:** Trigger the prompt immediately after they complete a key positive action, not on app launch. For example, after they save their third project, show the prompt. This is a "moment of triumph" and the best time to ask.

* **Who to Ask:**
  * **Engaged Free Users:** Users who meet the criteria above.
  * **Pro Users:** These users are already financially invested and are prime candidates for reviews. You can have slightly more relaxed criteria for them (e.g., 3 days after upgrading to Pro and having used a Pro feature).

* **How Often (The Cadence):**
    1. **First Prompt:** Triggered when the initial criteria are met.
        * If they select **"Rate Now"**: You're done. Whether they leave a review or not, don't ask again for a very long time (e.g., 6 months, or after a major app update).
        * If they select **"Don't Ask Again"**: Set the permanent flag. Never ask again.
        * If they select **"Later"**: Wait for a significant period.
    2. **Second Prompt:**
        * **Wait at least 14-21 days** after the first "Later" click.
        * The user must again complete another key positive action.
        * Show the same prompt. If they select "Later" again, move to the final prompt.
    3. **Third (and Final) Prompt:**
        * **Wait at least 30-45 days** after the second "Later" click.
        * This is your last attempt. If they select "Later" this time, treat it as a "Don't Ask Again" and set the permanent flag. Three asks is the absolute maximum before it becomes annoying.

---

### Implementation in Flutter

Here's a conceptual outline of how you'd implement this logic.

1. **Add Packages:**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      in_app_review: ^2.0.8 # Use latest version
      shared_preferences: ^2.2.2 # Use latest version
    ```

2. **Create a `ReviewService`:**
    This class will manage all the logic.

    ```dart
    import 'package:in_app_review/in_app_review.dart';
    import 'package:shared_preferences/shared_preferences.dart';

    class ReviewService {
      final InAppReview _inAppReview = InAppReview.instance;
      final SharedPreferences _prefs;

      ReviewService(this._prefs);

      // --- Call this method after a key positive action ---
      Future<void> requestReviewAfterAction() async {
        // 1. Check if we should even consider showing a prompt
        final bool shouldNotAsk = _prefs.getBool('dontAskAgain') ?? false;
        if (shouldNotAsk) {
          return;
        }

        final int launchCount = _prefs.getInt('launchCount') ?? 0;
        final int keyActionCount = _prefs.getInt('keyActionCount') ?? 0;
        final DateTime firstLaunch = DateTime.fromMillisecondsSinceEpoch(
            _prefs.getInt('firstLaunch') ?? DateTime.now().millisecondsSinceEpoch);

        // Define your conditions here (adjust for launch week vs. long-term)
        bool conditionsMet = (launchCount >= 5 &&
            keyActionCount >= 3 &&
            DateTime.now().difference(firstLaunch).inDays >= 7);

        if (conditionsMet) {
          // 2. Show YOUR custom dialog (not the native one yet)
          // This is a placeholder for your actual UI dialog
          showMyCustomSentimentDialog().then((choice) {
            if (choice == 'rate_now') {
              _inAppReview.requestReview();
              // Prevent asking for a long time
              _prefs.setInt('lastReviewRequest', DateTime.now().millisecondsSinceEpoch);
            } else if (choice == 'dont_ask') {
              _prefs.setBool('dontAskAgain', true);
            } else if (choice == 'later') {
              // Reset counters or just wait for the next trigger
              _prefs.setInt('lastReviewRequest', DateTime.now().millisecondsSinceEpoch);
            }
          });
        }
      }

      // --- Call these methods at appropriate places in your app ---
      void incrementLaunchCount() {
        int count = (_prefs.getInt('launchCount') ?? 0) + 1;
        _prefs.setInt('launchCount', count);
      }

      void incrementKeyActionCount() {
        int count = (_prefs.getInt('keyActionCount') ?? 0) + 1;
        _prefs.setInt('keyActionCount', count);
        // This is a great place to call requestReviewAfterAction()
        requestReviewAfterAction();
      }

      void setFirstLaunchDate() {
        if (_prefs.getInt('firstLaunch') == null) {
          _prefs.setInt('firstLaunch', DateTime.now().millisecondsSinceEpoch);
        }
      }
    }
    ```

**In your `main.dart` or with your state management solution, you would initialize and use this service:**

* On app start, call `setFirstLaunchDate()` and `incrementLaunchCount()`.
* After a user completes a key action (e.g., in a `save` button's `onPressed`), call `incrementKeyActionCount()`.

This plan provides a robust, user-friendly, and effective way to gain reviews without alienating your user base. It gives you full control while respecting the platform guidelines.
