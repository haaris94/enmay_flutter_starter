import 'dart:convert';

import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaywallLocalDataSource {
  static const String _keySubscriptionStatus = 'subscription_status';
  static const String _keySelectedProductId = 'selected_product_id';
  static const String _keyPaywallConfig = 'paywall_config';
  static const String _keyPurchaseHistory = 'purchase_history';
  static const String _keyTrialUsed = 'trial_used';

  Future<bool> getSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keySubscriptionStatus) ?? false;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setSubscriptionStatus(bool isSubscribed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keySubscriptionStatus, isSubscribed);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<String?> getSelectedProductId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keySelectedProductId);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setSelectedProductId(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySelectedProductId, productId);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<PaywallConfig?> getPaywallConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_keyPaywallConfig);
      
      if (configJson == null) return null;
      
      final configMap = json.decode(configJson) as Map<String, dynamic>;
      return PaywallConfig.fromJson(configMap);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setPaywallConfig(PaywallConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(config.toJson());
      await prefs.setString(_keyPaywallConfig, configJson);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<List<String>> getPurchaseHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_keyPurchaseHistory) ?? [];
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> addPurchaseToHistory(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getPurchaseHistory();
      
      if (!history.contains(productId)) {
        history.add(productId);
        await prefs.setStringList(_keyPurchaseHistory, history);
      }
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<bool> isTrialUsed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyTrialUsed) ?? false;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setTrialUsed(bool used) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTrialUsed, used);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keySubscriptionStatus);
      await prefs.remove(_keySelectedProductId);
      await prefs.remove(_keyPaywallConfig);
      await prefs.remove(_keyPurchaseHistory);
      await prefs.remove(_keyTrialUsed);
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  // Default paywall configuration
  PaywallConfig getDefaultConfig() {
    return const PaywallConfig(
      title: 'Unlock Premium Access',
      features: [
        PaywallFeature(
          title: 'Add first feature here',
          iconName: 'star',
        ),
        PaywallFeature(
          title: 'Then add second feature',
          iconName: 'star',
        ),
        PaywallFeature(
          title: 'Put final feature here',
          iconName: 'star',
        ),
        PaywallFeature(
          title: 'Remove annoying paywalls',
          iconName: 'lock',
        ),
      ],
      products: [
        PurchaseProduct(
          id: 'demo_y',
          price: '\$25.99',
          duration: 'year',
          planName: 'Yearly Plan',
          hasTrial: false,
        ),
        PurchaseProduct(
          id: 'demo_w',
          price: '\$4.99',
          duration: 'week',
          planName: '3-Day Trial',
          hasTrial: true,
        ),
      ],
      heroImagePath: 'assets/images/paywall_hero.png',
      termsUrl: 'https://example.com/terms',
      privacyUrl: 'https://example.com/privacy',
    );
  }
}