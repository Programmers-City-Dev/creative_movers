// To parse this JSON data, do
//
//     final media = mediaFromJson(jsonString);

import 'dart:convert';


MediaModel mediaFromJson(String str) => MediaModel.fromJson(json.decode(str));

String mediaToJson(MediaModel data) => json.encode(data.toJson());

class MediaModel {
  MediaModel({
    this.type,
    this.mediaPath,
  });

  String? type;
  String? mediaPath;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        type: json["type"],
        mediaPath: json["mediaPath"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "mediaPath": mediaPath,
      };
}
