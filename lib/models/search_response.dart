// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    required this.users,
  });

  List<Result> users;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        users: List<Result>.from(json["users"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.role,
    this.profilePhotoPath,
    required this.connected,
    required this.following,
    this.followers,
  });

  int id;
  String username;
  String firstname;
  String lastname;
  Role role;
  String? profilePhotoPath;
  bool connected;
  bool following;
  List<dynamic>? followers;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        role: roleValues.map[json["role"]]!,
        profilePhotoPath: json["profile_photo_path"],
        connected: json["connected"],
        following: json["following"],
        followers: List<dynamic>.from(json["followers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "role": roleValues.reverse![role],
        "profile_photo_path": profilePhotoPath,
        "connected": connected,
        "following": following,
        "followers": List<dynamic>.from(followers!.map((x) => x)),
      };
}

enum Role { MOVER, CREATIVE }

final roleValues = EnumValues({"creative": Role.CREATIVE, "mover": Role.MOVER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
