import 'package:enmay_flutter_starter/src/app/theme/theme.dart';
import 'package:enmay_flutter_starter/src/core/widgets/app_logo.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_cubit.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget is shown while the app is loading
///
/// Can also be called as SplashScreen
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Theme(
        data: darkTheme,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: BlocBuilder<AppStartupCubit, AppStartupState>(
                builder: (context, state) {
                  String message = 'Initializing...';

                  if (state.toString().contains('loading')) {
                    message = context.read<AppStartupCubit>().currentLoadingMessage;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const AppLogo(),
                      const SizedBox(height: 24),
                      Text(
                        'Enmay Flutter Starter',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      // Simple circular progress indicator
                      Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
