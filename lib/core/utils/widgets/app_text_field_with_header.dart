import 'package:flutter/material.dart';

import '../../constant/app_extensions.dart';
import '../../constant/dimens.dart';
import 'app_text_field.dart';

class AppTextFieldWithHeader extends StatelessWidget {
  const AppTextFieldWithHeader({
    required this.headerText,
    required this.appTextField,
    this.headerStyle,
    super.key,
  });

  final String headerText;
  final TextStyle? headerStyle;
  final AppTextField appTextField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: headerStyle ?? context.theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        Dimens.d10.spaceHeight,
        appTextField,
      ],
    );
  }
}
