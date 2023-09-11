import 'package:flutter/material.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_extensions.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/constant/dimens.dart';
import '../../../../data/model/work_experience.dart';
import 'stats_rich_text.dart';
import 'svg_icon_button.dart';

class WorkExperienceListItem extends StatelessWidget {
  const WorkExperienceListItem({
    super.key,
    required this.workExperience,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final WorkExperience workExperience;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Dimens.d20.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsRichText(
              title: AppStrings.companyName,
              value: workExperience.companyName ?? '',
            ),
            Padding(
              padding: Dimens.d4.paddingVertical,
              child: StatsRichText(
                title: AppStrings.designation,
                value: workExperience.designation ?? '',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: StatsRichText(
                    title: AppStrings.experience,
                    value: workExperience.experience?.getYear ?? '',
                  ),
                ),
                SvgIconButton(
                  iconAssetsPath: AppAssets.icEdit,
                  onIconPressed: onEditPressed,
                ),
                Dimens.d4.spaceWidth,
                SvgIconButton(
                  iconAssetsPath: AppAssets.icDelete,
                  onIconPressed: onDeletePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
