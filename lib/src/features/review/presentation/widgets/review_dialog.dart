import 'package:enmay_flutter_starter/src/core/widgets/app_button.dart';
import 'package:enmay_flutter_starter/src/features/review/services/review_service.dart';
import 'package:flutter/material.dart';

class ReviewDialog extends StatelessWidget {
  const ReviewDialog({
    super.key,
    this.appName,
    this.title,
    this.message,
    this.rateButtonText = 'Yes, Rate Now',
    this.laterButtonText = 'Later',
    this.dontAskButtonText = "Don't Ask Again",
    this.onAction,
  });

  final String? appName;
  final String? title;
  final String? message;
  final String rateButtonText;
  final String laterButtonText;
  final String dontAskButtonText;
  final Function(ReviewAction action)? onAction;

  /// Show the review dialog
  static Future<ReviewAction?> show(
    BuildContext context, {
    String? appName,
    String? title,
    String? message,
    String rateButtonText = 'Yes, Rate Now',
    String laterButtonText = 'Later',
    String dontAskButtonText = "Don't Ask Again",
  }) async {
    return await showDialog<ReviewAction>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => ReviewDialog(
        appName: appName,
        title: title,
        message: message,
        rateButtonText: rateButtonText,
        laterButtonText: laterButtonText,
        dontAskButtonText: dontAskButtonText,
        onAction: (action) => Navigator.of(context).pop(action),
      ),
    );
  }

  String get _defaultAppName => appName ?? 'this app';
  
  String get _defaultTitle => title ?? 'Enjoying $_defaultAppName?';
  
  String get _defaultMessage => 
      message ?? 'Your feedback helps us improve. Would you mind taking a moment to rate us?';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          // App icon or rating icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.star_rounded,
              size: 32,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _defaultTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _defaultMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Rating stars (visual only)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                Icons.star_rounded,
                size: 24,
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            )),
          ),
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary action - Rate Now
            AppButton(
              onPressed: () => onAction?.call(ReviewAction.rateNow),
              child: Text(rateButtonText),
            ),
            const SizedBox(height: 8),
            
            // Secondary actions row
            Row(
              children: [
                // Later button
                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.outline,
                    onPressed: () => onAction?.call(ReviewAction.later),
                    child: Text(laterButtonText),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Don't ask again button
                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.ghost,
                    onPressed: () => onAction?.call(ReviewAction.dontAskAgain),
                    child: Text(
                      dontAskButtonText,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    );
  }
}

/// Helper widget to conditionally show review dialog
class ConditionalReviewDialog extends StatefulWidget {
  const ConditionalReviewDialog({
    super.key,
    required this.child,
    this.reviewService,
    this.appName,
    this.customTitle,
    this.customMessage,
  });

  final Widget child;
  final ReviewService? reviewService;
  final String? appName;
  final String? customTitle;
  final String? customMessage;

  @override
  State<ConditionalReviewDialog> createState() => _ConditionalReviewDialogState();
}

class _ConditionalReviewDialogState extends State<ConditionalReviewDialog>
    with WidgetsBindingObserver {
  bool _hasCheckedForReview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForReviewRequest();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check for review when app becomes active (returns from background)
    if (state == AppLifecycleState.resumed && !_hasCheckedForReview) {
      _checkForReviewRequest();
    }
  }

  Future<void> _checkForReviewRequest() async {
    if (_hasCheckedForReview || widget.reviewService == null) return;
    
    _hasCheckedForReview = true;
    
    try {
      final shouldRequest = await widget.reviewService!.shouldRequestReview();
      
      if (shouldRequest && mounted) {
        await _showReviewDialog();
      }
    } catch (e) {
      // Silently fail - review system should never break the app
    }
  }

  Future<void> _showReviewDialog() async {
    final action = await ReviewDialog.show(
      context,
      appName: widget.appName,
      title: widget.customTitle,
      message: widget.customMessage,
    );

    if (action != null && widget.reviewService != null) {
      await widget.reviewService!.handleReviewAction(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}