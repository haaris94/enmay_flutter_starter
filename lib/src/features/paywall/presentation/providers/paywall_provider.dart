import 'dart:async';

import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:enmay_flutter_starter/src/features/paywall/services/paywall_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_provider.g.dart';

@riverpod
class PaywallNotifier extends _$PaywallNotifier {
  PaywallService? _paywallService;
  Timer? _cooldownTimer;
  StreamSubscription? _purchaseStatusSubscription;

  @override
  Future<PaywallState> build() async {
    _paywallService = ref.watch(paywallServiceProvider);
    
    // Listen to purchase status updates
    _purchaseStatusSubscription = _paywallService!.purchaseStatusStream.listen(
      (status) {
        // Handle purchase status updates if needed
      },
    );

    // Initialize paywall
    final initialState = await _paywallService!.initializePaywall();
    
    // Start cooldown timer if needed
    final config = await _paywallService!.getPaywallConfig();
    if (config.hasCooldown) {
      _startCooldownTimer(config.cooldownDuration);
    }
    
    return initialState;
  }

  Future<void> purchaseSubscription(String productId) async {
    if (state.hasValue) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final currentState = state.requireValue;
        return await _paywallService!.purchaseSubscription(productId, currentState);
      });
    }
  }

  Future<void> restorePurchases() async {
    if (state.hasValue) {
      state = await AsyncValue.guard(() async {
        final currentState = state.requireValue;
        return await _paywallService!.restorePurchases(currentState);
      });
    }
  }

  Future<void> selectProduct(String productId) async {
    if (state.hasValue) {
      state = await AsyncValue.guard(() async {
        final currentState = state.requireValue;
        return await _paywallService!.selectProduct(productId, currentState);
      });
    }
  }

  void _startCooldownTimer(double durationInSeconds) {
    const updateInterval = Duration(milliseconds: 100);
    final totalUpdates = (durationInSeconds * 1000 / updateInterval.inMilliseconds).round();
    int currentUpdate = 0;

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(updateInterval, (timer) {
      if (!state.hasValue) {
        timer.cancel();
        return;
      }

      currentUpdate++;
      final progress = (currentUpdate / totalUpdates).clamp(0.0, 1.0);
      
      final currentState = state.requireValue;
      final updatedState = _paywallService!.updateCooldownProgress(progress, currentState);
      
      // Update state without triggering async guard
      state = AsyncValue.data(updatedState);

      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  Future<bool> isTrialEligible() async {
    return await _paywallService?.isTrialEligible() ?? true;
  }

  Future<List<String>> getPurchaseHistory() async {
    return await _paywallService?.getPurchaseHistory() ?? [];
  }

  String getCallToActionText() {
    if (!state.hasValue) return 'Unlock Now';
    
    final currentState = state.requireValue;
    return _paywallService?.getCallToActionText(
      currentState.selectedProductId,
      currentState.products,
    ) ?? 'Unlock Now';
  }

  double? calculateFullPrice() {
    if (!state.hasValue) return null;
    
    final currentState = state.requireValue;
    return _paywallService?.calculateFullPrice(currentState.products);
  }

  int calculatePercentageSaved() {
    if (!state.hasValue) return 90;
    
    final currentState = state.requireValue;
    return _paywallService?.calculatePercentageSaved(currentState.products) ?? 90;
  }

  Future<PaywallConfig> getPaywallConfig() async {
    return await _paywallService?.getPaywallConfig() ?? 
        const PaywallConfig(
          title: 'Unlock Premium Access',
          features: [],
          products: [],
          heroImagePath: '',
          termsUrl: '',
          privacyUrl: '',
        );
  }

  Future<void> updatePaywallConfig(PaywallConfig config) async {
    await _paywallService?.updatePaywallConfig(config);
  }

  void clearError() {
    if (state.hasValue) {
      final currentState = state.requireValue;
      state = AsyncValue.data(currentState.copyWith(errorMessage: null));
    }
  }

  void dispose() {
    _cooldownTimer?.cancel();
    _purchaseStatusSubscription?.cancel();
    _paywallService?.dispose();
  }
}

// Additional providers for specific data
@riverpod
Future<bool> isSubscribed(Ref ref) async {
  final paywallState = await ref.watch(paywallNotifierProvider.future);
  return paywallState.isSubscribed;
}

@riverpod
Future<List<PurchaseProduct>> paywallProducts(Ref ref) async {
  final paywallState = await ref.watch(paywallNotifierProvider.future);
  return paywallState.products;
}

@riverpod
Future<PaywallConfig> paywallConfig(Ref ref) async {
  final notifier = ref.read(paywallNotifierProvider.notifier);
  return await notifier.getPaywallConfig();
}