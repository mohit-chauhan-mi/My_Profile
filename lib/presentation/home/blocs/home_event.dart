part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeGetUserDataEvent extends HomeEvent {}

class HomeDeleteWorkExperienceEvent extends HomeEvent {
  final int indexToDelete;

  HomeDeleteWorkExperienceEvent({
    required this.indexToDelete,
  });
}

class HomeUserImagePickedEvent extends HomeEvent {
  final PickedImage pickedImage;

  HomeUserImagePickedEvent({
    required this.pickedImage,
  });
}

class HomeCheckOnPhotosPermissionEvent extends HomeEvent {
  final bool showImagePicker;

  HomeCheckOnPhotosPermissionEvent({
    this.showImagePicker = false,
  });
}
