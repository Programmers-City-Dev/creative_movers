// To parse this JSON data, do
//
//     final buisnessProfile = buisnessProfileFromJson(jsonString);

import 'dart:convert';

BuisnessProfile buisnessProfileFromJson(String str) =>
    BuisnessProfile.fromJson(json.decode(str));

String buisnessProfileToJson(BuisnessProfile data) =>
    json.encode(data.toJson());

class BuisnessProfile {
  BuisnessProfile({
    required this.profile,
  });

  Profile profile;

  factory BuisnessProfile.fromJson(Map<String, dynamic> json) =>
      BuisnessProfile(
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
        pages: List<BusinessPage>.from(
            json["pages"].map((x) => BusinessPage.fromJson(x))),
        investments: List<Investment>.from(
            json["investments"].map((x) => Investment.fromJson(x))),
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
  dynamic userId;
  dynamic maxRange;
  dynamic minRange;

  String stage;
  String category;
  DateTime createdAt;
  DateTime updatedAt;

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json["id"],
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

BusinessPage businessPageFromJson(String str) =>
    BusinessPage.fromJson(json.decode(str));

String businessPageToJson(BusinessPage data) => json.encode(data.toJson());

class BusinessPage {
  BusinessPage({
    required this.id,
    required this.userId,
    required this.name,
    required this.stage,
    required this.category,
    required this.estCapital,
    required this.description,
    this.website,
    this.contact,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
    required this.followers,
    required this.likes,
    this.isLiked,
    this.isFollowing,
  });

  int id;
  String userId;
  String name;
  String stage;
  List<String> category;
  String estCapital;
  String description;
  dynamic website;
  dynamic contact;
  String? photoPath;
  DateTime createdAt;
  DateTime updatedAt;
  List<Follower>? followers;
  List<Like>? likes;
  bool? isLiked;
  bool? isFollowing;

  factory BusinessPage.fromJson(Map<String, dynamic> json) => BusinessPage(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        stage: json["stage"],
        category: List<String>.from(json["category"].map((x) => x)),
        estCapital: json["est_capital"],
        description: json["description"],
        website: json["website"],
        contact: json["contact"],
        photoPath: json["photo_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        followers: json["followers"] != null
            ? List<Follower>.from(
                json["followers"].map((x) => Follower.fromJson(x)))
            : null,
        likes: json["followers"] != null
            ? List<Like>.from(json["likes"].map((x) => Like.fromJson(x)))
            : null,
        isLiked: json["is_liked"],
        isFollowing: json["is_following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "stage": stage,
        "category": List<dynamic>.from(category.map((x) => x)),
        "est_capital": estCapital,
        "description": description,
        "website": website,
        "contact": contact,
        "photo_path": photoPath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "followers": List<Follower>.from(followers!.map((x) => x.toJson())),
        "likes": List<dynamic>.from(likes!.map((x) => x.toJson())),
        "is_liked": isLiked,
        "is_following": isFollowing,
      };
}

class Follower {
  Follower({
    required this.id,
    required this.userId,
    required this.pageId,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.biodata,
    required this.profilePhotoPath,
  });

  int id;
  String userId;
  String pageId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic role;
  dynamic username;
  dynamic firstname;
  dynamic lastname;
  dynamic biodata;
  String profilePhotoPath;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        userId: json["user_id"],
        pageId: json["page_id"],
        createdAt: DateTime.parse(json["created_at"]),

        updatedAt: DateTime.parse(json["updated_at"]),
        role: json["role"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        biodata: json["biodata"],
        profilePhotoPath: json["profile_photo_path"]??'',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_id": pageId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "role": role,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "biodata": biodata,
        "profile_photo_path": profilePhotoPath,
      };
}

class Like {
  Like({
    required this.id,
    required this.userId,
    required this.pageId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String pageId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        userId: json["user_id"],
        pageId: json["page_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_id": pageId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
