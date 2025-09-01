import 'package:enmay_flutter_starter/src/app/routing/route_guard.dart';
import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/login_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/register_screen.dart';
import 'package:enmay_flutter_starter/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:enmay_flutter_starter/src/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing.g.dart';

enum AppRoutes { home, login, register, forgotPassword, profile }

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

const String _initialLocation = '/home';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final routeGuard = RouteGuard(ref);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _initialLocation,
    refreshListenable: routeGuard,
    redirect: (context, state) {
      final isAuthenticated = routeGuard.isAuthenticated;
      final isEmailVerified = routeGuard.isEmailVerified;
      final currentScreen = state.uri.toString();
      
      final publicRoutes = ['/login', '/register', '/forgot-password'];
      final isPublicRoute = publicRoutes.contains(currentScreen);
      
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }
      
      // If user is authenticated but email not verified and trying to access protected routes
      if (isAuthenticated && !isEmailVerified && !isPublicRoute) {
        // You can redirect to an email verification screen here if you have one
        // For now, we'll allow access but you might want to handle this differently
      }
      
      if (isAuthenticated && isPublicRoute) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Public routes
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
      // Protected routes
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
