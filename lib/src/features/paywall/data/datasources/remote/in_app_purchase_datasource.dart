import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseDataSource {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<bool> isAvailable() async {
    try {
      return await _inAppPurchase.isAvailable();
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<List<PurchaseProduct>> getProducts(List<String> productIds) async {
    try {
      final response = await _inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        throw const Failure(
          title: 'Product Query Failed',
          message: 'Unable to load subscription plans',
          type: ErrorType.externalApi,
        );
      }

      return response.productDetails.map((product) {
        return PurchaseProduct(
          id: product.id,
          price: product.price,
          duration: _getDurationFromProductId(product.id),
          planName: _getPlanNameFromProductId(product.id),
          hasTrial: _hasTrialFromProductId(product.id),
          localizedPrice: product.price,
          currencyCode: product.currencyCode,
          description: product.description,
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

  Future<bool> purchaseProduct(String productId) async {
    try {
      final productDetailsResponse = await _inAppPurchase.queryProductDetails({productId});
      
      if (productDetailsResponse.error != null || productDetailsResponse.productDetails.isEmpty) {
        throw const Failure(
          title: 'Product Not Found',
          message: 'The selected subscription plan is not available',
          type: ErrorType.externalApi,
        );
      }

      final productDetails = productDetailsResponse.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      
      final result = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
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
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      // For production apps, you should verify purchases server-side
      // This is a simplified client-side verification
      return purchaseDetails.status == PurchaseStatus.purchased;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.inAppPurchase,
      );
      throw failure;
    }
  }

  // Helper methods to extract product information from product IDs
  String _getDurationFromProductId(String productId) {
    if (productId.contains('_y') || productId.contains('year')) return 'year';
    if (productId.contains('_w') || productId.contains('week')) return 'week';
    if (productId.contains('_m') || productId.contains('month')) return 'month';
    return 'month'; // default
  }

  String _getPlanNameFromProductId(String productId) {
    if (productId.contains('_y') || productId.contains('year')) return 'Yearly Plan';
    if (productId.contains('_w') || productId.contains('week')) return '3-Day Trial';
    if (productId.contains('_m') || productId.contains('month')) return 'Monthly Plan';
    return 'Subscription Plan'; // default
  }

  bool _hasTrialFromProductId(String productId) {
    return productId.contains('_w') || productId.contains('trial');
  }

  void dispose() {
    // Clean up any resources if needed
  }
}