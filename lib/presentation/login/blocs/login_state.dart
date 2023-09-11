part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginFailureState extends LoginState {
  final String message;

  LoginFailureState({required this.message});
}

class LoginHideShowPasswordState extends LoginState {
  final bool isPasswordVisible;

  LoginHideShowPasswordState({required this.isPasswordVisible});
}

class LoginRememberedMeState extends LoginState {
  final bool isRememberedMe;

  LoginRememberedMeState({
    required this.isRememberedMe,
  });
}

class LoginFieldsValidState extends LoginState {
  final bool isValidUserName;
  final bool isValidPassword;

  LoginFieldsValidState({
    required this.isValidUserName,
    required this.isValidPassword,
  });
}

class LoginSuccessState extends LoginState {}

class LoginGetUserDataState extends LoginState {}
