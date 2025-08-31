import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_completed.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget that manages the app startup flow
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppStartupWidget(
      onLoaded: (context) => const AppStartupCompleted(),
    );
  }
}
