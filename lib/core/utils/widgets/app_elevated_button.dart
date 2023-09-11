import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_extensions.dart';

/// [AppElevatedButton] is used to add common button in our app
class AppElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;

  const AppElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle ??
          (onPressed != null
              ? context.theme.elevatedButtonTheme.style
              : context.theme.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    context.theme.primaryColor.withOpacity(0.5),
                  ),
                )),
      child: Text(
        text,
        style: context.theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
