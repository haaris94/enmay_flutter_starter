import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartupCompleted extends ConsumerWidget {
  const AppStartupCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      restorationScopeId: 'app',
      title: 'Enmay Flutter Starter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
