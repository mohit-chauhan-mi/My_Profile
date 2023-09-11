import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_extensions.dart';
import '../../constant/dimens.dart';

/// [AppLoadingButton] is used to show loading button when api is call
class AppLoadingButton extends StatelessWidget {
  final Color? color;

  const AppLoadingButton({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: context.theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(
            color?.withOpacity(0.50) ??
                AppColors.azureDreams.withOpacity(0.50)),
      ),
      onPressed: () {},
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: Dimens.d40,
          height: Dimens.d20,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: [color ?? AppColors.white],
          ),
        ),
      ),
    );
  }
}
