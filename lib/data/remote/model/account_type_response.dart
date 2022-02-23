// To parse this JSON data, do
//
//     final addTypeResponse = addTypeResponseFromJson(jsonString);

import 'dart:convert';

AccountTypeResponse addTypeResponseFromJson(String str) => AccountTypeResponse.fromJson(json.decode(str));

String addTypeResponseToJson(AccountTypeResponse data) => json.encode(data.toJson());

class AccountTypeResponse {
  AccountTypeResponse({
    this.status,
    required this.connect,
    this.userRole,
    this.message,
  });

  String? status;
  List<Connect> connect;
  UserRole? userRole;
  String? message;

  factory AccountTypeResponse.fromJson(Map<String, dynamic> json) => AccountTypeResponse(
    status: json["status"],
    connect: List<Connect>.from(json["connect"].map((x) => Connect.fromJson(x))),
    userRole: UserRole.fromJson(json["user_role"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "connect": List<dynamic>.from(connect.map((x) => x.toJson())),
    "user_role": userRole?.toJson(),
    "message": message,
  };
}

class Connect {
  Connect({
     this.id,
    this.username,
    this.firstname,
    this.lastname,
    required this.profilePhotoPath,
  });

  int? id;
  String? username;
  String? firstname;
  String? lastname;
  String profilePhotoPath;

  factory Connect.fromJson(Map<String, dynamic> json) => Connect(
    id: json["id"],
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    profilePhotoPath: json["profile_photo_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "profile_photo_path": profilePhotoPath,
  };
}

class UserRole {
  UserRole({
    this.role,
  });

  String? role;

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "role": role,
  };
}
