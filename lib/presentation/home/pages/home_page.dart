import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/constant/app_extensions.dart';
import '../../../core/constant/app_strings.dart';
import '../../../core/constant/dimens.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../core/utils/widgets/app_confirm_dialog.dart';
import '../../../core/utils/widgets/app_text_field.dart';
import '../../../core/utils/widgets/app_text_field_with_header.dart';
import '../../../data/model/picked_image.dart';
import '../../../data/model/work_experience.dart';
import '../../../injector/injector.dart';
import '../../edit_profile/pages/edit_profile_page.dart';
import '../../edit_profile/pages/work_experience_page.dart';
import '../../login/pages/login_page.dart';
import '../blocs/home_bloc.dart';
import 'widgets/header_with_button.dart';
import 'widgets/skills_set_chips.dart';
import 'widgets/user_image_widget.dart';
import 'widgets/work_experience_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Secure Storage Utils
  SecureStorageUtils secureStorageUtils = sl<SecureStorageUtils>();

  /// Controller for text fields
  final TextEditingController textControllerName =
      TextEditingController(text: '');
  final TextEditingController textControllerEmail =
      TextEditingController(text: '');

  /// Skills Data holder
  List<String> skillsList = [];

  /// Work Experience Data holder
  List<WorkExperience> workExperienceList = [];

  /// LoginBloc for state management
  HomeBloc homeBloc = sl<HomeBloc>();

  /// For user image
  final ImagePicker picker = ImagePicker();
  PickedImage? userImage;

  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeCheckOnPhotosPermissionEvent());
    homeBloc.add(HomeGetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          AppStrings.home,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _onLogoutPressed(context);
            },
            highlightColor: AppColors.transparent,
            splashColor: AppColors.transparent,
            icon: const Icon(
              Icons.power_settings_new_rounded,
            ),
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: Dimens.d20.paddingHorizontal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocConsumer<HomeBloc, HomeState>(
              bloc: homeBloc,
              listener: (context, state) {
                if (state is HomeGetUserDataState) {
                  textControllerName.text =
                      secureStorageUtils.userData?.name ?? '';
                  textControllerEmail.text =
                      secureStorageUtils.userData?.email ?? '';
                  skillsList =
                      secureStorageUtils.userData?.skills ?? <String>[];
                  workExperienceList =
                      secureStorageUtils.userData?.workExperiences ??
                          <WorkExperience>[];
                  userImage = secureStorageUtils.userData?.userImage;
                } else if (state is HomeDeleteWorkExperienceSuccessState) {
                  context.showSnackBar(text: AppStrings.workExperienceRemoved);
                } else if (state is HomeFailureState) {
                  context.showSnackBar(text: state.message);
                } else if (state is HomeUserImagePickedState) {
                  userImage = state.pickedImage;
                } else if (state is HomePhotosPermissionState) {
                  if (state.showImagePicker) {
                    _showImagePicker(
                      context: context,
                      onPicked: (image) {
                        homeBloc.add(HomeUserImagePickedEvent(
                          pickedImage: image,
                        ));
                      },
                    );
                  } else if (state.isError) {
                    context.showSnackBar(text: AppStrings.permissionDenied);
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Dimens.d16.spaceHeight,
                    Center(
                      child: Stack(
                        children: [
                          UserImageWidget(userImage: userImage),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                homeBloc.add(HomeCheckOnPhotosPermissionEvent(
                                    showImagePicker: true));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: Dimens.d10.paddingAll,
                                child: SvgPicture.asset(
                                  AppAssets.icEdit,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Dimens.d16.spaceHeight,
                    AppTextFieldWithHeader(
                      headerText: AppStrings.name,
                      appTextField: AppTextField(
                        controller: textControllerName,
                        readOnly: true,
                        maxLines: 1,
                        prefixIconPath: AppAssets.icUser,
                        suffixIconPath: AppAssets.icEdit,
                        suffixIconPathTap: () {
                          _editProfileNavigation(arguments: {
                            AppStrings.keyEditProfileType: EditProfileType.name,
                          });
                        },
                      ),
                    ),
                    Dimens.d16.spaceHeight,
                    AppTextFieldWithHeader(
                      headerText: AppStrings.email,
                      appTextField: AppTextField(
                        controller: textControllerEmail,
                        readOnly: true,
                        maxLines: 1,
                        textStyle:
                            context.theme.textTheme.titleMedium?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        prefixIconPath: AppAssets.icEmail,
                        suffixIconPath: AppAssets.icEdit,
                        suffixIconPathTap: () {
                          _editProfileNavigation(arguments: {
                            AppStrings.keyEditProfileType:
                                EditProfileType.email,
                          });
                        },
                      ),
                    ),
                    Dimens.d16.spaceHeight,
                    HeaderWithIconButton(
                      title: AppStrings.skills,
                      iconAssetsPath: AppAssets.icAdd,
                      onIconPressed: () {
                        _editProfileNavigation(arguments: {
                          AppStrings.keyEditProfileType:
                              EditProfileType.addSkill,
                        });
                      },
                    ),
                    Dimens.d10.spaceHeight,
                    SkillsSetChips(
                      skillsList: skillsList,
                      isEditIconBtn: skillsList.isNotEmpty,
                      onEditPressed: skillsList.isNotEmpty
                          ? () {
                              _editProfileNavigation(arguments: {
                                AppStrings.keyEditProfileType:
                                    EditProfileType.editSkills,
                              });
                            }
                          : null,
                    ),
                    Dimens.d16.spaceHeight,
                    HeaderWithIconButton(
                      title: AppStrings.workExperience,
                      iconAssetsPath: AppAssets.icAdd,
                      onIconPressed: () {
                        _workExperienceNavigation(arguments: {
                          AppStrings.keyIsUpdateWorkExperience: false,
                        });
                      },
                    ),
                    Dimens.d10.spaceHeight,
                    ListView.separated(
                      itemCount: workExperienceList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemBuilder: (context, index) {
                        var item = workExperienceList[index];
                        return WorkExperienceListItem(
                          workExperience: item,
                          onEditPressed: () {
                            _workExperienceNavigation(arguments: {
                              AppStrings.keyIsUpdateWorkExperience: true,
                              AppStrings.keyWorkExperienceIndex: index,
                            });
                          },
                          onDeletePressed: () {
                            _onWorkExperienceRemovedPressed(context, index);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Dimens.d10.spaceHeight,
                    ),
                    Dimens.d20.spaceHeight,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _editProfileNavigation({required Map<String, dynamic> arguments}) {
    Navigator.pushNamed(context, EditProfilePage.route, arguments: arguments)
        .then((value) {
      homeBloc.add(HomeGetUserDataEvent());
    });
  }

  void _workExperienceNavigation({required Map<String, dynamic> arguments}) {
    Navigator.pushNamed(context, WorkExperiencePage.route, arguments: arguments)
        .then((value) {
      homeBloc.add(HomeGetUserDataEvent());
    });
  }

  void _onLogoutPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AppConfirmDialog(
          title: AppStrings.logout,
          subtitle: AppStrings.wantToLogout,
          positiveText: AppStrings.no,
          negativeText: AppStrings.logout,
          onPositiveTap: () {
            Navigator.pop(context);
          },
          onNegativeTap: () async {
            /// Logging out the user
            secureStorageUtils.userData?.isLoggedIn = false;
            await secureStorageUtils.storeUserData();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.route,
                (route) => false,
              );
            }
          },
        );
      },
    );
  }

  void _onWorkExperienceRemovedPressed(
    BuildContext context,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AppConfirmDialog(
          title: '${AppStrings.remove} ${AppStrings.workExperience}',
          subtitle: AppStrings.wantToRemoveWorkExperience,
          positiveText: AppStrings.no,
          negativeText: AppStrings.remove,
          onPositiveTap: () {
            Navigator.pop(context);
          },
          onNegativeTap: () {
            Navigator.pop(context);
            homeBloc.add(HomeDeleteWorkExperienceEvent(
              indexToDelete: index,
            ));
          },
        );
      },
    );
  }

  /// Showing image picker and setting the picked image for the user
  Future<void> _showImagePicker({
    required BuildContext context,
    required ValueChanged<PickedImage> onPicked,
  }) async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 60)
        .then((value) async {
      if (value != null) {
        final image = await PickedImage.fromXFile(value);
        if (image != null) {
          onPicked(image);
        }
      }
    });
  }
}
