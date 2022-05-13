// To parse this JSON data, do
//
//     final getPageResponse = getPageResponseFromJson(jsonString);

import 'dart:convert';

import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';


GetPageResponse getPageResponseFromJson(String str) => GetPageResponse.fromJson(json.decode(str));

String getPageResponseToJson(GetPageResponse data) => json.encode(data.toJson());

class GetPageResponse {
  GetPageResponse({
    required this.status,
    this.page,
  });

  String status;
  BusinessPage? page;

  factory GetPageResponse.fromJson(Map<String, dynamic> json) => GetPageResponse(
    status: json["status"],
    page: BusinessPage.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page?.toJson(),
  };
}
