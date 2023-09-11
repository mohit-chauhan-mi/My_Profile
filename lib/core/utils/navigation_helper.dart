import 'package:flutter/material.dart';

import '../../presentation/edit_profile/pages/edit_profile_page.dart';
import '../../presentation/edit_profile/pages/work_experience_page.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/login/pages/login_page.dart';
import '../../presentation/splash/pages/splash_page.dart';
import '../constant/app_strings.dart';
import '../constant/dimens.dart';

abstract class NavigationHelper {
  /// Initial Route of the App
  static String initialAppRoute = SplashPage.route;

  /// All the Routes of the My Profile App
  static Route<dynamic> myProfileAppRoutes(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.route:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );

      case LoginPage.route:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );

      case HomePage.route:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      case EditProfilePage.route:
        // Data passing
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => EditProfilePage(
            editProfileType: arguments[AppStrings.keyEditProfileType],
          ),
        );

      case WorkExperiencePage.route:
        // Data passing
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => WorkExperiencePage(
            isUpdateWorkExperience:
                arguments[AppStrings.keyIsUpdateWorkExperience],
            workExperienceIndex: arguments[AppStrings.keyWorkExperienceIndex],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => UndefinedPage(
            name: settings.name ?? AppStrings.undefinedPage,
          ),
        );
    }
  }
}

class UndefinedPage extends StatelessWidget {
  final String name;

  const UndefinedPage({
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.d24),
          child: Text(
            '$name ${AppStrings.routeNotDefined}',
          ),
        ),
      ),
    );
  }
}
