import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppStartupCompleted extends ConsumerWidget {
  const AppStartupCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp.router(
        routerConfig: goRouter,
        restorationScopeId: 'app',
        title: 'Enmay Flutter Starter',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
