import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:enmay_flutter_starter/src/features/paywall/data/models/purchase_product.dart';
import 'package:flutter/material.dart';

class PurchaseFeatureItem extends StatelessWidget {
  final PaywallFeature feature;
  final Color? color;

  const PurchaseFeatureItem({
    super.key,
    required this.feature,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final effectiveColor = color ?? Color(feature.colorValue);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            _getIconData(feature.iconName),
            size: 27,
            color: effectiveColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 19,
                color: appColors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'lock':
        return Icons.lock;
      case 'lock.square.stack':
        return Icons.layers_outlined;
      case 'heart':
        return Icons.favorite;
      case 'shield':
        return Icons.security;
      case 'flash':
        return Icons.flash_on;
      case 'diamond':
        return Icons.diamond;
      case 'crown':
        return Icons.workspace_premium;
      case 'magic.wand':
        return Icons.auto_fix_high;
      case 'paintbrush':
        return Icons.brush;
      case 'camera':
        return Icons.camera_alt;
      case 'music.note':
        return Icons.music_note;
      case 'globe':
        return Icons.public;
      case 'cloud':
        return Icons.cloud;
      case 'infinity':
        return Icons.all_inclusive;
      case 'checkmark.circle':
        return Icons.check_circle;
      case 'plus.circle':
        return Icons.add_circle;
      case 'gear':
        return Icons.settings;
      case 'rocket':
        return Icons.rocket_launch;
      default:
        return Icons.star;
    }
  }
}