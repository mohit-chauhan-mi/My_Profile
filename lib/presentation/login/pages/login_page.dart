import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_extensions.dart';
import '../../../core/constant/app_strings.dart';
import '../../../core/constant/dimens.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../core/utils/widgets/app_elevated_button.dart';
import '../../../core/utils/widgets/app_loading_button.dart';
import '../../../core/utils/widgets/app_text_field.dart';
import '../../../core/utils/widgets/app_text_field_with_header.dart';
import '../../../injector/injector.dart';
import '../../home/pages/home_page.dart';
import '../blocs/login_bloc.dart';
import 'widgets/checkbox_item.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const route = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controller of the text fields
  final TextEditingController textControllerUsername =
      TextEditingController(text: ''); // user name is email
  final TextEditingController textControllerPassword =
      TextEditingController(text: ''); // password is name
  final FocusNode focusNodeUsername = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  bool isPasswordVisible = false;
  bool isRememberedMeChecked = false;

  /// [_userName] is used to validate username/email text field.
  final _userName = GlobalKey<FormState>();

  /// [_passwordKey] is used to validate password/name text field.
  final _passwordKey = GlobalKey<FormState>();

  /// LoginBloc for state management
  LoginBloc loginBloc = sl<LoginBloc>();

  /// Based on validation of fields button is enabled
  bool isValidFormFields = false;
  bool isValidUserName = false;
  bool isValidPassword = false;

  /// Secure Storage Utils
  SecureStorageUtils secureStorageUtils = sl<SecureStorageUtils>();

  @override
  void initState() {
    super.initState();
    loginBloc.add(LoginGetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          AppStrings.login,
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: Dimens.d20.paddingHorizontal,
          child: BlocConsumer<LoginBloc, LoginState>(
            bloc: loginBloc,
            listener: (context, state) {
              if (state is LoginFailureState) {
                context.showSnackBar(text: state.message);
              } else if (state is LoginHideShowPasswordState) {
                isPasswordVisible = state.isPasswordVisible;
              } else if (state is LoginRememberedMeState) {
                isRememberedMeChecked = state.isRememberedMe;
              } else if (state is LoginFieldsValidState) {
                isValidUserName = state.isValidUserName;
                isValidPassword = state.isValidPassword;
                isValidFormFields = isValidUserName && isValidPassword;
              } else if (state is LoginSuccessState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomePage.route,
                  (route) => false,
                );
              } else if (state is LoginGetUserDataState) {
                if (secureStorageUtils.userData?.isRememberedMe ?? false) {
                  /// Updating the required things
                  isRememberedMeChecked = true;
                  textControllerUsername.text =
                      secureStorageUtils.userData?.email ?? '';
                  textControllerPassword.text =
                      secureStorageUtils.userData?.password ?? '';
                  isValidUserName = _userName.currentState?.validate() ?? false;
                  isValidPassword =
                      _passwordKey.currentState?.validate() ?? false;
                  loginBloc.add(LoginFieldsValidEvent(
                    isValidUserName: isValidUserName,
                    isValidPassword: isValidPassword,
                  ));
                }
              }
            },
            builder: (context, state) {
              return IgnorePointer(
                ignoring: state is LoginLoadingState,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: Dimens.d46.paddingVertical,
                              child: Text(
                                AppStrings.loginMessage,
                                style: context.theme.textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Form(
                              key: _userName,
                              child: AppTextFieldWithHeader(
                                headerText: AppStrings.username,
                                appTextField: AppTextField(
                                  controller: textControllerUsername,
                                  focusNode: focusNodeUsername,
                                  hintText: AppStrings.pleaseEnterYourEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  prefixIconPath: AppAssets.icEmail,
                                  onChange: (value) {
                                    isValidUserName =
                                        _userName.currentState?.validate() ??
                                            false;
                                    loginBloc.add(LoginFieldsValidEvent(
                                      isValidUserName: isValidUserName,
                                      isValidPassword: isValidPassword,
                                    ));
                                  },
                                  validator: (String? value) {
                                    if (value.isNullOrBlank) {
                                      return AppStrings.pleaseEnterYourEmail;
                                    } else if (!value.isValidEmail) {
                                      return AppStrings.pleaseEnterValidEmail;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Dimens.d16.spaceHeight,
                            Form(
                              key: _passwordKey,
                              child: AppTextFieldWithHeader(
                                headerText: AppStrings.password,
                                appTextField: AppTextField(
                                  controller: textControllerPassword,
                                  focusNode: focusNodePassword,
                                  hintText: AppStrings.pleaseEnterYourPassword,
                                  textInputAction: TextInputAction.done,
                                  obscureText: !isPasswordVisible,
                                  maxLines: 1,
                                  prefixIconPath: AppAssets.icLock,
                                  suffixIconPath: isPasswordVisible
                                      ? AppAssets.icEyeClose
                                      : AppAssets.icEyeOpen,
                                  suffixIconPathTap: () {
                                    loginBloc.add(
                                      LoginPasswordHideShowEvent(
                                        isPasswordVisible: isPasswordVisible,
                                      ),
                                    );
                                  },
                                  onChange: (value) {
                                    isValidPassword =
                                        _passwordKey.currentState?.validate() ??
                                            false;
                                    loginBloc.add(LoginFieldsValidEvent(
                                      isValidUserName: isValidUserName,
                                      isValidPassword: isValidPassword,
                                    ));
                                  },
                                  validator: (String? value) {
                                    if (value.isNullOrBlank) {
                                      return AppStrings.pleaseEnterYourPassword;
                                    } else if (!value.isValidName) {
                                      return AppStrings
                                          .pleaseEnterValidPassword;
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (isValidFormFields) _doLoginRequest();
                                  },
                                ),
                              ),
                            ),
                            Dimens.d16.spaceHeight,
                            CheckBoxItem(
                              onItemTap: () {
                                _rememberedMeOnCheckChange(
                                  isRememberedMeChecked,
                                );
                              },
                              checkValue: isRememberedMeChecked,
                              onCheckChanged: _rememberedMeOnCheckChange,
                              itemTitle: AppStrings.rememberedMe,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: Dimens.d20.paddingVertical,
                      child: state is LoginLoadingState
                          ? const AppLoadingButton()
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              child: AppElevatedButton(
                                key: ValueKey<bool>(isValidFormFields),
                                text: AppStrings.login,
                                onPressed:
                                    isValidFormFields ? _doLoginRequest : null,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _rememberedMeOnCheckChange(bool? value) {
    loginBloc.add(LoginRememberedMeEvent(
      isRememberedMe: isRememberedMeChecked,
    ));
  }

  void _doLoginRequest() {
    loginBloc.add(
      LoginRequestEvent(
        username: textControllerUsername.text,
        password: textControllerPassword.text,
        isRememberedMe: isRememberedMeChecked,
      ),
    );
  }
}
