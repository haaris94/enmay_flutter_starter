import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:flutter/material.dart';

class PurchaseProductCard extends StatelessWidget {
  final PurchaseProduct product;
  final bool isSelected;
  final VoidCallback onTap;
  final double? fullPrice;
  final int? percentageSaved;

  const PurchaseProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    this.fullPrice,
    this.percentageSaved,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final borderColor = isSelected ? appColors.primary! : appColors.border!.withValues(alpha: 0.3);
    final backgroundColor = isSelected 
        ? appColors.primary!.withValues(alpha: 0.05)
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.planName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildPriceRow(context),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildTrailingWidget(context),
            const SizedBox(width: 8),
            _buildSelectionIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    if (product.hasTrial) {
      return Text(
        'then ${product.price} per ${product.duration}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: appColors.foreground!.withValues(alpha: 0.8),
        ),
      );
    }

    return Row(
      children: [
        if (fullPrice != null && percentageSaved != null) ...[
          Text(
            _formatPrice(fullPrice!),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: appColors.foreground!.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          '${product.price} per ${product.duration}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: appColors.foreground!.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingWidget(BuildContext context) {
    if (product.hasTrial) {
      // For trial products, we might show "FREE" badge but the comment
      // in the Swift code mentions Apple rejection, so we'll keep it minimal
      return const SizedBox.shrink();
    }

    if (percentageSaved != null && percentageSaved! > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'SAVE $percentageSaved%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? appColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? appColors.primary! : appColors.border!.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 14,
              color: appColors.primaryForeground,
            )
          : null,
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}