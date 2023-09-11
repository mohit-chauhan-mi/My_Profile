import 'package:flutter/material.dart';

import '../../../../core/constant/app_extensions.dart';

class CheckBoxItem extends StatelessWidget {
  const CheckBoxItem({
    super.key,
    this.onItemTap,
    this.checkValue,
    this.onCheckChanged,
    this.itemTitle,
  });

  final GestureTapCallback? onItemTap;
  final bool? checkValue;
  final ValueChanged<bool?>? onCheckChanged;
  final String? itemTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: checkValue,
            onChanged: onCheckChanged,
          ),
          if (itemTitle.isNotNullOrBlank)
            Text(
              itemTitle ?? '',
              style: context.theme.textTheme.titleMedium,
            )
        ],
      ),
    );
  }
}
