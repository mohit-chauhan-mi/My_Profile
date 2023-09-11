import 'package:flutter/material.dart';

import '../../../../core/constant/app_extensions.dart';
import 'svg_icon_button.dart';

class HeaderWithIconButton extends StatelessWidget {
  const HeaderWithIconButton({
    super.key,
    required this.title,
    required this.iconAssetsPath,
    required this.onIconPressed,
  });

  final String title;
  final String iconAssetsPath;
  final VoidCallback onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        SvgIconButton(
          onIconPressed: onIconPressed,
          iconAssetsPath: iconAssetsPath,
        ),
      ],
    );
  }
}
