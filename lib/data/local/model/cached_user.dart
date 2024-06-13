// To parse this JSON data, do
//
//     final cachedUser = cachedUserFromMap(jsonString);
import 'package:equatable/equatable.dart';

class CachedUser extends Equatable {
  const CachedUser({
    required this.id,
    required this.accountType,
    this.firstname,
    this.lastname,
    this.username,
    this.gender,
    this.ethnicity,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.role,
    this.payStatus,
    this.regStatus,
    this.currentTeamId,
    this.profilePhotoPath,
    this.coverPhotoPath,
    this.biodata,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.dateOfBirth,
    this.apiToken,
    this.country,
    this.state,
    this.userActivityType,
  });

  final int id;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
  final String? accountType;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? payStatus;
  final String? regStatus;
  final String? currentTeamId;
  final String? profilePhotoPath;
  final String? coverPhotoPath;
  final String? biodata;
  final String? status;
  final String? gender;
  final String? ethnicity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? apiToken;
  final String? country;
  final String? state;
  final String? userActivityType;
  final DateTime? dateOfBirth;

  CachedUser copyWith(
          {int? id,
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
          String? coverPhotoPath,
          String? biodata,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? apiToken,
          String? country,
          String? state,
          String? gender,
          String? ethnicity,
          String? accountType,
          String? userActivityType,
          DateTime? dateOfBirth}) =>
      CachedUser(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        gender: gender ?? this.gender,
        accountType: accountType ?? this.accountType,
        ethnicity: ethnicity ?? this.ethnicity,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        role: role ?? this.role,
        payStatus: payStatus ?? this.payStatus,
        regStatus: regStatus ?? this.regStatus,
        currentTeamId: currentTeamId ?? this.currentTeamId,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
        biodata: biodata ?? this.biodata,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        apiToken: apiToken ?? this.apiToken,
        country: country ?? this.country,
        state: state ?? this.state,
        userActivityType: userActivityType ?? this.userActivityType,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );

  factory CachedUser.fromMap(Map<String, dynamic> json) => CachedUser(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        ethnicity: json["ethnicity"],
        accountType: json["account_type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        role: json["role"],
        payStatus: json["pay_status"],
        regStatus: json["reg_status"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"],
        coverPhotoPath: json["cover_photo_path"],
        biodata: json["biodata"],
        userActivityType: json["user_activity_type"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        apiToken: json["api_token"],
        dateOfBirth: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "phone": phone,
        "gender": gender,
        "ethnicity": ethnicity,
        "account_type": accountType,
        "email_verified_at":
            emailVerifiedAt == null ? null : createdAt!.toIso8601String(),
        "role": role,
        "pay_status": payStatus,
        "reg_status": regStatus,
        "current_team_id": currentTeamId,
        "profile_photo_path": profilePhotoPath,
        "cover_photo_path": coverPhotoPath,
        "biodata": biodata,
        "status": status,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "api_token": apiToken,
        "dob": dateOfBirth == null ? null : dateOfBirth!.toIso8601String(),
        "country": country,
        "state": state,
        "user_activity_type": userActivityType,
      };

  String get fullname => '$firstname $lastname';

  @override
  List<Object?> get props => [
        id,
        firstname,
        lastname,
        username,
        email,
        phone,
        emailVerifiedAt,
        role,
        payStatus,
        regStatus,
        currentTeamId,
        profilePhotoPath,
        coverPhotoPath,
        biodata,
        status,
        createdAt,
        updatedAt,
        apiToken,
        country,
        state,
        accountType,
        userActivityType,
      ];
}
