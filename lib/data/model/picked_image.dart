import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'dart:developer' as dev;

import 'package:json_annotation/json_annotation.dart';

part 'picked_image.g.dart';

@JsonSerializable(explicitToJson: true)
class PickedImage {
  final String imageName;
  final String base64ImageBytes;

  PickedImage(
    this.imageName,
    this.base64ImageBytes,
  );

  static Future<PickedImage?> fromXFile(XFile file) async {
    try {
      return PickedImage(
        file.name,
        base64Encode(
          await file.readAsBytes(),
        ),
      );
    } on Exception catch (e) {
      dev.log('error : ${e.toString()}');
    }
    return null;
  }

  factory PickedImage.fromJson(Map<String, dynamic> json) =>
      _$PickedImageFromJson(json);

  Map<String, dynamic> toJson() => _$PickedImageToJson(this);
}
