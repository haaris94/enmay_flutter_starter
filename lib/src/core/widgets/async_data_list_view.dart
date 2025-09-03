import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../exceptions/failure.dart';

class AsyncDataListView<T> extends StatelessWidget {
  const AsyncDataListView({
    super.key,
    required this.asyncValue,
    required this.itemBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.shimmerItemCount = 6,
    this.shimmerItemHeight = 72.0,
    this.onRefresh,
    this.scrollController,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.primary,
  });

  final AsyncValue<List<T>> asyncValue;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, Failure failure)? errorWidget;
  final Widget? emptyWidget;
  final int shimmerItemCount;
  final double shimmerItemHeight;
  final Future<void> Function()? onRefresh;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final bool? primary;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) => _buildDataView(context, data),
      loading: () => _buildLoadingView(context),
      error: (error, _) => _buildErrorView(context, error),
    );
  }

  Widget _buildDataView(BuildContext context, List<T> data) {
    if (data.isEmpty) {
      return _buildEmptyView(context);
    }

    final listView = ListView.builder(
      controller: scrollController,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: padding,
      shrinkWrap: shrinkWrap,
      primary: primary,
      itemCount: data.length,
      itemBuilder: (context, index) => itemBuilder(context, data[index], index),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildLoadingView(BuildContext context) {
    if (loadingWidget != null) {
      return loadingWidget!;
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: shimmerItemCount,
      itemBuilder: (context, index) => _buildShimmerItem(context),
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      highlightColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      child: Container(
        height: shimmerItemHeight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, Object error) {
    final failure = error is Failure ? error : Failure(
      title: 'Unknown Error',
      message: error.toString(),
      type: ErrorType.unknown,
    );

    if (errorWidget != null) {
      return errorWidget!(context, failure);
    }

    return _buildDefaultErrorWidget(context, failure);
  }

  Widget _buildDefaultErrorWidget(BuildContext context, Failure failure) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(failure.type),
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              failure.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    if (emptyWidget != null) {
      return emptyWidget!;
    }

    return _buildDefaultEmptyWidget(context);
  }

  Widget _buildDefaultEmptyWidget(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no items to display at the moment.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.authentication:
        return Icons.lock_outline;
      case ErrorType.validation:
        return Icons.warning_amber;
      case ErrorType.storage:
        return Icons.storage;
      case ErrorType.externalApi:
        return Icons.api;
      case ErrorType.emailNotVerified:
        return Icons.mark_email_unread_outlined;
      case ErrorType.userDisabled:
        return Icons.person_off_outlined;
      case ErrorType.tooManyRequests:
        return Icons.speed;
      case ErrorType.providerAlreadyLinked:
        return Icons.link_off;
      case ErrorType.weakPassword:
        return Icons.security;
      case ErrorType.operationNotAllowed:
        return Icons.block;
      case ErrorType.unknown:
        return Icons.error_outline;
    }
  }
}