import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/features/auth/bloc/auth_cubit.dart';
import 'package:enmay_flutter_starter/src/features/auth/screens/login_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/screens/register_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/screens/forgot_password_screen.dart';
import 'package:enmay_flutter_starter/src/features/home/bloc/home_cubit.dart';
import 'package:enmay_flutter_starter/src/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes { home, login, register, forgotPassword, profile }

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  // Define initial route as string with leading slash
  static const initialLocation = '/home';

  static GoRouter get router => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    // refreshListenable: RouteGuard(context.read<UserRepository>().currentUserStream),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(create: (context) => AuthCubit(context.read<AuthRepository>()), child: child);
        },
        routes: [
          GoRoute(path: '/login', name: AppRoutes.login.name, builder: (context, state) => const LoginScreen()),
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
        builder:
            (context, state) => BlocProvider(
              create: (context) => HomeCubit(authRepository: context.read<AuthRepository>()),
              child: const HomeScreen(),
            ),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
