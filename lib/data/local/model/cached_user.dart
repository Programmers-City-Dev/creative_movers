// To parse this JSON data, do
//
//     final cachedUser = cachedUserFromMap(jsonString);
class CachedUser {
  CachedUser({
    required this.id,
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
  });

  final int id;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
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
          DateTime? dateOfBirth}) =>
      CachedUser(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        gender: gender ?? this.gender,
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
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );

  factory CachedUser.fromMap(Map<String, dynamic> json) => CachedUser(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        gender: json["gender"] == null ? null : json["gender"],
        ethnicity: json["ethnicity"] == null ? null : json["ethnicity"],
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
        coverPhotoPath:
            json["cover_photo_path"] == null ? null : json["cover_photo_path"],
        biodata: json["biodata"] == null ? null : json["biodata"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        apiToken: json["api_token"] == null ? null : json["api_token"],
        dateOfBirth: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        country: json["country"] == null ? null : json["country"],
        state: json["state"] == null ? null : json["state"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "gender": gender == null ? null : gender,
        "ethnicity": ethnicity == null ? null : ethnicity,
        "email_verified_at":
            emailVerifiedAt == null ? null : createdAt!.toIso8601String(),
        "role": role == null ? null : role,
        "pay_status": payStatus == null ? null : payStatus,
        "reg_status": regStatus == null ? null : regStatus,
        "current_team_id": currentTeamId,
        "profile_photo_path":
            profilePhotoPath == null ? null : profilePhotoPath,
        "cover_photo_path": coverPhotoPath == null ? null : coverPhotoPath,
        "biodata": biodata == null ? null : biodata,
        "status": status,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "api_token": apiToken == null ? null : apiToken,
        "dob": dateOfBirth == null ? null : dateOfBirth!.toIso8601String(),
        "country": country == null ? null : country,
        "state": state == null ? null : state,
      };

  String get fullname => '$firstname $lastname';
}
