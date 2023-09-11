import 'package:json_annotation/json_annotation.dart';

import 'picked_image.dart';
import 'work_experience.dart';

part 'user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  UserData({
    this.email,
    this.password,
    this.name,
    this.skills,
    this.workExperiences,
    this.isRememberedMe,
    this.isLoggedIn,
  });

  String? email;
  String? password;
  String? name;
  List<String>? skills;
  List<WorkExperience>? workExperiences;
  bool? isRememberedMe;
  bool? isLoggedIn;
  PickedImage? userImage;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
