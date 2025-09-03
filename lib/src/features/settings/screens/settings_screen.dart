import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:enmay_flutter_starter/src/features/settings/widgets/settings_section.dart';
import 'package:enmay_flutter_starter/src/features/settings/widgets/settings_tile.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: appColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: appColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appColors.foreground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Account Section
          SettingsSection(
            title: 'Account',
            children: [
              if (currentUser != null) ...[
                SettingsTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: appColors.primary,
                    child: Text(
                      currentUser.email?.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        color: appColors.primaryForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: currentUser.displayName ?? 'User',
                  subtitle: currentUser.email,
                  onTap: () {
                    // Navigate to profile screen
                  },
                ),
                SettingsTile(
                  leading: Icon(
                    Icons.workspace_premium_outlined,
                    color: appColors.primary,
                  ),
                  title: 'Subscription',
                  subtitle: 'Manage your premium features',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: appColors.mutedForeground,
                  ),
                  onTap: () {
                    context.pushNamed(AppRoutes.paywall.name);
                  },
                ),
              ],
              SettingsTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: appColors.destructive,
                ),
                title: 'Sign Out',
                titleColor: appColors.destructive,
                onTap: () => _showSignOutDialog(context),
              ),
            ],
          ),

          // Appearance Section
          SettingsSection(
            title: 'Appearance',
            children: [
              SettingsTile(
                leading: Icon(
                  Icons.palette_outlined,
                  color: appColors.primary,
                ),
                title: 'Theme',
                subtitle: _getThemeModeDescription(context),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _showThemeDialog(context),
              ),
            ],
          ),


          // Privacy & Security Section
          SettingsSection(
            title: 'Privacy & Security',
            children: [
              SettingsTile(
                leading: Icon(
                  Icons.data_usage_outlined,
                  color: appColors.primary,
                ),
                title: 'Data Usage',
                subtitle: 'Manage how we use your data',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () {
                  // Navigate to data usage screen
                },
              ),
              SettingsTile(
                leading: Icon(
                  Icons.privacy_tip_outlined,
                  color: appColors.primary,
                ),
                title: 'Privacy Policy',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _launchURL('https://your-privacy-policy-url.com'),
              ),
              SettingsTile(
                leading: Icon(
                  Icons.description_outlined,
                  color: appColors.primary,
                ),
                title: 'Terms of Service',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _launchURL('https://your-terms-url.com'),
              ),
            ],
          ),

          // Support Section
          SettingsSection(
            title: 'Support',
            children: [
              SettingsTile(
                leading: Icon(
                  Icons.feedback_outlined,
                  color: appColors.primary,
                ),
                title: 'Send Feedback',
                subtitle: 'Report bugs or share suggestions',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _showFeedback(context),
              ),
              SettingsTile(
                leading: Icon(
                  Icons.help_outline,
                  color: appColors.primary,
                ),
                title: 'Help Center',
                subtitle: 'Get help and find answers',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _launchURL('https://your-help-center-url.com'),
              ),
              SettingsTile(
                leading: Icon(
                  Icons.contact_support_outlined,
                  color: appColors.primary,
                ),
                title: 'Contact Support',
                subtitle: 'Get in touch with our team',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _launchEmail('support@yourapp.com'),
              ),
              SettingsTile(
                leading: Icon(
                  Icons.star_outline,
                  color: appColors.primary,
                ),
                title: 'Rate the App',
                subtitle: 'Share your experience',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: appColors.mutedForeground,
                ),
                onTap: () => _rateApp(),
              ),
            ],
          ),

          // About Section
          SettingsSection(
            title: 'About',
            children: [
              SettingsTile(
                leading: Icon(
                  Icons.info_outline,
                  color: appColors.primary,
                ),
                title: 'App Version',
                subtitle: _packageInfo != null 
                    ? '${_packageInfo!.version} (${_packageInfo!.buildNumber})'
                    : 'Loading...',
              ),
              SettingsTile(
                leading: Icon(
                  Icons.code_outlined,
                  color: appColors.primary,
                ),
                title: 'Build Info',
                subtitle: _packageInfo?.appName ?? 'Loading...',
              ),
              SettingsTile(
                leading: Icon(
                  Icons.favorite_outline,
                  color: appColors.primary,
                ),
                title: 'Made with ❤️',
                subtitle: 'Flutter Starter Template',
              ),
            ],
          ),

          // Advanced Section (Debug)
          if (_packageInfo?.version.contains('debug') ?? false)
            SettingsSection(
              title: 'Advanced',
              children: [
                SettingsTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: appColors.destructive,
                  ),
                  title: 'Clear Cache',
                  subtitle: 'Reset app data',
                  titleColor: appColors.destructive,
                  onTap: () => _showClearCacheDialog(context),
                ),
                SettingsTile(
                  leading: Icon(
                    Icons.download_outlined,
                    color: appColors.primary,
                  ),
                  title: 'Export Data',
                  subtitle: 'Download your information',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: appColors.mutedForeground,
                  ),
                  onTap: () {
                    // TODO: Implement data export
                  },
                ),
              ],
            ),

          // Bottom padding
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors.container,
        title: Text(
          'Sign Out',
          style: TextStyle(color: appColors.foreground),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: appColors.mutedForeground),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: appColors.mutedForeground),
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final router = GoRouter.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              navigator.pop();
              try {
                await ref.read(authRepositoryProvider).signOut();
                if (mounted) {
                  router.goNamed(AppRoutes.login.name);
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to sign out: ${e.toString()}'),
                      backgroundColor: appColors.destructive,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: appColors.destructive),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final adaptiveTheme = AdaptiveTheme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors.container,
        title: Text(
          'Choose Theme',
          style: TextStyle(color: appColors.foreground),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'Light',
              isSelected: adaptiveTheme.mode == AdaptiveThemeMode.light,
              onTap: () {
                try {
                  adaptiveTheme.setLight();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to update theme'),
                      backgroundColor: appColors.destructive,
                    ),
                  );
                }
              },
            ),
            _ThemeOption(
              title: 'Dark',
              isSelected: adaptiveTheme.mode == AdaptiveThemeMode.dark,
              onTap: () {
                try {
                  adaptiveTheme.setDark();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to update theme'),
                      backgroundColor: appColors.destructive,
                    ),
                  );
                }
              },
            ),
            _ThemeOption(
              title: 'System',
              isSelected: adaptiveTheme.mode == AdaptiveThemeMode.system,
              onTap: () {
                try {
                  adaptiveTheme.setSystem();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to update theme'),
                      backgroundColor: appColors.destructive,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors.container,
        title: Text(
          'Clear Cache',
          style: TextStyle(color: appColors.foreground),
        ),
        content: Text(
          'This will clear all cached data. Are you sure?',
          style: TextStyle(color: appColors.mutedForeground),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: appColors.mutedForeground),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                // TODO: Implement actual cache clearing logic here
                // For now, just show success message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Cache cleared successfully'),
                      backgroundColor: appColors.primary,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  final failure = ErrorHandler.handle(
                    Exception('Failed to clear cache: ${e.toString()}'),
                    context: ErrorContext.unknown,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(failure.message),
                      backgroundColor: appColors.destructive,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Clear',
              style: TextStyle(color: appColors.destructive),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Cannot launch URL: $url');
      }
    } catch (e) {
      if (mounted) {
        final failure = ErrorHandler.handle(
          Exception('Failed to open link: ${e.toString()}'),
          context: ErrorContext.unknown,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Theme.of(context).extension<AppColors>()!.destructive,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=Support Request',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Cannot launch email client');
      }
    } catch (e) {
      if (mounted) {
        final failure = ErrorHandler.handle(
          Exception('Failed to open email client: ${e.toString()}'),
          context: ErrorContext.unknown,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Theme.of(context).extension<AppColors>()!.destructive,
          ),
        );
      }
    }
  }

  Future<void> _rateApp() async {
    // TODO: Implement app store rating
    // For iOS: https://apps.apple.com/app/idYOUR_APP_ID
    // For Android: https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
    const String appStoreUrl = 'https://apps.apple.com/app/id123456789';
    // const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.yourcompany.yourapp';
    
    // You can detect platform and use appropriate URL
    await _launchURL(appStoreUrl);
  }

  void _showFeedback(BuildContext context) {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      // For now, we'll just show a confirmation message
      // Later this will be sent to Sentry when feedback_sentry is integrated
      final appColors = Theme.of(context).extension<AppColors>()!;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Thank you for your feedback! We appreciate your input.'),
            backgroundColor: appColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  String _getThemeModeDescription(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);
    return switch (adaptiveTheme.mode) {
      AdaptiveThemeMode.light => 'Light',
      AdaptiveThemeMode.dark => 'Dark',
      AdaptiveThemeMode.system => 'System',
    };
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? appColors.primary : appColors.mutedForeground,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: appColors.foreground,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}