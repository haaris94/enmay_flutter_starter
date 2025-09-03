import 'package:enmay_flutter_starter/src/core/logging/console_logger.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
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
          IconButton(
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
            ElevatedButton(
              onPressed: () {
                logger.debug('Debug message from home screen');
              },
              child: const Text('Test Debug Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.info('Info message from home screen');
              },
              child: const Text('Test Info Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.warning('Warning message from home screen');
              },
              child: const Text('Test Warning Log'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                logger.error('Error message from home screen');
              },
              child: const Text('Test Error Log'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoutes.paywall.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Test Paywall'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                logger.info('User logging out');
                ref.read(authRepositoryProvider).signOut();
                context.pushReplacementNamed(AppRoutes.login.name);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
