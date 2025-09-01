import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/providers/paywall_provider.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/widgets/paywall_action_buttons.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/widgets/paywall_hero_section.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/widgets/purchase_feature_item.dart';
import 'package:enmay_flutter_starter/src/features/paywall/presentation/widgets/purchase_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  PaywallConfig? _config;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await ref.read(paywallNotifierProvider.notifier).getPaywallConfig();
      if (mounted) {
        setState(() {
          _config = config;
        });
      }
    } catch (e) {
      // Use default config if loading fails
      if (mounted) {
        setState(() {
          _config = const PaywallConfig(
            title: 'Unlock Premium Access',
            features: [
              PaywallFeature(title: 'Add first feature here', iconName: 'star'),
              PaywallFeature(title: 'Then add second feature', iconName: 'star'),
              PaywallFeature(title: 'Put final feature here', iconName: 'star'),
              PaywallFeature(title: 'Remove annoying paywalls', iconName: 'lock'),
            ],
            products: [],
            heroImagePath: '',
            termsUrl: 'https://example.com/terms',
            privacyUrl: 'https://example.com/privacy',
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paywallState = ref.watch(paywallNotifierProvider);

    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: paywallState.when(
          data: (state) => _buildPaywallContent(context, state),
          loading: () => _buildLoadingState(context),
          error: (error, _) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildPaywallContent(BuildContext context, PaywallState state) {
    if (_config == null) {
      return _buildLoadingState(context);
    }

    return Stack(
      children: [
        // Main Content
        Column(
          children: [
            // Close Button / Cooldown Timer
            _buildTopBar(context, state),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Hero Section
                    PaywallHeroSection(
                      heroImagePath: _config!.heroImagePath,
                      title: _config!.title,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Features List
                    _buildFeaturesList(context),
                    
                    const SizedBox(height: 40),
                    
                    // Products Section
                    _buildProductsSection(context, state),
                    
                    const SizedBox(height: 32),
                    
                    // Free Trial Toggle (matching SwiftUI design)
                    _buildTrialToggle(context, state),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    _buildActionButtons(context, state),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Loading Overlay
        if (state.isPurchasing || state.isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, PaywallState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (state.showCloseButton)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                size: 20,
                color: context.onSurface.withOpacity(0.6),
              ),
            )
          else if (_config?.hasCooldown == true)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: state.cooldownProgress,
                strokeWidth: 2,
                backgroundColor: context.outline.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.primary.withOpacity(0.3 + 0.7 * state.cooldownProgress),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Column(
      children: _config!.features
          .map((feature) => PurchaseFeatureItem(
                feature: feature,
                color: context.primary,
              ))
          .toList(),
    );
  }

  Widget _buildProductsSection(BuildContext context, PaywallState state) {
    if (state.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: state.products.map((product) {
        final isSelected = product.id == state.selectedProductId;
        final notifier = ref.read(paywallNotifierProvider.notifier);
        
        return PurchaseProductCard(
          product: product,
          isSelected: isSelected,
          onTap: () => notifier.selectProduct(product.id),
          fullPrice: notifier.calculateFullPrice(),
          percentageSaved: product.duration == 'year' 
              ? notifier.calculatePercentageSaved() 
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildTrialToggle(BuildContext context, PaywallState state) {
    // Find if there's a trial product
    final hasTrialProduct = state.products.any((p) => p.hasTrial);
    if (!hasTrialProduct) return const SizedBox.shrink();

    final trialProduct = state.products.firstWhere((p) => p.hasTrial);
    final isTrialSelected = state.selectedProductId == trialProduct.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Free Trial Enabled',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.onSurface,
              ),
            ),
          ),
          Switch(
            value: isTrialSelected,
            onChanged: (value) {
              final notifier = ref.read(paywallNotifierProvider.notifier);
              if (value) {
                notifier.selectProduct(trialProduct.id);
              } else {
                // Select the first non-trial product
                final nonTrialProduct = state.products.firstWhere(
                  (p) => !p.hasTrial,
                  orElse: () => state.products.first,
                );
                notifier.selectProduct(nonTrialProduct.id);
              }
            },
            activeColor: context.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PaywallState state) {
    final notifier = ref.read(paywallNotifierProvider.notifier);
    
    return PaywallActionButtons(
      callToActionText: notifier.getCallToActionText(),
      isPurchasing: state.isPurchasing,
      isLoading: state.isLoading,
      onPurchase: () => _handlePurchase(state),
      onRestore: () => notifier.restorePurchases(),
      termsUrl: _config?.termsUrl ?? 'https://example.com/terms',
      privacyUrl: _config?.privacyUrl ?? 'https://example.com/privacy',
    );
  }

  void _handlePurchase(PaywallState state) {
    if (state.selectedProductId == null) {
      _showError('Please select a subscription plan');
      return;
    }

    final notifier = ref.read(paywallNotifierProvider.notifier);
    notifier.purchaseSubscription(state.selectedProductId!);
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading subscription plans...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load subscription plans',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(paywallNotifierProvider);
                _loadConfig();
              },
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.error,
        ),
      );
    }
  }
}