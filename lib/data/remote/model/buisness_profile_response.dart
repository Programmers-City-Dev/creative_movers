// To parse this JSON data, do
//
//     final buisnessProfile = buisnessProfileFromJson(jsonString);

import 'dart:convert';

BuisnessProfile buisnessProfileFromJson(String str) => BuisnessProfile.fromJson(json.decode(str));

String buisnessProfileToJson(BuisnessProfile data) => json.encode(data.toJson());

class BuisnessProfile {
  BuisnessProfile({
    required this.profile,
  });

  Profile profile;

  factory BuisnessProfile.fromJson(Map<String, dynamic> json) => BuisnessProfile(
    profile: Profile.fromJson(json["user_page"]),
  );

  Map<String, dynamic> toJson() => {
    "profile": profile.toJson(),
  };
}

class Profile {
  Profile({
    required this.id,
    required this.profilePhotoPath,
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.biodata,
    required this.categories,
    required this.pages,
    required this.investments,
  });

  int id;
  String profilePhotoPath;
  String firstname;
  String lastname;
  String role;
  String biodata;
  List<String> categories;
  List<BusinessPage> pages;
  List<Investment> investments;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    profilePhotoPath: json["profile_photo_path"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    role: json["role"],
    biodata: json["biodata"],
    categories: List<String>.from(json["categories"].map((x) => x)),
    pages: List<BusinessPage>.from(json["pages"].map((x) =>BusinessPage.fromJson(x))),
    investments: List<Investment>.from(json["investments"].map((x) => Investment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_photo_path": profilePhotoPath,
    "firstname": firstname,
    "lastname": lastname,
    "role": role,
    "biodata": biodata,
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "pages": List<dynamic>.from(pages.map((x) => x)),
    "investments": List<dynamic>.from(investments.map((x) => x.toJson())),
  };
}

class Investment {
  Investment({
    required this.id,
    required this.userId,
    required this.maxRange,
    required this.minRange,
    required this.stage,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String maxRange;
  String minRange;
  String stage;
  String category;
  DateTime createdAt;
  DateTime updatedAt;

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
    id: json["id"]!= null?json["id"]:null,
    userId: json["user_id"],
    maxRange: json["max_range"],
    minRange: json["min_range"],
    stage: json["stage"],
    category: json["category"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "max_range": maxRange,
    "min_range": minRange,
    "stage": stage,
    "category": category,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
class BusinessPage {
  BusinessPage({
    required this.id,
    required this.userId,
    required this.name,
    required this.stage,
    required this.category,
    required this.estCapital,
    required this.description,
     this.photoPath,
    this.contact,
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String name;
  String stage;
  List<String> category;
  String estCapital;
  String description;
  String? photoPath;
  DateTime createdAt;
  DateTime updatedAt;
  String? website;
  String? contact;

  factory BusinessPage.fromJson(Map<String, dynamic> json) => BusinessPage(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    stage: json["stage"],
    category: List<String>.from(json["category"].map((x) => x)),
    estCapital: json["est_capital"],
    description: json["description"],
    photoPath: json["photo_path"],
    website: json["website"] == null ? null : json["website"],
    contact: json["contact"] == null ? null : json["contact"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "stage": stage,
    "category": category,
    "est_capital": estCapital,
    "description": description,
    "photo_path": photoPath,
    "website": website == null ? null : website,
    "contact": contact == null ? null : contact,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

