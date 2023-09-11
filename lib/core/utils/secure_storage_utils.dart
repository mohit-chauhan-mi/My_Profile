import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/model/user_data.dart';
import '../../injector/injector.dart';
import '../constant/app_extensions.dart';
import '../constant/app_strings.dart';

class SecureStorageUtils {
  /// SecureStorage Instance
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  /// Local user data object
  UserData? userData;

  /// Storing the new data and updating the local object
  Future<void> storeUserData() async {
    try {
      Map<String, dynamic> data = userData?.toJson() ?? {};
      if (data.isNotEmpty) {
        await secureStorage.write(
          key: AppStrings.keyUserData,
          value: json.encode(data),
        );
        await fetchUserData();
      } else {
        dev.log('error : storeUserData');
      }
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
    }
  }

  /// Fetching the new data and updating the local object
  Future<void> fetchUserData() async {
    try {
      String? response = await secureStorage.read(key: AppStrings.keyUserData);
      if (response.isNotNullOrBlank) {
        UserData? user = UserData.fromJson(json.decode(response ?? ''));
        userData = user;
      } else {
        dev.log('error : fetchUserData');
      }
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
    }
  }

  /// Removing local user
  Future<void> removeLocalUser() async {
    try {
      userData = null;
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
    }
  }
}
