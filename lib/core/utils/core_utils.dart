import 'package:course_rep_management_panel/core/services/router.dart';
import 'package:course_rep_management_panel/core/utils/enums/log_level.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

sealed class CoreUtils {
  static Future<void> showSnackBar({
    required String message,
    String? title,
    LogLevel logLevel = LogLevel.info,
  }) async {
    final toast = DecoratedBox(
      decoration: BoxDecoration(
        color: logLevel.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const Gap(8),
            ],
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );

    if (rootNavigatorKey.currentContext == null) {
      await Future<void>.delayed(const Duration(seconds: 2));
      return showSnackBar(message: message, title: title, logLevel: logLevel);
    }

    rootNavigatorKey.currentContext!.read<FToast>()
      ..removeCustomToast()
      ..showToast(
        child: toast,
        toastDuration: const Duration(seconds: 5),
        gravity: ToastGravity.TOP_RIGHT,
      );
  }

  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (result ?? false) onConfirm();
  }

  static Future<void> showCustomDialog(
    BuildContext context, {
    required Widget dialog,
  }) async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => dialog,
    );
  }
}
