import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_assets.dart';
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
import '../../../data/model/work_experience.dart';
import '../../../injector/injector.dart';
import '../blocs/edit_profile_bloc.dart';

class WorkExperiencePage extends StatefulWidget {
  const WorkExperiencePage({
    super.key,
    required this.isUpdateWorkExperience,
    this.workExperienceIndex,
  });

  static const route = '/workExperiencePage';

  final bool isUpdateWorkExperience;
  final int? workExperienceIndex;

  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  /// Controller of the text fields
  final TextEditingController companyNameController =
      TextEditingController(text: '');
  final TextEditingController designationController =
      TextEditingController(text: '');
  final TextEditingController experienceController =
      TextEditingController(text: '');
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode designationFocusNode = FocusNode();
  final FocusNode experienceFocusNode = FocusNode();

  /// Used to validate fields
  final companyNameFieldKey = GlobalKey<FormState>();
  final designationFieldKey = GlobalKey<FormState>();
  final experienceFieldKey = GlobalKey<FormState>();

  /// Based on validation of fields button is enabled
  bool isValidFormFields = false;
  bool isValidCompanyName = false;
  bool isValidDesignation = false;
  bool isValidExperience = false;

  /// To check that data is updated or not
  bool isDataUpdated = false;

  /// Work Experience data holder
  WorkExperience? workExperience;

  /// Secure Storage Utils
  SecureStorageUtils secureStorageUtils = sl<SecureStorageUtils>();

  /// LoginBloc for state management
  EditProfileBloc editProfileBloc = sl<EditProfileBloc>();

