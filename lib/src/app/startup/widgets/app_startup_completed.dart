import 'package:enmay_flutter_starter/src/app/theme/app_theme.dart';
import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:enmay_flutter_starter/src/app/routing/routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:feedback/feedback.dart';

class AppStartupCompleted extends ConsumerWidget {
  const AppStartupCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return BetterFeedback(
      theme: FeedbackThemeData(
        background: Colors.black.withValues(alpha: 0.5),
        feedbackSheetColor: lightAppColors.background ?? const Color(0xFFF6F2EF),
        drawColors: [
          lightAppColors.destructive ?? const Color(0xFFDC2626),
          lightAppColors.primary ?? const Color(0xFF90A966),
          const Color(0xFF4CAF50), // Green
          const Color(0xFFFFC107), // Amber
          const Color(0xFF9C27B0), // Purple
        ],
      ),
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp.router(
          routerConfig: goRouter,
          restorationScopeId: 'app',
          title: 'Enmay Flutter Starter',
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
