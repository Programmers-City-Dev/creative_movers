// To parse this JSON data, do
//
//     final authResponse = authResponseFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AuthResponse authResponseFromMap(String str) =>
    AuthResponse.fromMap(json.decode(str));

String authResponseToMap(AuthResponse data) => json.encode(data.toMap());

class AuthResponse {
  AuthResponse({
    required this.status,
    required this.user,
    required this.message,
  });

  final String status;
  final User user;
  final String message;

  AuthResponse copyWith({
    String? status,
    User? user,
    String? message,
  }) =>
      AuthResponse(
        status: status ?? this.status,
        user: user ?? this.user,
        message: message ?? this.message,
      );

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        status: json["status"],
        user: User.fromMap(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "user": user == null ? null : user.toMap(),
        "message": message == null ? null : message,
      };
}

class User {
  User({
    required this.id,
    this.firstname,
    this.lastname,
    required this.username,
    required this.email,
    required this.phone,
    this.emailVerifiedAt,
    this.role,
    this.payStatus,
    this.regStatus,
    required this.currentTeamId,
    this.profilePhotoPath,
    this.biodata,
    this.createdAt,
    this.updatedAt,
    this.apiToken,
    this.profilePhotoUrl,
  });

  final int id;
  final String? firstname;
  final String? lastname;
  final String username;
  final String email;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? payStatus;
  final String? regStatus;
  final String? currentTeamId;
  final String? profilePhotoPath;
  final String? biodata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? apiToken;
  final String? profilePhotoUrl;

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? phone,
    DateTime? emailVerifiedAt,
    String? role,
    String? payStatus,
    String? regStatus,
    String? currentTeamId,
    String? profilePhotoPath,
    String? biodata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? apiToken,
    String? profilePhotoUrl,
  }) =>
      User(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        role: role ?? this.role,
        payStatus: payStatus ?? this.payStatus,
        regStatus: regStatus ?? this.regStatus,
        currentTeamId: currentTeamId ?? this.currentTeamId,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        biodata: biodata ?? this.biodata,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        apiToken: apiToken ?? this.apiToken,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        role: json["role"],
        payStatus: json["pay_status"] == null ? null : json["pay_status"],
        regStatus: json["reg_status"] == null ? null : json["reg_status"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        biodata: json["biodata"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        apiToken: json["api_token"] == null ? null : json["api_token"],
        profilePhotoUrl: json["profile_photo_url"] == null
            ? null
            : json["profile_photo_url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone,
        "email_verified_at":
            emailVerifiedAt == null ? null : emailVerifiedAt!.toIso8601String(),
        "role": role,
        "pay_status": payStatus == null ? null : payStatus,
        "reg_status": regStatus == null ? null : regStatus,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "biodata": biodata,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "api_token": apiToken == null ? null : apiToken,
        "profile_photo_url": profilePhotoUrl == null ? null : profilePhotoUrl,
      };
}
