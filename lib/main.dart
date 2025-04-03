import 'package:enmay_flutter_starter/app/core/theme/theme.dart';
import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/app/features/auth/bloc/auth_cubit.dart';
import 'package:enmay_flutter_starter/app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepository();

  runApp(
    RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(create: (context) => AuthCubit(authRepository), child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enmay Flutter Starter',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
