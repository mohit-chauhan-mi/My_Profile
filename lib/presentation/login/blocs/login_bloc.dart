import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_strings.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../data/model/user_data.dart';
import '../../../data/model/work_experience.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  SecureStorageUtils secureStorageUtils;

  LoginBloc({
    required this.secureStorageUtils,
  }) : super(LoginInitial()) {
    on<LoginPasswordHideShowEvent>(_loginPasswordHideShowEvent);
    on<LoginRememberedMeEvent>(_loginRememberedMeEvent);
    on<LoginFieldsValidEvent>(_loginFieldsValidEvent);
    on<LoginRequestEvent>(_loginRequestEvent);
    on<LoginGetUserDataEvent>(_loginGetUserDataEvent);
  }

  FutureOr<void> _loginPasswordHideShowEvent(
    LoginPasswordHideShowEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginHideShowPasswordState(
      isPasswordVisible: !event.isPasswordVisible,
    ));
  }

  FutureOr<void> _loginRememberedMeEvent(
    LoginRememberedMeEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginRememberedMeState(
      isRememberedMe: !event.isRememberedMe,
    ));
  }

  FutureOr<void> _loginFieldsValidEvent(
    LoginFieldsValidEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginFieldsValidState(
      isValidUserName: event.isValidUserName,
      isValidPassword: event.isValidPassword,
    ));
  }

  FutureOr<void> _loginRequestEvent(
    LoginRequestEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    /// To show the loading button in UI
    await Future.delayed(const Duration(seconds: 1));

    /// Validating the data with the default values
    /// if valid then executing the request
    if (event.username != AppStrings.defaultEmail) {
      emit(LoginFailureState(message: AppStrings.userNotFound));
    } else if (event.password != AppStrings.defaultName.toLowerCase()) {
      emit(LoginFailureState(message: AppStrings.invalidPassword));
    } else {
      /// Setting up the user details and storing it
      /// if its isRememberedMe then not resetting the data here
      if (!(secureStorageUtils.userData?.isRememberedMe ?? false)) {
        UserData userData = UserData(
          email: AppStrings.defaultEmail,
          password: AppStrings.defaultName.toLowerCase(),
          name: AppStrings.defaultName,
          skills: [
            AppStrings.defaultSkillFlutter,
            AppStrings.defaultSkillIos,
          ],
          workExperiences: [
            WorkExperience(
              companyName: AppStrings.defaultCompanyName,
              designation: AppStrings.defaultDesignation,
              experience: 5.0,
            ),
          ],
          isRememberedMe: event.isRememberedMe,
          isLoggedIn: true,
        );
        secureStorageUtils.userData = userData;
      } else {
        /// if its isRememberedMe but now value is false
        secureStorageUtils.userData?.isLoggedIn = true;
        secureStorageUtils.userData?.isRememberedMe = event.isRememberedMe;
      }
      await secureStorageUtils.storeUserData();
      emit(LoginSuccessState());
    }
  }

  FutureOr<void> _loginGetUserDataEvent(
    LoginGetUserDataEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginGetUserDataState());
  }
}
