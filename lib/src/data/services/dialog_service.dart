import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';

class DialogService {
  DialogService({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  BuildContext? get _context => navigatorKey.currentContext;

  Future<void> showInfoSnackbar(String message) async {
    final context = _context;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> showErrorSnackbar(String message) async {
    final context = _context;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> showActionSnackbar(
    String message, {
    required String actionLabel,
    required VoidCallback onAction,
  }) async {
    final context = _context;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: actionLabel,
          onPressed: onAction,
        ),
      ),
    );
  }

  Future<void> showInfoAlert({
    required String title,
    required String message,
  }) async {
    final context = _context;
    if (context == null) return;

    await adaptive_dialog.showOkAlertDialog(
      context: context,
      title: title,
      message: message,
    );
  }

  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String okLabel = 'OK',
    String cancelLabel = 'Cancel',
  }) async {
    final context = _context;
    if (context == null) return false;

    final result = await adaptive_dialog.showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
    );

    return result == adaptive_dialog.OkCancelResult.ok;
  }

  Future<T?> showActionSheet<T>({
    required String title,
    required List<adaptive_dialog.SheetAction<T>> actions,
    String? message,
  }) async {
    final context = _context;
    if (context == null) return null;

    return await adaptive_dialog.showModalActionSheet<T>(
      context: context,
      title: title,
      message: message,
      actions: actions,
    );
  }

  Future<String?> showTextInputDialog({
    required String title,
    String? message,
    String? hintText,
    String? initialText,
  }) async {
    final context = _context;
    if (context == null) return null;

    final result = await adaptive_dialog.showTextInputDialog(
      context: context,
      title: title,
      message: message,
      textFields: [
        adaptive_dialog.DialogTextField(
          hintText: hintText,
          initialText: initialText,
        ),
      ],
    );

    return result?.first;
  }
}