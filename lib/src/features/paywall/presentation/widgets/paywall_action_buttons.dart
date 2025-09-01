import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaywallActionButtons extends StatelessWidget {
  final String callToActionText;
  final bool isPurchasing;
  final bool isLoading;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;
  final String termsUrl;
  final String privacyUrl;

  const PaywallActionButtons({
    super.key,
    required this.callToActionText,
    required this.isPurchasing,
    required this.isLoading,
    required this.onPurchase,
    required this.onRestore,
    required this.termsUrl,
    required this.privacyUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Purchase Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (isPurchasing || isLoading) ? null : onPurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: isPurchasing
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(context.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        callToActionText,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: context.onPrimary,
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Footer Links
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          spacing: 16,
          children: [
            _FooterLink(
              text: 'Restore',
              onTap: onRestore,
            ),
            _FooterLink(
              text: 'Terms & Privacy',
              onTap: () => _showTermsAndPrivacySheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showTermsAndPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terms & Privacy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms of Use'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(termsUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(privacyUrl);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}