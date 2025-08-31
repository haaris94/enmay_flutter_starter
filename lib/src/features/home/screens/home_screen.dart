import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            context.read<AuthRepository>().logout();
            context.pushReplacement(AppRoutes.login.name);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
