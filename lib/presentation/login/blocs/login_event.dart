part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginPasswordHideShowEvent extends LoginEvent {
  final bool isPasswordVisible;

  LoginPasswordHideShowEvent({
    required this.isPasswordVisible,
  });
}

class LoginRememberedMeEvent extends LoginEvent {
  final bool isRememberedMe;

  LoginRememberedMeEvent({
    required this.isRememberedMe,
  });
}

class LoginFieldsValidEvent extends LoginEvent {
  final bool isValidUserName;
  final bool isValidPassword;

  LoginFieldsValidEvent({
    required this.isValidUserName,
    required this.isValidPassword,
  });
}

class LoginRequestEvent extends LoginEvent {
  final String username;
  final String password;
  final bool isRememberedMe;

  LoginRequestEvent({
    required this.username,
    required this.password,
    required this.isRememberedMe,
  });
}

class LoginGetUserDataEvent extends LoginEvent {}
