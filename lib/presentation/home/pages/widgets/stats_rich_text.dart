import 'package:flutter/material.dart';

import '../../../../core/constant/app_extensions.dart';
import '../../../../core/constant/dimens.dart';

class StatsRichText extends StatelessWidget {
  const StatsRichText({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: context.textTheme.titleMedium?.copyWith(
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          TextSpan(
            text: ': ',
            style: context.textTheme.titleMedium?.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextSpan(
            text: value,
            style: context.textTheme.headlineMedium?.copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: Dimens.fontSize14,
            ),
          ),
        ],
      ),
    );
  }
}
