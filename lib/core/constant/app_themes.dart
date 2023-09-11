import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_extensions.dart';
import 'dimens.dart';

class AppThemes {
  /// Right now we're using light theme only
  ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      pageTransitionsTheme: _pageTransitionsTheme,
      scaffoldBackgroundColor: AppColors.skyDelight,
      primaryColor: AppColors.azureDreams,
      typography: Typography(
        black: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.black,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: roboto.copyWith(
          fontSize: Dimens.fontSize20,
          fontWeight: FontWeight.w700,
          color: AppColors.nightfall,
          height: Dimens.textHeightSmall,
        ),
        headlineMedium: roboto.copyWith(
          fontSize: Dimens.fontSize16,
          fontWeight: FontWeight.w500,
          color: AppColors.deepHarbor,
          height: Dimens.textHeightMedium,
        ),
        titleMedium: lora.copyWith(
          fontSize: Dimens.fontSize14,
          fontWeight: FontWeight.w400,
          color: AppColors.deepHarbor,
          height: Dimens.textHeightMedium,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.deepHarbor,
      ),
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        color: AppColors.skyDelight,
        surfaceTintColor: AppColors.transparent,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.skyDelight,
        ),
        titleTextStyle: roboto.copyWith(
          fontSize: Dimens.fontSize20,
          fontWeight: FontWeight.w700,
          color: AppColors.nightfall,
          height: Dimens.textHeightSmall,
        ),
      ),
      highlightColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.transparent),
          iconColor: MaterialStateProperty.all(AppColors.nightfall),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            Dimens.d52,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.d26,
            ),
          ),
          backgroundColor: AppColors.azureDreams,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: Dimens.d14,
          horizontal: Dimens.d20,
        ),
        hintStyle: lora.copyWith(
          fontSize: Dimens.fontSize14,
          fontWeight: FontWeight.w400,
          color: AppColors.deepHarbor.withOpacity(0.8),
          height: Dimens.textHeightMedium,
        ),
        errorStyle: lora.copyWith(
          fontSize: Dimens.fontSize12,
          color: AppColors.error,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.lavenderMist,
          ),
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
        errorMaxLines: 1,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.lavenderMist,
          ),
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.sereneBlue,
          ),
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.white,
          ),
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.white,
          ),
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(AppColors.azureDreams),
        fillColor: MaterialStateProperty.all<Color>(AppColors.skyDelight),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: MaterialStateBorderSide.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return const BorderSide(color: AppColors.lavenderMist);
          } else {
            return const BorderSide(color: AppColors.lavenderMist);
          }
        }),
        overlayColor: MaterialStateProperty.all<Color>(
          AppColors.transparent,
        ),
        splashRadius: Dimens.d0,
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.d6.circularRadiusAll,
        ),
      ),
      dialogTheme: DialogTheme(
        alignment: Alignment.center,
        backgroundColor: AppColors.skyDelight,
        actionsPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.d16.circularRadiusAll,
        ),
        elevation: 0,
        titleTextStyle: roboto.copyWith(
          fontSize: Dimens.fontSize20,
          fontWeight: FontWeight.w700,
          color: AppColors.nightfall,
          height: Dimens.textHeightSmall,
        ),
        contentTextStyle: roboto.copyWith(
          fontSize: Dimens.fontSize16,
          fontWeight: FontWeight.w500,
          color: AppColors.deepHarbor,
          height: Dimens.textHeightMedium,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.twilightHaze,
        elevation: 0,
        labelStyle: lora.copyWith(
          fontSize: Dimens.fontSize14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          height: Dimens.textHeightMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.d26.circularRadiusAll,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: Dimens.d20.circularRadiusAll,
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    /// Right now we're using light theme only need to change this to add dark theme support
    return lightTheme;
  }

  /// Common page transition
  final PageTransitionsTheme _pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  /// Fonts used in the app
  TextStyle roboto = GoogleFonts.roboto();
  TextStyle lora = GoogleFonts.lora();
}
