import 'package:enmay_flutter_starter/src/core/exceptions/app_exception.dart';
import 'package:enmay_flutter_starter/src/app/theme/theme.dart';
import 'package:flutter/material.dart';

/// This widget is shown if there is an error while the app is loading
///
/// The user has an option to retry.
class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({super.key, required this.appException, required this.onRetry});
  final AppException appException;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Theme(
        data: darkTheme,
        child: Scaffold(
          appBar: AppBar(title: const Text('Error'), centerTitle: true),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 56.0),
                  const SizedBox(height: 16.0),
                  Text('Startup Error', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
                  const SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    alignment: Alignment.center,
                    child: Text(
                      appException.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                  if (appException.code.isNotEmpty) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      'Error code: ${appException.code}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 32.0),
                  ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
