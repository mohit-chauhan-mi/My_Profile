import 'package:flutter/material.dart';

import '../utils/regexps.dart';
import 'globals.dart';

extension ContextExtension on BuildContext {
  /// Used to get the theme using context
  ThemeData get theme => Theme.of(this);

  /// Used to get the text theme using context
  TextTheme get textTheme => theme.textTheme;

  /// Used to hide the keyboard
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Used to show snack bar
  void showSnackBar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(getSnackBar(
      text: text,
      actionLabel: actionLabel,
      onPressAction: onPressAction,
      context: this,
    ));
  }
}

extension SizedBoxExtension on double {
  /// Used to add SizedBox vertically using height
  Widget get spaceHeight => SizedBox(height: this);

  /// Used to add SizedBox horizontally using width
  Widget get spaceWidth => SizedBox(width: this);
}

extension PaddingExtension on double {
  /// Used to add All EdgeInsets Padding
  EdgeInsets get paddingAll => EdgeInsets.all(this);

  /// Used to add Horizontal EdgeInsets Padding
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);

  /// Used to add Vertical EdgeInsets Padding
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: this);
}

extension BorderRadiusExtension on double {
  /// Used to add Circular BorderRadius
  BorderRadius get circularRadiusAll => BorderRadius.circular(this);
}

/// Utils extensions on String
extension StringExtension on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;

  bool get isNotBlank => !isBlank;

  bool get isNullOrBlank => this == null || isBlank;

  bool get isNotNullOrBlank => !isNullOrBlank;

  bool get isValidEmail => RegExps.email.hasMatch(this ?? '');

  bool get isValidName => RegExps.nameNumberAndWhiteSpaceOnly.hasMatch(this ?? '');
}

extension DoubleUtils on double {
  String get getYear {
    return (this <= 1.0) ? '$this Year' : '$this Years';
  }
}

extension ListUtils on (List<dynamic>, List<dynamic>) {
  bool isIdenticalList() {
    /// first check if the lengths of the lists are different
    if (this.$1.length != this.$2.length) {
      return true;
    }

    /// if length not matches then compare elements in both lists
    for (int i = 0; i < this.$1.length; i++) {
      if (this.$1[i] != this.$2[i]) {
        return true;
      }
    }

    /// else the lists are identical
    return false;
  }
}
