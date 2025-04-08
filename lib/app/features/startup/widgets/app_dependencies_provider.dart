import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enmay_flutter_starter/app/core/theme/theme.dart';
import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/app/features/startup/bloc/app_startup_state.dart';
import 'package:enmay_flutter_starter/app/routing/routing.dart';

class AppDependenciesProvider extends StatelessWidget {
  final LoadedState state;
  const AppDependenciesProvider({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: state.authRepository),
      ],
      child: MaterialApp.router(
        restorationScopeId: 'app',
        title: 'Enmay Flutter Starter',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
