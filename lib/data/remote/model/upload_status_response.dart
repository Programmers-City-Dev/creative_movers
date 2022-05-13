// To parse this JSON data, do
//
//     final uploadStatusResponse = uploadStatusResponseFromJson(jsonString);

import 'dart:convert';

UploadStatusResponse uploadStatusResponseFromJson(String str) => UploadStatusResponse.fromJson(json.decode(str));

String uploadStatusResponseToJson(UploadStatusResponse data) => json.encode(data.toJson());

class UploadStatusResponse {
  UploadStatusResponse({
    required this.status,
    required this.message,
    this.userStatus,
  });

  String status;
  String message;
  UserStatus? userStatus;

  factory UploadStatusResponse.fromJson(Map<String, dynamic> json) => UploadStatusResponse(
    status: json["status"],
    message: json["message"],
    userStatus: UserStatus.fromJson(json["user_status"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user_status": userStatus?.toJson(),
  };
}

class UserStatus {
  UserStatus({
    this.file,
    this.filePublicId,
    this.text,
    this.fontName,
    this.bgColor,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String? file;
  String? filePublicId;
  String? text;
  String? fontName;
  String? bgColor;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
    file: json["file"],
    filePublicId: json["file_public_id"],
    text: json["text"],
    fontName: json["font_name"],
    bgColor: json["bg_color"],
    userId: json["user_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "file": file,
    "file_public_id": filePublicId,
    "text": text,
    "font_name": fontName,
    "bg_color": bgColor,
    "user_id": userId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
