import 'package:enmay_flutter_starter/src/core/logging/console_logger.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(consoleLoggerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          AppIconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed(AppRoutes.settings.name);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              onPressed: () {
                logger.debug('Debug message from home screen');
              },
              variant: AppButtonVariant.secondary,
              child: const Text('Test Debug Log'),
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () {
                logger.info('Info message from home screen');
              },
              variant: AppButtonVariant.secondary,
              child: const Text('Test Info Log'),
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () {
                logger.warning('Warning message from home screen');
              },
              variant: AppButtonVariant.secondary,
              child: const Text('Test Warning Log'),
            ),
            const SizedBox(height: 10),
            AppButton(
              onPressed: () {
                logger.error('Error message from home screen');
              },
              variant: AppButtonVariant.secondary,
              child: const Text('Test Error Log'),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () {
                context.pushNamed(AppRoutes.paywall.name);
              },
              variant: AppButtonVariant.primary,
              child: const Text('Test Paywall'),
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () {
                logger.info('User logging out');
                ref.read(authRepositoryProvider).signOut();
                context.pushReplacementNamed(AppRoutes.login.name);
              },
              variant: AppButtonVariant.link,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
