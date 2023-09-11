import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/dimens.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    super.key,
    required this.iconAssetsPath,
    this.onIconPressed,
    this.padding,
  });

  final String iconAssetsPath;
  final VoidCallback? onIconPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onIconPressed,
      child: Padding(
        padding: padding ??
            const EdgeInsets.only(
              left: Dimens.d6,
            ),
        child: SvgPicture.asset(
          iconAssetsPath,
          height: Dimens.d18,
          width: Dimens.d18,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
