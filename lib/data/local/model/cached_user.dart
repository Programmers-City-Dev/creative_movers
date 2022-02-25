// To parse this JSON data, do
//
//     final cachedUser = cachedUserFromMap(jsonString);
class CachedUser {
  CachedUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phone,
    required this.emailVerifiedAt,
    required this.role,
    required this.payStatus,
    required this.regStatus,
    required this.currentTeamId,
    required this.profilePhotoPath,
    required this.coverPhotoPath,
    required this.biodata,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.apiToken,
  });

  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String phone;
  final DateTime? emailVerifiedAt;
  final String role;
  final String payStatus;
  final String regStatus;
  final String? currentTeamId;
  final String profilePhotoPath;
  final String? coverPhotoPath;
  final String biodata;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String apiToken;

  CachedUser copyWith({
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
    String? coverPhotoPath,
    String? biodata,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? apiToken,
  }) =>
      CachedUser(
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
        coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
        biodata: biodata ?? this.biodata,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        apiToken: apiToken ?? this.apiToken,
      );

  factory CachedUser.fromMap(Map<String, dynamic> json) => CachedUser(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        role: json["role"] == null ? null : json["role"],
        payStatus: json["pay_status"] == null ? null : json["pay_status"],
        regStatus: json["reg_status"] == null ? null : json["reg_status"],
        currentTeamId: json["current_team_id"],
        profilePhotoPath: json["profile_photo_path"] == null
            ? null
            : json["profile_photo_path"],
        coverPhotoPath: json["cover_photo_path"],
        biodata: json["biodata"] == null ? null : json["biodata"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        apiToken: json["api_token"] == null ? null : json["api_token"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "email_verified_at":
            emailVerifiedAt == null ? null : createdAt.toIso8601String(),
        "role": role == null ? null : role,
        "pay_status": payStatus == null ? null : payStatus,
        "reg_status": regStatus == null ? null : regStatus,
        "current_team_id": currentTeamId,
        "profile_photo_path":
            profilePhotoPath == null ? null : profilePhotoPath,
        "cover_photo_path": coverPhotoPath,
        "biodata": biodata == null ? null : biodata,
        "status": status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "api_token": apiToken == null ? null : apiToken,
      };
}
