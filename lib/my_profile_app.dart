import 'package:flutter/material.dart';

import 'core/constant/app_strings.dart';
import 'core/constant/app_themes.dart';
import 'core/constant/globals.dart';
import 'core/utils/navigation_helper.dart';
import 'injector/injector.dart';

class MyProfileApp extends StatelessWidget {
  const MyProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Here we're setting navigation routes, themes, and
    /// other things of the app
    return MaterialApp(
      title: AppStrings.myProfile,
      debugShowCheckedModeBanner: false,
      theme: sl<AppThemes>().lightTheme,
      darkTheme: sl<AppThemes>().darkTheme,
      themeMode: ThemeMode.light,
      navigatorKey: appNavigatorKey,
      scaffoldMessengerKey: appScaffoldMessengerKey,
      initialRoute: NavigationHelper.initialAppRoute,
      onGenerateRoute: NavigationHelper.myProfileAppRoutes,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => UndefinedPage(
          name: settings.name ?? AppStrings.undefinedPage,
        ),
      ),
    );
  }
}
