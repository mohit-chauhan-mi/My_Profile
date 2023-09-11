import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_extensions.dart';

/// [AppConfirmDialog] is used to show confirm or alert dialog
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String positiveText;
  final String? negativeText;
  final VoidCallback? onPositiveTap;
  final VoidCallback? onNegativeTap;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.positiveText,
    this.negativeText,
    this.onPositiveTap,
    this.onNegativeTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: Text(
        subtitle,
      ),
      actions: [
        if (negativeText != null)
          TextButton(
            onPressed: onNegativeTap,
            child: Text(
              negativeText!,
              style: context.textTheme.headlineMedium?.copyWith(
                color: AppColors.nightfall,
              ),
            ),
          ),
        TextButton(
          onPressed: onPositiveTap,
          child: Text(
            positiveText,
            style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.nightfall,
            ),
          ),
        ),
      ],
    );
  }
}
