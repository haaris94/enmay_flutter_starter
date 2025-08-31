import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_state.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDependenciesProvider extends ConsumerWidget {
  final LoadedState state;
  const AppDependenciesProvider({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      restorationScopeId: 'app',
      title: 'Enmay Flutter Starter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
