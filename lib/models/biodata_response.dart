
import 'dart:convert';

BioDataResponse bioDataResponseFromJson(String str) =>
    BioDataResponse.fromJson(json.decode(str));

String bioDataResponseToJson(BioDataResponse data) =>
    json.encode(data.toJson());

class BioDataResponse {
  BioDataResponse({
    required this.status,
    required this.category,
    required this.message,
  });

  String status;
  List<String> category;
  String message;

  factory BioDataResponse.fromJson(Map<String, dynamic> json) =>
      BioDataResponse(
        status: json["status"],
        category: List<String>.from(json["category"].map((x) => x)),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "category": List<dynamic>.from(category.map((x) => x)),
        "message": message,
      };
}
