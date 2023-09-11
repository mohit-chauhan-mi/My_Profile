import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constant/app_themes.dart';
import '../core/utils/secure_storage_utils.dart';
import '../presentation/edit_profile/blocs/edit_profile_bloc.dart';
import '../presentation/home/blocs/home_bloc.dart';
import '../presentation/login/blocs/login_bloc.dart';

GetIt sl = GetIt.instance;

/// Service Locator
abstract class Injector {
  static Future<void> setup() async {
    /// Configure your Modules/Services here
    await _commonServices();
    _registerBlocServices();
  }

  static Future<void> _commonServices() async {
    /// App Themes
    sl.registerLazySingleton(() => AppThemes());

    /// Shared Preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);

    /// Secure Storage
    /// for android uses Encrypted Shared Preferences
    /// for iOS uses Key Chain
    sl.registerLazySingleton(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      ),
    );

    /// Secure Storage Utils
    sl.registerLazySingleton(() => SecureStorageUtils());
  }

  static void _registerBlocServices() {
    /// Login page bloc
    sl.registerFactory(() => LoginBloc(secureStorageUtils: sl()));

    /// Home page bloc
    sl.registerFactory(() => HomeBloc(secureStorageUtils: sl()));

    /// Edit profile bloc
    sl.registerFactory(() => EditProfileBloc(secureStorageUtils: sl()));
  }
}
