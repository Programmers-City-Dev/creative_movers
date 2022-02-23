// To parse this JSON data, do
//
//     final media = mediaFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';

Media mediaFromJson(String str) => Media.fromJson(json.decode(str));

String mediaToJson(Media data) => json.encode(data.toJson());

class Media {
  Media({
    this.type,
    this.file,
  });

  String? type;
  MultipartFile? file;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "file": file,
      };
}
