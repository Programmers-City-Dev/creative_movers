// To parse this JSON data, do
//
//     final viewStatusResponse = viewStatusResponseFromJson(jsonString);

import 'dart:convert';

ViewStatusResponse viewStatusResponseFromJson(String str) => ViewStatusResponse.fromJson(json.decode(str));

String viewStatusResponseToJson(ViewStatusResponse data) => json.encode(data.toJson());

class ViewStatusResponse {
  ViewStatusResponse({
    required this.status,
    required this.activeStatus,
    required this.otherStatus,
  });

  String status;
  Status? activeStatus;
  List<Status> otherStatus;

  factory ViewStatusResponse.fromJson(Map<String, dynamic> json) => ViewStatusResponse(
    status: json["status"],
    activeStatus: Status.fromJson(json["active_status"]),
    otherStatus: List<Status>.from(json["other_status"].map((x) => Status.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "active_status": activeStatus?.toJson(),
    "other_status": List<dynamic>.from(otherStatus.map((x) => x.toJson())),
  };
}

class Status {
  Status({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.status,
    required this.profilePhotoPath,


  });

  int id;
  String firstname;
  String lastname;
  String profilePhotoPath;

  List<StatusElement> status;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    profilePhotoPath: json["profile_photo_path"],
    status: List<StatusElement>.from(json["status"].map((x) => StatusElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "status": List<dynamic>.from(status.map((x) => x.toJson())),
    "profile_photo_path": profilePhotoPath,
  };
}

class StatusElement {
  StatusElement({
    required this.id,
    required this.userId,
     this.file,
     this.mediaType,
    required this.filePublicId,
     this.text,
     this.bgColor,
     this.fontName,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String? file;
  String? mediaType;
  String? filePublicId;
  String? text;
  String? bgColor;
  String? fontName;
  DateTime createdAt;
  DateTime updatedAt;

  factory StatusElement.fromJson(Map<String, dynamic> json) => StatusElement(
    id: json["id"],
    userId: json["user_id"],

    file: json["file"] == null ? null : json["file"],
    mediaType: json["media_type"],
    filePublicId: json["file_public_id"] == null ? null : json["file_public_id"],
    text: json["text"] == null ? null : json["text"],
    bgColor: json["bg_color"] == null ? null : json["bg_color"],
    fontName: json["font_name"] == null ? null : json["font_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "file": file == null ? null : file,
    "media_type": mediaType,
    "file_public_id": filePublicId == null ? null : filePublicId,
    "text": text == null ? null : text,
    "bg_color": bgColor == null ? null : bgColor,
    "font_name": fontName == null ? null : fontName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