  String get appBarTitle =>
      '${widget.isUpdateWorkExperience ? AppStrings.edit : AppStrings.add} ${AppStrings.workExperience}';

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateWorkExperience) {
      editProfileBloc.add(EditProfileGetUserDataEvent());
    }
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
                } else if (state is EditProfileGetUserDataState) {
                  if (widget.isUpdateWorkExperience &&
                      widget.workExperienceIndex != null) {
                    workExperience = secureStorageUtils.userData
                        ?.workExperiences?[widget.workExperienceIndex!];
                    companyNameController.text =
                        workExperience?.companyName ?? '';
                    designationController.text =
                        workExperience?.designation ?? '';
                    experienceController.text =
                        workExperience?.experience?.toStringAsFixed(1) ?? '';

                    isValidCompanyName =
                        companyNameFieldKey.currentState?.validate() ?? false;
                    isValidDesignation =
                        designationFieldKey.currentState?.validate() ?? false;
                    isValidExperience =
                        experienceFieldKey.currentState?.validate() ?? false;

                    editProfileBloc.add(WorkExperienceValidEvent(
                      isValidCompanyName: isValidCompanyName,
                      isValidDesignation: isValidDesignation,
                      isValidExperience: isValidExperience,
                    ));
                  }
                } else if (state is WorkExperienceValidState) {
                  isValidCompanyName = state.isValidCompanyName;
                  isValidDesignation = state.isValidDesignation;
                  isValidExperience = state.isValidExperience;
                  isValidFormFields = isValidCompanyName &&
                      isValidDesignation &&
                      isValidExperience;
                } else if (state is EditFieldsUpdatedState) {
                  if (widget.isUpdateWorkExperience) {
                    isDataUpdated = (workExperience?.companyName !=
                            companyNameController.text.trim()) ||
                        (workExperience?.designation !=
                            designationController.text.trim()) ||
                        (workExperience?.experience?.toStringAsFixed(1) !=
                            experienceController.text);
                  } else {
                    isDataUpdated = (companyNameController.text.trim().isNotEmpty) ||
                        (designationController.text.trim().isNotEmpty) ||
                        (experienceController.text.isNotEmpty);
                  }
                } else if (state is WorkExperienceSuccessState) {
                  Navigator.pop(context);
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
                        Dimens.d24.spaceHeight,
                        Form(
                          key: companyNameFieldKey,
                          child: AppTextFieldWithHeader(
                            headerText: AppStrings.companyName,
                            appTextField: AppTextField(
                              controller: companyNameController,
                              focusNode: companyNameFocusNode,
                              hintText: AppStrings.pleaseEnterYourCompanyName,
                              maxLines: 1,
                              prefixIconPath: AppAssets.icOrganization,
                              textCapitalization: TextCapitalization.sentences,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExps.nameNumberAndWhiteSpaceOnly,
                                ),
                              ],
                              onChange: (value) {
                                isValidCompanyName = companyNameFieldKey
                                        .currentState
                                        ?.validate() ??
                                    false;
                                editProfileBloc.add(EditFieldsUpdatedEvent());
                                editProfileBloc.add(WorkExperienceValidEvent(
                                  isValidCompanyName: isValidCompanyName,
                                  isValidDesignation: isValidDesignation,
                                  isValidExperience: isValidExperience,
                                ));
                              },
                              validator: (value) {
                                if (value.isNullOrBlank) {
                                  return AppStrings.pleaseEnterYourCompanyName;
                                } else if (!value.isValidName) {
                                  return AppStrings.pleaseEnterValidCompanyName;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Dimens.d16.spaceHeight,
                        Form(
                          key: designationFieldKey,
                          child: AppTextFieldWithHeader(
                            headerText: AppStrings.designation,
                            appTextField: AppTextField(
                              controller: designationController,
                              focusNode: designationFocusNode,
                              hintText: AppStrings.pleaseEnterYourDesignation,
                              maxLines: 1,
                              prefixIconPath: AppAssets.icDesignation,
                              textCapitalization: TextCapitalization.sentences,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExps.nameNumberAndWhiteSpaceOnly,
                                )
                              ],
                              onChange: (value) {
                                isValidDesignation = designationFieldKey
                                        .currentState
                                        ?.validate() ??
                                    false;
                                editProfileBloc.add(EditFieldsUpdatedEvent());
                                editProfileBloc.add(WorkExperienceValidEvent(
                                  isValidCompanyName: isValidCompanyName,
                                  isValidDesignation: isValidDesignation,
                                  isValidExperience: isValidExperience,
                                ));
                              },
                              validator: (value) {
                                if (value.isNullOrBlank) {
                                  return AppStrings.pleaseEnterYourDesignation;
                                } else if (!value.isValidName) {
                                  return AppStrings.pleaseEnterValidDesignation;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Dimens.d16.spaceHeight,
                        Form(
                          key: experienceFieldKey,
                          child: AppTextFieldWithHeader(
                            headerText: '${AppStrings.experience} (${AppStrings.inYears})',
                            appTextField: AppTextField(
                              controller: experienceController,
                              focusNode: experienceFocusNode,
                              hintText: AppStrings.pleaseEnterYourExperience,
                              maxLines: 1,
                              prefixIconPath: AppAssets.icWork,
                              textInputAction: TextInputAction.done,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExps.decimalValue,
                                )
                              ],
                              onChange: (value) {
                                isValidExperience = experienceFieldKey
                                        .currentState
                                        ?.validate() ??
                                    false;
                                editProfileBloc.add(EditFieldsUpdatedEvent());
                                editProfileBloc.add(WorkExperienceValidEvent(
                                  isValidCompanyName: isValidCompanyName,
                                  isValidDesignation: isValidDesignation,
                                  isValidExperience: isValidExperience,
                                ));
                              },
                              validator: (value) {
                                if (value.isNullOrBlank) {
                                  return AppStrings.pleaseEnterYourExperience;
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (isValidFormFields && isDataUpdated) {
                                  _doWorkExperienceRequest();
                                }
                              },
                            ),
                          ),
                        ),
                        Dimens.d24.spaceHeight,
                        state is EditProfileLoadingState
                            ? const AppLoadingButton()
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 600),
                                child: AppElevatedButton(
                                  key: ValueKey<bool>(
                                      isValidFormFields && isDataUpdated),
                                  text: AppStrings.save,
                                  onPressed: isValidFormFields && isDataUpdated
                                      ? _doWorkExperienceRequest
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

  void _doWorkExperienceRequest() {
    editProfileBloc.add(
      WorkExperienceRequestEvent(
        isUpdateWorkExperience: widget.isUpdateWorkExperience,
        companyName: companyNameController.text.trim(),
        designation: designationController.text.trim(),
        experience: experienceController.text,
        workExperienceIndex: widget.workExperienceIndex,
      ),
    );
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
}
