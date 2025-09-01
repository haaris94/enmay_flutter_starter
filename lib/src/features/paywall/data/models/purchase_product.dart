import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_product.freezed.dart';
part 'purchase_product.g.dart';

@freezed
abstract class PurchaseProduct with _$PurchaseProduct {
  const factory PurchaseProduct({
    required String id,
    required String price,
    required String duration,
    required String planName,
    required bool hasTrial,
    String? localizedPrice,
    String? currencyCode,
    String? description,
  }) = _PurchaseProduct;

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) =>
      _$PurchaseProductFromJson(json);
}

@freezed
abstract class PaywallState with _$PaywallState {
  const factory PaywallState({
    @Default([]) List<PurchaseProduct> products,
    @Default(false) bool isLoading,
    @Default(false) bool isPurchasing,
    @Default(false) bool isSubscribed,
    @Default(false) bool showCloseButton,
    @Default(0.0) double cooldownProgress,
    String? selectedProductId,
    String? errorMessage,
  }) = _PaywallState;

  factory PaywallState.fromJson(Map<String, dynamic> json) =>
      _$PaywallStateFromJson(json);
}

@freezed
abstract class PaywallConfig with _$PaywallConfig {
  const factory PaywallConfig({
    required String title,
    required List<PaywallFeature> features,
    required List<PurchaseProduct> products,
    required String heroImagePath,
    @Default(5.0) double cooldownDuration,
    @Default(true) bool hasCooldown,
    required String termsUrl,
    required String privacyUrl,
  }) = _PaywallConfig;

  factory PaywallConfig.fromJson(Map<String, dynamic> json) =>
      _$PaywallConfigFromJson(json);
}

@freezed
abstract class PaywallFeature with _$PaywallFeature {
  const factory PaywallFeature({
    required String title,
    required String iconName,
    @Default(0xFF6366F1) int colorValue,
  }) = _PaywallFeature;

  factory PaywallFeature.fromJson(Map<String, dynamic> json) =>
      _$PaywallFeatureFromJson(json);
}