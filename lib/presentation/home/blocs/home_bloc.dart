import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constant/app_strings.dart';
import '../../../core/utils/secure_storage_utils.dart';
import '../../../data/model/picked_image.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  SecureStorageUtils secureStorageUtils;

  HomeBloc({
    required this.secureStorageUtils,
  }) : super(HomeInitial()) {
    on<HomeGetUserDataEvent>(_homeGetUserDataEvent);
    on<HomeDeleteWorkExperienceEvent>(_homeDeleteWorkExperienceEvent);
    on<HomeUserImagePickedEvent>(_homeUserImagePickedEvent);
    on<HomeCheckOnPhotosPermissionEvent>(_homeCheckOnPhotosPermissionEvent);
  }

  FutureOr<void> _homeGetUserDataEvent(
    HomeGetUserDataEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeGetUserDataState());
  }

  FutureOr<void> _homeDeleteWorkExperienceEvent(
    HomeDeleteWorkExperienceEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      secureStorageUtils.userData?.workExperiences
          ?.removeAt(event.indexToDelete);
      await secureStorageUtils.storeUserData();
      emit(HomeDeleteWorkExperienceSuccessState());
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
      emit(HomeFailureState(message: AppStrings.wentWrong));
    }
  }

  FutureOr<void> _homeUserImagePickedEvent(
    HomeUserImagePickedEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      secureStorageUtils.userData?.userImage = event.pickedImage;
      await secureStorageUtils.storeUserData();
      emit(HomeUserImagePickedState(pickedImage: event.pickedImage));
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
      emit(HomeFailureState(message: AppStrings.wentWrong));
    }
  }

  FutureOr<void> _homeCheckOnPhotosPermissionEvent(
    HomeCheckOnPhotosPermissionEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (await Permission.photos.request().isGranted) {
        emit(HomePhotosPermissionState(showImagePicker: event.showImagePicker));
      } else {
        emit(HomePhotosPermissionState(isError: true));
      }
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
      emit(HomeFailureState(message: AppStrings.wentWrong));
    }
  }
}
