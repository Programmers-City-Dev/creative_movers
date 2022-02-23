// To parse this JSON data, do
//
//     final media = mediaFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';

MediaModel mediaFromJson(String str) => MediaModel.fromJson(json.decode(str));

String mediaToJson(MediaModel data) => json.encode(data.toJson());

class MediaModel {
  MediaModel({
    this.type,
    this.file,
  });

  String? type;
  MultipartFile? file;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        type: json["type"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "file": file,
      };
}
