import 'package:enmay_flutter_starter/src/core/exceptions/legacy/app_exception.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_cubit.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_state.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_dependencies_provider.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_error_widget.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root widget that manages the app startup flow
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AppStartupCubit()..initializeServices(), child: const _AppStartupStateHandler());
  }
}

class _AppStartupStateHandler extends StatelessWidget {
  const _AppStartupStateHandler();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStartupCubit, AppStartupState>(
      builder: (context, state) {
        // Handle different states without using 'is' checks
        // since the classes are private in the generated code

        // Initial or Loading state
        if (state.toString().contains('initial') || state.toString().contains('loading')) {
          return const AppStartupLoadingWidget();
        }
        // Loaded state
        else if (state.toString().contains('loaded')) {
          // Extract the state by downcasting
          final loadedState = (state as dynamic).state as LoadedState;
          return AppDependenciesProvider(state: loadedState);
        }
        // Error state
        else if (state.toString().contains('error')) {
          // Extract the exception by downcasting
          final appException = (state as dynamic).appException as AppException;
          return AppStartupErrorWidget(
            appException: appException,
            onRetry: () => context.read<AppStartupCubit>().initializeServices(),
          );
        }
        // Fallback
        else {
          return const AppStartupLoadingWidget();
        }
      },
    );
  }
}
