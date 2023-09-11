// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      workExperiences: (json['workExperiences'] as List<dynamic>?)
          ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRememberedMe: json['isRememberedMe'] as bool?,
      isLoggedIn: json['isLoggedIn'] as bool?,
    )..userImage = json['userImage'] == null
        ? null
        : PickedImage.fromJson(json['userImage'] as Map<String, dynamic>);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'skills': instance.skills,
      'workExperiences':
          instance.workExperiences?.map((e) => e.toJson()).toList(),
      'isRememberedMe': instance.isRememberedMe,
      'isLoggedIn': instance.isLoggedIn,
      'userImage': instance.userImage?.toJson(),
    };
