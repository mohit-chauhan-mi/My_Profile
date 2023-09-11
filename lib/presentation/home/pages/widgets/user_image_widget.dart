import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_extensions.dart';
import '../../../../core/constant/dimens.dart';
import '../../../../data/model/picked_image.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    super.key,
    required this.userImage,
  });

  final PickedImage? userImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Container(
        key: ValueKey(userImage?.imageName ?? ''),
        width: Dimens.d120,
        height: Dimens.d120,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.skyDelight,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.deepHarbor,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: (userImage?.base64ImageBytes.isNotEmpty ?? false)
            ? Image.memory(
                base64Decode(userImage!.base64ImageBytes),
                fit: BoxFit.cover,
              )
            : Padding(
                padding: Dimens.d30.paddingAll,
                child: SvgPicture.asset(
                  AppAssets.icUser,
                ),
              ),
      ),
    );
  }
}
