import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/login_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/register_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:enmay_flutter_starter/src/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing.g.dart';

enum AppRoutes { home, login, register, forgotPassword, profile }

GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

String _initialLocation = '/home';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _initialLocation,
    // refreshListenable: RouteGuard(ref.read(authRepositoryProvider).currentUserStream),
    routes: [
      ShellRoute(
        routes: [
          GoRoute(
            path: '/login', 
            name: AppRoutes.login.name, 
            builder: (context, state) => const LoginScreen()
          ),
          GoRoute(
            path: '/register',
            name: AppRoutes.register.name,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: '/forgot-password',
            name: AppRoutes.forgotPassword.name,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
