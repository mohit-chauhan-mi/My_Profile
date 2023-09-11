import 'package:flutter/material.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/dimens.dart';
import 'svg_icon_button.dart';

class SkillsSetChips extends StatelessWidget {
  const SkillsSetChips({
    super.key,
    required this.skillsList,
    this.isEditIconBtn,
    this.editIconAssetPath,
    this.onEditPressed,
    this.isDeleteIcon,
    this.onDeletePressed,
  });

  final List<String> skillsList;
  final bool? isEditIconBtn;
  final String? editIconAssetPath;
  final VoidCallback? onEditPressed;
  final bool? isDeleteIcon;
  final ValueChanged<int>? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimens.d6,
      runSpacing: Dimens.d6,
      children: [
        ...skillsList
            .asMap()
            .map(
              (index, skill) => MapEntry(
                index,
                RawChip(
                  label: Text(skill),
                  deleteIcon: (isDeleteIcon ?? false)
                      ? const Icon(
                          Icons.close,
                          size: Dimens.d16,
                          color: AppColors.white,
                        )
                      : null,
                  onDeleted: (isDeleteIcon ?? false)
                      ? () {
                          onDeletePressed?.call(index);
                        }
                      : null,
                ),
              ),
            )
            .values
            .toList(),
        if (isEditIconBtn ?? false)
          RawChip(
            color: const MaterialStatePropertyAll(AppColors.white),
            onPressed: onEditPressed,
            label: SvgIconButton(
              iconAssetsPath: editIconAssetPath ?? AppAssets.icEdit,
              onIconPressed: onEditPressed,
              padding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}
