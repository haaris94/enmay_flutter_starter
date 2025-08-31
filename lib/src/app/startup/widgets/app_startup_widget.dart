import 'package:enmay_flutter_starter/src/app/startup/provider/app_startup_provider.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_error_widget.dart';
import 'package:enmay_flutter_starter/src/app/startup/widgets/app_startup_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({
    super.key,
    required this.onLoaded,
  });

  final Widget Function(BuildContext) onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(appStartupProvider);

    return startupState.when(
      loading: () => const AppStartupLoadingWidget(),
      error: (error, stackTrace) => AppStartupErrorWidget(
        error: error,
        onRetry: () => ref.read(appStartupProvider.notifier).retry(),
      ),
      data: (_) => onLoaded(context),
    );
  }
}