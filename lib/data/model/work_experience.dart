import 'package:json_annotation/json_annotation.dart';

part 'work_experience.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkExperience {
  WorkExperience({
    this.companyName,
    this.designation,
    this.experience,
  });

  String? companyName;
  String? designation;
  double? experience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);
}
