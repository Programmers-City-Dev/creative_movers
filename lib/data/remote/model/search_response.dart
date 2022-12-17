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

  List<SearchResult> users;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        users: List<SearchResult>.from(
            json["users"].map((x) => SearchResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class SearchResult {
  SearchResult({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.role,
    this.profilePhotoPath,
    required this.connected,
    required this.following,
    required this.followers,
  });

  int id;
  String username;
  String firstname;
  String lastname;
  Role role;
  String? profilePhotoPath;
  String connected;
  bool following;
  List<Follower> followers;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        role: roleValues.map[json["role"]]!,
        profilePhotoPath: json["profile_photo_path"],
        connected: json["connected"],
        following: json["following"],
        followers: List<Follower>.from(
            json["followers"].map((x) => Follower.fromJson(x))),
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
        "followers": List<dynamic>.from(followers.map((x) => x)),
      };
}

enum Role { MOVER, CREATIVE }

final roleValues = EnumValues({"creative": Role.CREATIVE, "mover": Role.MOVER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Follower {
  Follower({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.profilePhotoPath,
  });

  int id;
  String firstname;
  String lastname;
  String role;
  String profilePhotoPath;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        role: json["role"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "role": role,
        "profile_photo_path": profilePhotoPath,
      };
}
