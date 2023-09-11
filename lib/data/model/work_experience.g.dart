// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_experience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) =>
    WorkExperience(
      companyName: json['companyName'] as String?,
      designation: json['designation'] as String?,
      experience: (json['experience'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WorkExperienceToJson(WorkExperience instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'designation': instance.designation,
      'experience': instance.experience,
    };
