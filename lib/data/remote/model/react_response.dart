// To parse this JSON data, do
//
//     final reactResponse = reactResponseFromJson(jsonString);

import 'dart:convert';

ReactResponse reactResponseFromJson(String str) => ReactResponse.fromJson(json.decode(str));

String reactResponseToJson(ReactResponse data) => json.encode(data.toJson());

class ReactResponse {
  ReactResponse({
    required this.status,
    this.message
  });

  String status;
  String? message;

  factory ReactResponse.fromJson(Map<String, dynamic> json) => ReactResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
