part of 'edit_profile_bloc.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileFailureState extends EditProfileState {
  final String message;

  EditProfileFailureState({required this.message});
}

class EditProfileGetUserDataState extends EditProfileState {}

class EditFieldsUpdatedState extends EditProfileState {
  EditFieldsUpdatedState();
}

class EditFieldsValidState extends EditProfileState {
  final bool isValidEditField;

  EditFieldsValidState({required this.isValidEditField});
}

class EditProfileSuccessState extends EditProfileState {
  EditProfileSuccessState();
}

class EditProfileRemoveSkillState extends EditProfileState {
  final int indexToRemove;

  EditProfileRemoveSkillState({required this.indexToRemove});
}

class WorkExperienceValidState extends EditProfileState {
  final bool isValidCompanyName;
  final bool isValidDesignation;
  final bool isValidExperience;

  WorkExperienceValidState({
    required this.isValidCompanyName,
    required this.isValidDesignation,
    required this.isValidExperience,
  });
}

class WorkExperienceSuccessState extends EditProfileState {}
