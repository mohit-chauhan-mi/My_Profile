import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_extensions.dart';
import '../../../core/constant/app_strings.dart';
import '../../../core/constant/dimens.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../injector/injector.dart';
import '../../home/pages/home_page.dart';
import '../../login/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Local data storage
  SharedPreferences sharedPreferences = sl<SharedPreferences>();
  SecureStorageUtils secureStorageUtils = sl<SecureStorageUtils>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Platform.isIOS) _clearKeychainValues();
      _checkOnLocalUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid ? PreferredSize(
        preferredSize: const Size(0, 0),
        child: AppBar(
        ),
      ) : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.imgAppIcon,
              width: Dimens.d120,
              height: Dimens.d120,
            ),
            Text(
              AppStrings.myProfile,
              style: context.textTheme.headlineLarge?.copyWith(
                fontSize: Dimens.fontSize24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearKeychainValues() async {
    /// Doing this because in iOS FlutterSecureStorage stores data in the Keychain.
    /// The Keychain is a system level service. Therefore even if an app is deleted from the phone,
    /// the values that app saved in the Keychain do not get removed.
    if (sharedPreferences.getBool(AppStrings.keyIsInitialAppLaunch) ?? true) {
      await secureStorageUtils.secureStorage.deleteAll();
      await secureStorageUtils.removeLocalUser();
      await sharedPreferences.setBool(AppStrings.keyIsInitialAppLaunch, false);
    }
  }

  Future<void> _checkOnLocalUser() async {
    await secureStorageUtils.fetchUserData();

    /// Taking the navigation flow decision based on the local data
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ((secureStorageUtils.userData?.email?.isNotEmpty ?? false) &&
                (secureStorageUtils.userData?.isLoggedIn ?? false))
            ? HomePage.route
            : LoginPage.route,
        (route) => false,
      );
    });
  }
}
