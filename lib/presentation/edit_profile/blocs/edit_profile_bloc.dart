import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/app_enums.dart';
import '../../../core/constant/app_strings.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../data/model/work_experience.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  SecureStorageUtils secureStorageUtils;

  EditProfileBloc({
    required this.secureStorageUtils,
  }) : super(EditProfileInitial()) {
    on<EditProfileGetUserDataEvent>(_editProfileGetUserDataEvent);
    on<EditFieldsUpdatedEvent>(_editFieldsUpdatedEvent);
    on<EditFieldsValidEvent>(_editFieldsValidEvent);
    on<EditProfileRequestEvent>(_editProfileRequestEvent);
    on<EditProfileRemoveSkillEvent>(_editProfileRemoveSkillEvent);
    on<WorkExperienceValidEvent>(_workExperienceValidEvent);
    on<WorkExperienceRequestEvent>(_workExperienceRequestEvent);
  }

  FutureOr<void> _editProfileGetUserDataEvent(
    EditProfileGetUserDataEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(EditProfileGetUserDataState());
  }

  FutureOr<void> _editFieldsUpdatedEvent(
    EditFieldsUpdatedEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(EditFieldsUpdatedState());
  }

  FutureOr<void> _editFieldsValidEvent(
    EditFieldsValidEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(EditFieldsValidState(
      isValidEditField: event.isValidEditField,
    ));
  }

  FutureOr<void> _editProfileRequestEvent(
    EditProfileRequestEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      if (event.editProfileType == EditProfileType.name) {
        emit(EditProfileLoadingState());

        /// To show the loading button in UI
        await Future.delayed(const Duration(seconds: 1));
        secureStorageUtils.userData?.name = event.newValue;
        await secureStorageUtils.storeUserData();
        emit(EditProfileSuccessState());
      } else if (event.editProfileType == EditProfileType.email) {
        emit(EditProfileLoadingState());

        /// To show the loading button in UI
        await Future.delayed(const Duration(seconds: 1));
        secureStorageUtils.userData?.email = event.newValue;
        await secureStorageUtils.storeUserData();
        emit(EditProfileSuccessState());
      } else if (event.editProfileType == EditProfileType.addSkill) {
        emit(EditProfileLoadingState());

        /// To show the loading button in UI
        await Future.delayed(const Duration(seconds: 1));

        bool isSameSkill = secureStorageUtils.userData?.skills
                ?.contains(event.newValue ?? '') ??
            false;

        if (!isSameSkill) {
          secureStorageUtils.userData?.skills?.add(event.newValue ?? '');
          await secureStorageUtils.storeUserData();
          emit(EditProfileSuccessState());
        } else {
          emit(EditProfileFailureState(message: AppStrings.sameSkillAdded));
        }
      } else if (event.editProfileType == EditProfileType.editSkills) {
        emit(EditProfileLoadingState());

        /// To show the loading button in UI
        await Future.delayed(const Duration(seconds: 1));
        secureStorageUtils.userData?.skills = event.skills;
        await secureStorageUtils.storeUserData();
        emit(EditProfileSuccessState());
      }
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
      emit(EditProfileFailureState(message: AppStrings.wentWrong));
    }
  }

  FutureOr<void> _editProfileRemoveSkillEvent(
    EditProfileRemoveSkillEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileRemoveSkillState(
      indexToRemove: event.indexToRemove,
    ));
  }

  FutureOr<void> _workExperienceValidEvent(
    WorkExperienceValidEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(WorkExperienceValidState(
      isValidCompanyName: event.isValidCompanyName,
      isValidDesignation: event.isValidDesignation,
      isValidExperience: event.isValidExperience,
    ));
  }

  FutureOr<void> _workExperienceRequestEvent(
    WorkExperienceRequestEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      emit(EditProfileLoadingState());

      /// To show the loading button in UI
      await Future.delayed(const Duration(seconds: 1));
      WorkExperience workExperience = WorkExperience(
        companyName: event.companyName,
        designation: event.designation,
        experience: double.tryParse(event.experience) ?? 0,
      );

      if (event.isUpdateWorkExperience && event.workExperienceIndex != null) {
        secureStorageUtils.userData
            ?.workExperiences?[event.workExperienceIndex!] = workExperience;
      } else {
        secureStorageUtils.userData?.workExperiences?.add(workExperience);
      }
      await secureStorageUtils.storeUserData();
      emit(WorkExperienceSuccessState());
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
      emit(EditProfileFailureState(message: AppStrings.wentWrong));
    }
  }
}
