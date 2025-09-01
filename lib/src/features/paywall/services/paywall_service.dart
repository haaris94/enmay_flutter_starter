import 'dart:async';

import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/repositories/paywall_repository.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_service.g.dart';

@Riverpod(keepAlive: true)
PaywallService paywallService(Ref ref) {
  final repository = ref.watch(paywallRepositoryProvider);
  return PaywallService(repository);
}

class PaywallService {
  final PaywallRepository _repository;

  PaywallService(this._repository);

  // Stream controller for purchase updates
  final StreamController<PurchaseStatus> _purchaseStatusController = 
      StreamController<PurchaseStatus>.broadcast();

  Stream<PurchaseStatus> get purchaseStatusStream => _purchaseStatusController.stream;

  Future<PaywallState> initializePaywall() async {
    try {
      // Check if in-app purchase is available
      final isAvailable = await _repository.isInAppPurchaseAvailable();
      
      if (!isAvailable) {
        throw const Failure(
          title: 'Service Unavailable',
          message: 'In-app purchases are not available on this device',
          type: ErrorType.externalApi,
        );
      }

      // Start listening to purchase updates
      _repository.startPurchaseListener();

      // Get subscription status
      final isSubscribed = await _repository.getSubscriptionStatus();

      // Get paywall configuration
      final config = await _repository.getPaywallConfig();

      // Get products
      final productIds = config.products.map((p) => p.id).toList();
      final products = await _repository.getProducts(productIds);

      // Get selected product (or default to last product)
      final selectedProductId = await _repository.getSelectedProductId() ?? 
          (products.isNotEmpty ? products.last.id : null);

      return PaywallState(
        products: products,
        isSubscribed: isSubscribed,
        selectedProductId: selectedProductId,
        isLoading: false,
        isPurchasing: false,
        showCloseButton: false,
        cooldownProgress: 0.0,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<PaywallState> purchaseSubscription(String productId, PaywallState currentState) async {
    try {
      // Update state to show purchasing
      final updatedState = currentState.copyWith(
        isPurchasing: true,
        errorMessage: null,
      );

      // Perform purchase
      final success = await _repository.purchaseProduct(productId);
      
      if (success) {
        _purchaseStatusController.add(PurchaseStatus.purchased);
        
        return updatedState.copyWith(
          isPurchasing: false,
          isSubscribed: true,
          selectedProductId: productId,
        );
      } else {
        _purchaseStatusController.add(PurchaseStatus.error);
        
        return updatedState.copyWith(
          isPurchasing: false,
          errorMessage: 'Purchase failed. Please try again.',
        );
      }
    } catch (e) {
      _purchaseStatusController.add(PurchaseStatus.error);
      
      if (e is Failure) {
        return currentState.copyWith(
          isPurchasing: false,
          errorMessage: e.message,
        );
      }
      
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      
      return currentState.copyWith(
        isPurchasing: false,
        errorMessage: failure.message,
      );
    }
  }

  Future<PaywallState> restorePurchases(PaywallState currentState) async {
    try {
      final updatedState = currentState.copyWith(
        isLoading: true,
        errorMessage: null,
      );

      final success = await _repository.restorePurchases();
      
      if (success) {
        final isSubscribed = await _repository.getSubscriptionStatus();
        
        return updatedState.copyWith(
          isLoading: false,
          isSubscribed: isSubscribed,
          errorMessage: isSubscribed ? null : 'No purchases found to restore',
        );
      } else {
        return updatedState.copyWith(
          isLoading: false,
          errorMessage: 'Failed to restore purchases',
        );
      }
    } catch (e) {
      if (e is Failure) {
        return currentState.copyWith(
          isLoading: false,
          errorMessage: e.message,
        );
      }
      
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      
      return currentState.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      );
    }
  }

  Future<PaywallState> selectProduct(String productId, PaywallState currentState) async {
    try {
      await _repository.setSelectedProductId(productId);
      
      return currentState.copyWith(
        selectedProductId: productId,
        errorMessage: null,
      );
    } catch (e) {
      if (e is Failure) {
        return currentState.copyWith(
          errorMessage: e.message,
        );
      }
      
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      
      return currentState.copyWith(
        errorMessage: failure.message,
      );
    }
  }

  PaywallState updateCooldownProgress(double progress, PaywallState currentState) {
    final showCloseButton = progress >= 1.0;
    
    return currentState.copyWith(
      cooldownProgress: progress,
      showCloseButton: showCloseButton,
    );
  }

  Future<bool> isTrialEligible() async {
    try {
      final isTrialUsed = await _repository.isTrialUsed();
      return !isTrialUsed;
    } catch (e) {
      // If we can't determine trial status, assume eligible
      return true;
    }
  }

  Future<List<String>> getPurchaseHistory() async {
    try {
      return await _repository.getPurchaseHistory();
    } catch (e) {
      return [];
    }
  }

  String getCallToActionText(String? selectedProductId, List<PurchaseProduct> products) {
    if (selectedProductId == null || products.isEmpty) {
      return 'Unlock Now';
    }

    try {
      final selectedProduct = products.firstWhere((p) => p.id == selectedProductId);
      return selectedProduct.hasTrial ? 'Start Free Trial' : 'Unlock Now';
    } catch (e) {
      return 'Unlock Now';
    }
  }

  double? calculateFullPrice(List<PurchaseProduct> products) {
    try {
      final weeklyProduct = products.where((p) => p.duration == 'week').firstOrNull;
      if (weeklyProduct == null) return null;

      final priceString = weeklyProduct.price.replaceAll(RegExp(r'[^\d.]'), '');
      final weeklyPrice = double.tryParse(priceString);
      
      if (weeklyPrice == null) return null;
      
      return weeklyPrice * 52; // Weekly price * 52 weeks
    } catch (e) {
      return null;
    }
  }

  int calculatePercentageSaved(List<PurchaseProduct> products) {
    try {
      final fullPrice = calculateFullPrice(products);
      if (fullPrice == null) return 90; // Default savings

      final yearlyProduct = products.where((p) => p.duration == 'year').firstOrNull;
      if (yearlyProduct == null) return 90;

      final yearlyPriceString = yearlyProduct.price.replaceAll(RegExp(r'[^\d.]'), '');
      final yearlyPrice = double.tryParse(yearlyPriceString);
      
      if (yearlyPrice == null) return 90;

      final saved = ((fullPrice - yearlyPrice) / fullPrice * 100).round();
      return saved > 0 ? saved : 90;
    } catch (e) {
      return 90; // Default savings
    }
  }

  Future<PaywallConfig> getPaywallConfig() async {
    try {
      return await _repository.getPaywallConfig();
    } catch (e) {
      if (e is Failure) rethrow;
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.localStorage,
      );
      throw failure;
    }
  }

  Future<void> updatePaywallConfig(PaywallConfig config) async {
    try {
      await _repository.savePaywallConfig(config);
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
    _repository.stopPurchaseListener();
    _purchaseStatusController.close();
    _repository.dispose();
  }
}