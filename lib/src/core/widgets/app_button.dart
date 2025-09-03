import 'package:enmay_flutter_starter/src/app/theme/colors.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  destructive,
  outline,
  ghost,
  link,
}

enum AppButtonSize {
  sm,
  md,
  lg,
  icon,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.isLoading = false,
    this.disabled = false,
    this.width,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool disabled;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDisabled = disabled || isLoading || onPressed == null;

    return SizedBox(
      width: width,
      child: _buildButton(context, colors, isDisabled),
    );
  }

  Widget _buildButton(BuildContext context, AppColors colors, bool isDisabled) {
    final buttonChild = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(colors),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              child,
            ],
          )
        : child;

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.primaryForeground,
            disabledBackgroundColor: colors.primary?.withValues(alpha: 0.5),
            disabledForegroundColor: colors.primaryForeground?.withValues(alpha: 0.5),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.secondaryForeground,
            disabledBackgroundColor: colors.secondary?.withValues(alpha: 0.5),
            disabledForegroundColor: colors.secondaryForeground?.withValues(alpha: 0.5),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.destructive:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.destructive,
            foregroundColor: colors.primaryForeground,
            disabledBackgroundColor: colors.destructive?.withValues(alpha: 0.5),
            disabledForegroundColor: colors.primaryForeground?.withValues(alpha: 0.5),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: colors.background,
            foregroundColor: colors.foreground,
            disabledBackgroundColor: colors.background,
            disabledForegroundColor: colors.foreground?.withValues(alpha: 0.5),
            side: BorderSide(
              color: isDisabled 
                  ? colors.border?.withValues(alpha: 0.5) ?? Colors.grey.withValues(alpha: 0.5)
                  : colors.border ?? Colors.grey,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: colors.foreground,
            disabledForegroundColor: colors.foreground?.withValues(alpha: 0.5),
            overlayColor: colors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.link:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: colors.primary,
            disabledForegroundColor: colors.primary?.withValues(alpha: 0.5),
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: _getPadding(),
            minimumSize: _getMinimumSize(),
            textStyle: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          child: buttonChild,
        );
    }
  }

  Color _getForegroundColor(AppColors colors) {
    switch (variant) {
      case AppButtonVariant.primary:
        return colors.primaryForeground ?? Colors.white;
      case AppButtonVariant.secondary:
        return colors.secondaryForeground ?? Colors.black;
      case AppButtonVariant.destructive:
        return colors.primaryForeground ?? Colors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return colors.foreground ?? Colors.black;
      case AppButtonVariant.link:
        return colors.primary ?? Colors.blue;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case AppButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.icon:
        return const EdgeInsets.all(8);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case AppButtonSize.sm:
        return const Size(0, 32);
      case AppButtonSize.md:
        return const Size(0, 40);
      case AppButtonSize.lg:
        return const Size(0, 48);
      case AppButtonSize.icon:
        return const Size(32, 32);
    }
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = AppButtonVariant.ghost,
    this.size = AppButtonSize.icon,
    this.isLoading = false,
    this.disabled = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      variant: variant,
      size: size,
      isLoading: isLoading,
      disabled: disabled,
      child: icon,
    );
  }
}