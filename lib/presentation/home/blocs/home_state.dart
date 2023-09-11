part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeFailureState extends HomeState {
  final String message;

  HomeFailureState({required this.message});
}

class HomeGetUserDataState extends HomeState {}

class HomeDeleteWorkExperienceSuccessState extends HomeState {
  HomeDeleteWorkExperienceSuccessState();
}

class HomeUserImagePickedState extends HomeState {
  final PickedImage pickedImage;

  HomeUserImagePickedState({
    required this.pickedImage,
  });
}

class HomePhotosPermissionState extends HomeState {
  final bool showImagePicker;
  final bool isError;

  HomePhotosPermissionState({
    this.showImagePicker = false,
    this.isError = false,
  });
}
