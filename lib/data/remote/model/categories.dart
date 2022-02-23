// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) => CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) => json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    this.status,
    this.category,
  });

  String? status;
  List<String>? category;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => CategoriesResponse(
    status: json["status"],
    category: List<String>.from(json["category"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "category": List<dynamic>.from(category!.map((x) => x)),
  };
}
