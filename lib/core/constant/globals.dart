import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'dimens.dart';
import 'app_extensions.dart';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

SnackBar getSnackBar({
  String? text,
  String? actionLabel,
  VoidCallback? onPressAction,
  BuildContext? context,
}) {
  /// Find the ScaffoldMessenger in the widget tree
  /// and use it to show a SnackBar.
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 2000),
    content: Text(
      text ?? '',
      style: context?.textTheme.headlineMedium?.copyWith(
        fontSize: Dimens.fontSize14,
        color: AppColors.white,
      ),
    ),
    action: (actionLabel != null)
        ? SnackBarAction(
            label: actionLabel,
            onPressed: () => onPressAction?.call(),
          )
        : null,
  );
}
