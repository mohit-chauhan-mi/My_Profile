import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/app_extensions.dart';
import '../../constant/dimens.dart';

/// [AppTextField] is used to add common text field in our app
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChange;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final bool? isEnabled;
  final bool readOnly;
  final String? obscuringCharacter;
  final VoidCallback? suffixIconOnTap;
  final VoidCallback? onTapOutside;
  final ValueChanged<String>? onFieldSubmitted;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final int? maxLines;
  final Widget? prefixIcon;
  final String? prefixIconPath;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final String? suffixIconPath;
  final BoxConstraints? suffixIconConstraints;
  final VoidCallback? suffixIconPathTap;
  final FormFieldValidator<String>? validator;

  const AppTextField({
    Key? key,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.isEnabled,
    this.readOnly = false,
    this.hintText,
    this.suffixIconOnTap,
    this.onTapOutside,
    this.textCapitalization,
    this.obscuringCharacter,
    this.onChange,
    this.inputFormatters,
    this.focusNode,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.maxLines,
    this.prefixIcon,
    this.prefixIconPath,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.suffixIconPath,
    this.suffixIconConstraints,
    this.suffixIconPathTap,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      obscuringCharacter: obscuringCharacter ?? '•',
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      obscureText: obscureText ?? false,
      enabled: isEnabled,
      readOnly: readOnly,
      style: textStyle ?? context.theme.textTheme.titleMedium,
      onChanged: onChange,
      textAlign: textAlign,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder:
            readOnly ? context.theme.inputDecorationTheme.enabledBorder : null,
        prefixIcon: prefixIcon ??
            ((prefixIconPath?.isNotEmpty ?? false)
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: Dimens.d20,
                      right: Dimens.d16,
                    ),
                    child: SvgPicture.asset(
                      prefixIconPath!,
                      height: Dimens.d18,
                      width: Dimens.d18,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : null),
        prefixIconConstraints: prefixIconConstraints ??
            ((prefixIcon == null && (prefixIconPath?.isNotEmpty ?? false))
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null),
        suffixIcon: suffixIcon ??
            ((suffixIconPath?.isNotEmpty ?? false)
                ? InkWell(
                    onTap: suffixIconPathTap,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Dimens.d16,
                        right: Dimens.d20,
                      ),
                      child: SvgPicture.asset(
                        suffixIconPath!,
                        height: Dimens.d18,
                        width: Dimens.d18,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
                : null),
        suffixIconConstraints: suffixIconConstraints ??
            ((suffixIcon == null && (suffixIconPath?.isNotEmpty ?? false))
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null),
      ),
      onTapOutside: (_) {
        if (onTapOutside != null) {
          onTapOutside?.call();
        } else {
          context.hideKeyboard();
        }
      },
    );
  }
}
