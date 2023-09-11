// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picked_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickedImage _$PickedImageFromJson(Map<String, dynamic> json) => PickedImage(
      json['imageName'] as String,
      json['base64ImageBytes'] as String,
    );

Map<String, dynamic> _$PickedImageToJson(PickedImage instance) =>
    <String, dynamic>{
      'imageName': instance.imageName,
      'base64ImageBytes': instance.base64ImageBytes,
    };
