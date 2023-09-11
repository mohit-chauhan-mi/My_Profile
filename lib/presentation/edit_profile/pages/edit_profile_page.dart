import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/constant/app_extensions.dart';
import '../../../core/constant/app_strings.dart';
import '../../../core/constant/dimens.dart';
import '../../../core/utils/regexps.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../core/utils/widgets/app_confirm_dialog.dart';
import '../../../core/utils/widgets/app_elevated_button.dart';
import '../../../core/utils/widgets/app_loading_button.dart';
import '../../../core/utils/widgets/app_text_field.dart';
import '../../../core/utils/widgets/app_text_field_with_header.dart';
import '../../../injector/injector.dart';
import '../../home/pages/widgets/skills_set_chips.dart';
import '../blocs/edit_profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.editProfileType,
  });

  static const route = '/editProfilePage';

  final EditProfileType editProfileType;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  /// Controller of the text fields
  final TextEditingController textController = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();

  /// Used to validate the text field
  final editFieldKey = GlobalKey<FormState>();

  /// Edit field data holders
  String? headerText;
  String? hintText;
  TextInputType? keyboardType;
  String? prefixIconPath;

  /// Based on validation of fields button is enabled
  bool isValidEditField = false;
  bool isDataUpdated = false;

  /// Skills Data holder
  List<String>? skillsList;

  /// Secure Storage Utils
  SecureStorageUtils secureStorageUtils = sl<SecureStorageUtils>();

  /// EditProfileBloc for state management
  EditProfileBloc editProfileBloc = sl<EditProfileBloc>();

  String get appBarTitle =>
      (widget.editProfileType == EditProfileType.editSkills)
          ? '${AppStrings.edit} ${AppStrings.skills}'
          : (widget.editProfileType == EditProfileType.addSkill)
              ? '${AppStrings.add} ${AppStrings.skill}'
              : AppStrings.editProfile;

  @override
  void initState() {
    super.initState();
    editProfileBloc.add(EditProfileGetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Padding(
            padding: Dimens.d20.paddingHorizontal,
            child: BlocConsumer<EditProfileBloc, EditProfileState>(
              bloc: editProfileBloc,
              listener: (context, state) {
                if (state is EditProfileFailureState) {
                  context.showSnackBar(text: state.message);
                } else if (state is EditProfileSuccessState) {
                  Navigator.pop(context);
                } else if (state is EditProfileGetUserDataState) {
                  _setEditProfileData();
                } else if (state is EditFieldsValidState) {
                  isValidEditField = state.isValidEditField;
                } else if (state is EditFieldsUpdatedState) {
                  switch (widget.editProfileType) {
                    case EditProfileType.name:
                      isDataUpdated = secureStorageUtils.userData?.name !=
                          textController.text.trim();
                    case EditProfileType.email:
                      isDataUpdated = secureStorageUtils.userData?.email !=
                          textController.text.trim();
                    case EditProfileType.addSkill:
                      isDataUpdated = textController.text.trim().isNotEmpty;
                      break;
                    case EditProfileType.editSkills:
                      isDataUpdated = (
                        secureStorageUtils.userData?.skills ?? [],
                        skillsList ?? []
                      ).isIdenticalList();
                      editProfileBloc.add(EditFieldsValidEvent(
                        isValidEditField: isDataUpdated,
                      ));
                    default:
                      break;
                  }
                } else if (state is EditProfileRemoveSkillState) {
                  skillsList?.removeAt(state.indexToRemove);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IgnorePointer(
                    ignoring: state is EditProfileLoadingState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.editProfileType == EditProfileType.name ||
                            widget.editProfileType == EditProfileType.email ||
                            widget.editProfileType == EditProfileType.addSkill)
                          Padding(
                            padding: Dimens.d24.paddingVertical,
                            child: Form(
                              key: editFieldKey,
                              child: AppTextFieldWithHeader(
                                headerText: headerText ?? '',
                                appTextField: AppTextField(
                                  controller: textController,
                                  focusNode: focusNode,
                                  hintText: hintText,
                                  keyboardType: keyboardType,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  textCapitalization: (widget.editProfileType !=
                                          EditProfileType.email)
                                      ? TextCapitalization.sentences
                                      : null,
                                  prefixIconPath: prefixIconPath,
                                  inputFormatters: [
                                    if (widget.editProfileType ==
                                            EditProfileType.name ||
                                        widget.editProfileType ==
                                            EditProfileType.addSkill)
                                      FilteringTextInputFormatter.allow(
                                        RegExps.nameNumberAndWhiteSpaceOnly,
                                      )
                                  ],
                                  onChange: (value) {
                                    isValidEditField =
                                        editFieldKey.currentState?.validate() ??
                                            false;
                                    editProfileBloc
                                        .add(EditFieldsUpdatedEvent());
                                    editProfileBloc.add(EditFieldsValidEvent(
                                      isValidEditField: isValidEditField,
                                    ));
                                  },
                                  validator: _editFieldValidator,
                                  onFieldSubmitted: (value) {
                                    if (isValidEditField && isDataUpdated) {
                                      _doEditProfileRequest();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        if (widget.editProfileType ==
                            EditProfileType.editSkills) ...[
                          Dimens.d24.spaceHeight,
                          Text(
                            AppStrings.skills,
                            style: context.theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Dimens.d10.spaceHeight,
                          SkillsSetChips(
                            skillsList: skillsList ?? [],
                            isDeleteIcon: true,
                            onDeletePressed: (index) {
                              editProfileBloc.add(EditProfileRemoveSkillEvent(
                                indexToRemove: index,
                              ));
                              editProfileBloc.add(EditFieldsUpdatedEvent());
                            },
                            isEditIconBtn: true,
                            editIconAssetPath: AppAssets.icAdd,
                            onEditPressed: () {
                              _editProfileNavigation(arguments: {
                                AppStrings.keyEditProfileType:
                                    EditProfileType.addSkill,
                              });
                            },
                          ),
                          Dimens.d24.spaceHeight,
                        ],
                        state is EditProfileLoadingState
                            ? const AppLoadingButton()
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 600),
                                child: AppElevatedButton(
                                  key: ValueKey<bool>(isValidEditField),
                                  text: AppStrings.save,
                                  onPressed: isValidEditField && isDataUpdated
                                      ? _doEditProfileRequest
                                      : null,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _doEditProfileRequest() {
    if (widget.editProfileType == EditProfileType.name ||
        widget.editProfileType == EditProfileType.email ||
        widget.editProfileType == EditProfileType.addSkill) {
      editProfileBloc.add(
        EditProfileRequestEvent(
          editProfileType: widget.editProfileType,
          newValue: textController.text.trim(),
        ),
      );
    } else if (widget.editProfileType == EditProfileType.editSkills) {
      editProfileBloc.add(
        EditProfileRequestEvent(
          editProfileType: widget.editProfileType,
          skills: skillsList,
        ),
      );
    }
  }

  void _setEditProfileData() {
    switch (widget.editProfileType) {
      case EditProfileType.name:
        headerText = AppStrings.name;
        hintText = AppStrings.pleaseEnterYourName;
        keyboardType = TextInputType.text;
        prefixIconPath = AppAssets.icUser;
        textController.text = secureStorageUtils.userData?.name ?? '';
        isValidEditField = editFieldKey.currentState?.validate() ?? false;
        editProfileBloc
            .add(EditFieldsValidEvent(isValidEditField: isValidEditField));

      case EditProfileType.email:
        headerText = AppStrings.email;
        hintText = AppStrings.pleaseEnterYourEmail;
        keyboardType = TextInputType.emailAddress;
        prefixIconPath = AppAssets.icEmail;
        textController.text = secureStorageUtils.userData?.email ?? '';
        isValidEditField = editFieldKey.currentState?.validate() ?? false;
        editProfileBloc
            .add(EditFieldsValidEvent(isValidEditField: isValidEditField));

      case EditProfileType.addSkill:
        headerText = AppStrings.skill;
        hintText = AppStrings.pleaseEnterYourSkill;
        keyboardType = TextInputType.text;
        prefixIconPath = AppAssets.icSkills;
        textController.text = '';
        break;

      case EditProfileType.editSkills:
        skillsList = List.from(secureStorageUtils.userData?.skills ?? []);

      default:
        break;
    }
  }

  String? _editFieldValidator(String? value) {
    switch (widget.editProfileType) {
      case EditProfileType.name:
        if (value.isNullOrBlank) {
          return AppStrings.pleaseEnterYourName;
        } else if (!value.isValidName) {
          return AppStrings.pleaseEnterValidName;
        }

      case EditProfileType.email:
        if (value.isNullOrBlank) {
          return AppStrings.pleaseEnterYourEmail;
        } else if (!value.isValidEmail) {
          return AppStrings.pleaseEnterValidEmail;
        }

      case EditProfileType.addSkill:
        if (value.isNullOrBlank) {
          return AppStrings.pleaseEnterYourSkill;
        } else if (!value.isValidName) {
          return AppStrings.pleaseEnterValidSkillName;
        }

      default:
        break;
    }
    return null;
  }

  Future<bool> _onWillPop() async {
    /// Check if data have been updated
    if (isDataUpdated) {
      /// Show a confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppConfirmDialog(
            title: appBarTitle,
            subtitle: AppStrings.wantToDiscardChanges,
            positiveText: AppStrings.cancel,
            negativeText: AppStrings.discard,
            onPositiveTap: () {
              Navigator.of(context).pop(false);
            },
            onNegativeTap: () {
              Navigator.of(context).pop(true);
            },
          );
        },
      );

      /// Return the user's choice
      return confirm;
    }

    /// If data are not updated, allow navigation back
    return true;
  }

  void _editProfileNavigation({required Map<String, dynamic> arguments}) {
    Navigator.pushNamed(context, EditProfilePage.route, arguments: arguments)
        .then((value) {
      editProfileBloc.add(EditProfileGetUserDataEvent());
    });
  }
}
