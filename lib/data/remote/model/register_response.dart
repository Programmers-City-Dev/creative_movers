// To parse this JSON data, do
//
//     final authResponse = authResponseFromMap(jsonString);

import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/account_type_response.dart';
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
  User(
      {required this.id,
      this.firstname,
      this.lastname,
      required this.username,
      required this.email,
      required this.phone,
      this.dob,
      this.emailVerifiedAt,
      this.role,
      this.payStatus,
      this.regStatus,
      required this.currentTeamId,
      this.profilePhotoPath,
      this.coverPhotoPath,
      this.biodata,
      this.createdAt,
      this.updatedAt,
      this.apiToken,
      this.countryId,
      this.followers,
      this.following,
      this.connections,
      this.country,
      this.state,
      this.dateOfbirth,
      this.ethnicity,
      this.gender});

  final int id;
  final String? firstname;
  final String? lastname;
  final String username;
  final String email;
  final String? phone;
  final String? gender;
  final DateTime? dob;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? payStatus;
  final String? regStatus;
  final String? currentTeamId;
  final String? profilePhotoPath;
  final String? biodata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateOfbirth;
  final String? apiToken;
  final String? coverPhotoPath;
  final dynamic countryId;
  final List<dynamic>? followers;
  final List<dynamic>? following;
  final List<dynamic>? connections;
  final String? country;
  final String? state;
  final String? ethnicity;

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? phone,
    DateTime? dob,
    DateTime? emailVerifiedAt,
    String? role,
    String? payStatus,
    String? regStatus,
    String? gender,
    String? currentTeamId,
    String? profilePhotoPath,
    String? biodata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? apiToken,
    String? coverPhotoPath,
    dynamic countryId,
    List<dynamic>? followers,
    List<dynamic>? following,
    List<Connect>? connections,
    String? country,
    String? state,
    String? ethnicity,
  }) =>
      User(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
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
        coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
        countryId: countryId ?? this.countryId,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        connections: connections ?? this.connections,
        country: country ?? this.country,
        state: country ?? this.state,
        ethnicity: ethnicity ?? this.ethnicity,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"],
        gender: json["gender"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
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
        coverPhotoPath:
            json["cover_photo_path"] == null ? null : json["cover_photo_path"],
        countryId: json["country_id"],
        followers: json["followers"] == null
            ? null
            : List<dynamic>.from(json["followers"].map((x) => x)),
        // following: json["following"] == null ?null : List<dynamic>.from(json["following"].map((x) => x)),
        connections: json["connections"] == null
            ? null
            : List<dynamic>.from(json["connections"].map((x) => x)),
        country: json["country"] == null ? null : json["country"],
        state: json["state"] == null ? null : json["state"],
        ethnicity: json["ethnicity"] == null ? null : json["ethnicity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone,
        "gender": gender,
        "dob": dob == null ? null : dob!.toIso8601String(),
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
        "cover_photo_path": coverPhotoPath == null ? null : coverPhotoPath,
        "country_id": countryId,
        "followers": followers == null
            ? null
            : List<dynamic>.from(followers!.map((x) => x)),
        "following": following == null
            ? null
            : List<dynamic>.from(following!.map((x) => x)),
        "connections": connections == null
            ? null
            : List<dynamic>.from(connections!.map((x) => x)),
        "country": country,
        "state": state,
        "ethnicity": ethnicity,
      };

  CachedUser toCachedUser() {
    return CachedUser.fromMap(toMap());
  }
}
