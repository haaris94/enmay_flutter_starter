# Flutter Local Notifications Setup

This document provides a detailed guide for setting up the `flutter_local_notifications` plugin for both Android and iOS platforms.

## Part 1: Platform Setup

### Android Setup

1. **Add Notification Icon**:
    * The default notification icon is `@mipmap/ic_launcher`. It's recommended to create a custom icon.
    * Place your custom notification icon in the `android/app/src/main/res/drawable` directory. For example, `android/app/src/main/res/drawable/app_icon.png`.

2. **Update Gradle Configuration**:

    * Enable desugaring for Java 8+ APIs. Open `android/app/build.gradle` and add the following configurations:

        ```groovy
        android {
            defaultConfig {
                multiDexEnabled true
            }
            compileOptions {
                // Flag to enable support for the new language APIs
                coreLibraryDesugaringEnabled true
                // Sets Java compatibility to Java 11
                sourceCompatibility JavaVersion.VERSION_11
                targetCompatibility JavaVersion.VERSION_11
            }
        }
        
        dependencies {
            coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
        }
        ```

    * Update the Android Gradle Plugin (AGP) version. Open `android/build.gradle` and ensure you are using a compatible version:

        ```groovy
        buildscript {
            dependencies {
                classpath 'com.android.tools.build:gradle:8.6.0'
            }
        }
        ```

    * Set the `compileSdk` to at least 35 in `android/app/build.gradle`:
        ```groovy
        android {
            compileSdk 35
            ...
        }
        ```

3. **Configure Android Manifest**:
    * Open `android/app/src/main/AndroidManifest.xml` and add the necessary permissions and receivers.
    * For scheduled notifications, add the following inside the `<manifest>` tag:

        ```xml
        <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
        <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
        ```

    * Add the following receivers inside the `<application>` tag to handle scheduled notifications and re-scheduling after a device reboot:

        ```xml
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        ```

4. **Requesting Permissions on Android 13+**:
    * From Android 13 (API level 33) onwards, you must request the `POST_NOTIFICATIONS` permission from the user at runtime.
    * This is handled within the app's Dart code by calling `requestNotificationsPermission()`.

### iOS Setup

1. **Configure AppDelegate**:
    * Open `ios/Runner/AppDelegate.swift`.
    * Add the following code to the `application(_:didFinishLaunchingWithOptions:)` method to handle notifications when the app is in the foreground.

        ```swift
        import UIKit
        import Flutter
        import flutter_local_notifications
        
        @UIApplicationMain
        @objc class AppDelegate: FlutterAppDelegate {
          override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
          ) -> Bool {
            // This is required to make any communication available in the action isolate.
            FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
                GeneratedPluginRegistrant.register(with: registry)
            }
        
            if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            }
        
            GeneratedPluginRegistrant.register(with: self)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
          }
        }
        ```

    * Alternatively, for Objective-C projects, open `ios/Runner/AppDelegate.m` and add:

        ```objectivec
        #import "AppDelegate.h"
        #import "GeneratedPluginRegistrant.h"
        #import <FlutterLocalNotificationsPlugin.h>
        
        @implementation AppDelegate
        
        - (BOOL)application:(UIApplication *)application
            didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
          [GeneratedPluginRegistrant registerWithRegistry:self];
        
          if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
          }
        
          return [super application:application didFinishLaunchingWithOptions:launchOptions];
        }
        
        @end
        ```

2. **Requesting Permissions**:
    * Notification permissions must be requested from the user at runtime.
    * This is typically done in the Dart code using the `requestPermissions()` method.

---

## Part 2: AI Agent Implementation Plan for a Reusable Notification Service

Here is a detailed plan for an AI agent to implement a clean and reusable `NotificationService` in a Flutter starter project.

### 1. Create the Notification Service File

* **Action:** Create a new file named `notification_service.dart` inside the `lib/services/` directory.

### 2. Implement the `NotificationService` Class

* **Action:** Add the following code to `lib/services/notification_service.dart`. This creates a singleton class that provides a centralized way to manage notifications.

    ```dart
    import 'package:flutter_local_notifications/flutter_local_notifications.dart';
    import 'package:timezone/data/latest_all.dart' as tz;
    import 'package:timezone/timezone.dart' as tz;
    
    class NotificationService {
      static final NotificationService _instance = NotificationService._internal();
      factory NotificationService() => _instance;
    
      NotificationService._internal();
    
      final FlutterLocalNotificationsPlugin _notificationsPlugin =
          FlutterLocalNotificationsPlugin();
    
      Future<void> init() async {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('app_icon');
    
        final DarwinInitializationSettings initializationSettingsIOS =
            DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );
    
        final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    
        tz.initializeTimeZones();
    
        await _notificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );
      }
    
      void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
        // Handle notification tap
      }
    
      Future<void> requestPermissions() async {
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
    
        // Android permission request
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
    
        // iOS permission request
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }
    
      Future<void> scheduleDaily(
        int id,
        String title,
        String body,
        int hour,
        int minute,
      ) async {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          _nextInstanceOfTime(hour, minute),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_notification_channel_id',
              'Daily Notifications',
              channelDescription: 'Channel for daily notifications',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    
      tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
        tz.TZDateTime scheduledDate =
            tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
        return scheduledDate;
      }
    }
    ```

### 3. Initialize the Notification Service

* **Action:** Open `lib/main.dart` and initialize the `NotificationService` in the `main()` function before running the app.

    ```dart
    import 'package:flutter/material.dart';
    import 'package:your_app_name/services/notification_service.dart';
    
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService().init();
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Local Notifications'),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  NotificationService().requestPermissions();
                },
                child: const Text('Request Permissions'),
              ),
            ),
          ),
        );
      }
    }
    ```

### 4. How to Use the `NotificationService`

* **Requesting Permissions:**
  * Call `NotificationService().requestPermissions();` at an appropriate point in your app, for example, in the `initState` of your main screen or in response to a button press.

* **Scheduling a Daily Notification:**
  * To schedule a daily notification, call the `scheduleDaily` method with a unique ID, title, body, and the desired time.

        ```dart
        NotificationService().scheduleDaily(
          0,
          'Good Morning!',
          'Here is your daily reminder.',
          8, // Hour
          0,  // Minute
        );
        ```
