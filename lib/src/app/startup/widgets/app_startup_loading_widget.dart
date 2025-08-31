import 'package:enmay_flutter_starter/src/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// This widget is shown while the app is loading
///
/// Can also be called as SplashScreen
class AppStartupLoadingWidget extends StatefulWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  State<AppStartupLoadingWidget> createState() => _AppStartupLoadingWidgetState();
}

class _AppStartupLoadingWidgetState extends State<AppStartupLoadingWidget> {
  String _message = 'Initializing services...';
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _startMessageTimer();
  }

  void _startMessageTimer() {
    _messageTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _message = 'Almost done...';
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const AppLogo(),
            const SizedBox(height: 24),
            Text(
              'Enmay Flutter Starter',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            
            // Loading indicator
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Simple message display
            Text(
              _message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
