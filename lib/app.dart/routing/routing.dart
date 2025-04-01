import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Routes { home, login, register, profile }

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();
  static const _initialRoute = Routes.home;

  static GoRouter get router => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: _initialRoute.name,
    // refreshListenable: RouteGuard(context.read<UserRepository>().currentUserStream),
    routes: [
      //   GoRoute(
      //     path: '/login',
      //     name: Routes.login.name,
      //     builder: (context, state) {
      //       return BlocProvider(
      //         create: (context) => AuthCubit(context.read<AuthRepository>()),
      //         child: const LoginScreen(),
      //       );
      //     },
      //   ),
    ],
  );
}
