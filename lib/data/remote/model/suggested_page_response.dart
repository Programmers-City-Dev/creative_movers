// To parse this JSON data, do
//
//     final suggestedPageResponse = suggestedPageResponseFromJson(jsonString);

import 'dart:convert';

import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';

SuggestedPageResponse suggestedPageResponseFromJson(String str) =>
    SuggestedPageResponse.fromJson(json.decode(str));

String suggestedPageResponseToJson(SuggestedPageResponse data) =>
    json.encode(data.toJson());

class SuggestedPageResponse {
  SuggestedPageResponse({
    required this.status,
    required this.sugestedpages,
  });

  String status;
  List<BusinessPage> sugestedpages;

  factory SuggestedPageResponse.fromJson(Map<String, dynamic> json) =>
      SuggestedPageResponse(
        status: json["status"],
        sugestedpages: List<BusinessPage>.from(
            json["pages"].map((x) => BusinessPage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "pages": List<dynamic>.from(sugestedpages.map((x) => x.toJson())),
      };
}

class Sugestedpage {
  Sugestedpage({
    required this.id,
    required this.userId,
    required this.name,
    this.stage,
    required this.category,
    required this.estCapital,
    this.description,
    this.website,
    this.contact,
    this.photoPath,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  String name;
  Stage? stage;
  List<String> category;
  String estCapital;
  String? description;
  dynamic website;
  dynamic contact;
  String? photoPath;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Sugestedpage.fromJson(Map<String, dynamic> json) => Sugestedpage(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        stage: stageValues.map[json["stage"]],
        category: List<String>.from(json["category"].map((x) => x)),
        estCapital: json["est_capital"],
        description: json["description"],
        website: json["website"],
        contact: json["contact"],
        photoPath: json["photo_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "stage": stageValues.reverse[stage],
        "category": List<dynamic>.from(category.map((x) => x)),
        "est_capital": estCapital,
        "description": description,
        "website": website,
        "contact": contact,
        "photo_path": photoPath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum Stage { EXPANSION, PRE_SEED, START_UP, SEED }

final stageValues = EnumValues({
  "Expansion": Stage.EXPANSION,
  "Pre-seed": Stage.PRE_SEED,
  "Seed": Stage.SEED,
  "Start up": Stage.START_UP
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
