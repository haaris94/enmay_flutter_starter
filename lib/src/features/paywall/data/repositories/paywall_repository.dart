import 'dart:async';

import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/datasources/local/paywall_local_datasource.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/datasources/remote/in_app_purchase_datasource.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_repository.g.dart';

@Riverpod(keepAlive: true)
PaywallRepository paywallRepository(Ref ref) => PaywallRepository();

class PaywallRepository {
  final InAppPurchaseDataSource _purchaseDataSource = InAppPurchaseDataSource();
  final PaywallLocalDataSource _localDataSource = PaywallLocalDataSource();

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  Future<bool> isInAppPurchaseAvailable() async {
    try {
      return await _purchaseDataSource.isAvailable();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<List<PurchaseProduct>> getProducts(List<String> productIds) async {
    try {
      if (productIds.isEmpty) {
        // Return default products if no product IDs provided
        final config = await getPaywallConfig();
        return config.products;
      }

      final products = await _purchaseDataSource.getProducts(productIds);
      return products;
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> purchaseProduct(String productId) async {
    try {
      final result = await _purchaseDataSource.purchaseProduct(productId);
      
      if (result) {
        await _localDataSource.addPurchaseToHistory(productId);
        await _localDataSource.setSelectedProductId(productId);
        
        // Check if it's a trial product
        final products = await getProducts([productId]);
        final product = products.firstWhere((p) => p.id == productId);
        
        if (product.hasTrial) {
          await _localDataSource.setTrialUsed(true);
        }
      }
      
      return result;
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
      final result = await _purchaseDataSource.restorePurchases();
      return result;
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
      return await _localDataSource.getSubscriptionStatus();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setSubscriptionStatus(bool isSubscribed) async {
    try {
      await _localDataSource.setSubscriptionStatus(isSubscribed);
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<String?> getSelectedProductId() async {
    try {
      return await _localDataSource.getSelectedProductId();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> setSelectedProductId(String productId) async {
    try {
      await _localDataSource.setSelectedProductId(productId);
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

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

  Future<void> savePaywallConfig(PaywallConfig config) async {
    try {
      await _localDataSource.setPaywallConfig(config);
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<List<String>> getPurchaseHistory() async {
    try {
      return await _localDataSource.getPurchaseHistory();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<bool> isTrialUsed() async {
    try {
      return await _localDataSource.isTrialUsed();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseDataSource.purchaseStream;

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final isValid = await _purchaseDataSource.verifyPurchase(purchaseDetails);
      
      if (isValid) {
        await setSubscriptionStatus(true);
        await _localDataSource.addPurchaseToHistory(purchaseDetails.productID);
      }
      
      return isValid;
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      await _purchaseDataSource.completePurchase(purchaseDetails);
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  void startPurchaseListener() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) async {
        for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
          try {
            await _handlePurchaseUpdate(purchaseDetails);
          } catch (e) {
            // Log error but don't throw to prevent breaking the stream
            ErrorHandler.handle(
              Exception('Purchase update failed: ${e.toString()}'),
              context: ErrorContext.inAppPurchase,
            );
          }
        }
      },
      onError: (error) {
        ErrorHandler.handle(
          Exception('Purchase stream error: ${error.toString()}'),
          context: ErrorContext.inAppPurchase,
        );
      },
    );
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    switch (purchaseDetails.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        final isValid = await verifyPurchase(purchaseDetails);
        if (isValid) {
          await completePurchase(purchaseDetails);
        }
        break;
      case PurchaseStatus.error:
        await completePurchase(purchaseDetails);
        break;
      case PurchaseStatus.pending:
        // Handle pending purchases (e.g., show loading state)
        break;
      case PurchaseStatus.canceled:
        await completePurchase(purchaseDetails);
        break;
    }
  }

  void stopPurchaseListener() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
  }

  Future<void> clearAllData() async {
    try {
      await _localDataSource.clearAllData();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  void dispose() {
    stopPurchaseListener();
    _purchaseDataSource.dispose();
  }
}