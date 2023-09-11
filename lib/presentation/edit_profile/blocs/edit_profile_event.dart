part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {}

class EditProfileGetUserDataEvent extends EditProfileEvent {}

class EditFieldsUpdatedEvent extends EditProfileEvent {
  EditFieldsUpdatedEvent();
}

class EditFieldsValidEvent extends EditProfileEvent {
  final bool isValidEditField;

  EditFieldsValidEvent({required this.isValidEditField});
}

class EditProfileRequestEvent extends EditProfileEvent {
  final EditProfileType editProfileType;
  final String? newValue;
  final List<String>? skills;

  EditProfileRequestEvent({
    required this.editProfileType,
    this.newValue,
    this.skills,
  });
}

class EditProfileRemoveSkillEvent extends EditProfileEvent {
  final int indexToRemove;

  EditProfileRemoveSkillEvent({required this.indexToRemove});
}

class WorkExperienceValidEvent extends EditProfileEvent {
  final bool isValidCompanyName;
  final bool isValidDesignation;
  final bool isValidExperience;

  WorkExperienceValidEvent({
    required this.isValidCompanyName,
    required this.isValidDesignation,
    required this.isValidExperience,
  });
}

class WorkExperienceRequestEvent extends EditProfileEvent {
  final bool isUpdateWorkExperience;
  final String companyName;
  final String designation;
  final String experience;
  final int? workExperienceIndex;

  WorkExperienceRequestEvent({
    required this.isUpdateWorkExperience,
    required this.companyName,
    required this.designation,
    required this.experience,
    this.workExperienceIndex,
  });
}
