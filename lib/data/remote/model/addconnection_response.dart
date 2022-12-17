// To parse this JSON data, do
//
//     final addConnectionResponse = addConnectionResponseFromJson(jsonString);

import 'dart:convert';

AddConnectionResponse addConnectionResponseFromJson(String str) =>
    AddConnectionResponse.fromJson(json.decode(str));

String addConnectionResponseToJson(AddConnectionResponse data) =>
    json.encode(data.toJson());

class AddConnectionResponse {
  AddConnectionResponse({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory AddConnectionResponse.fromJson(Map<String, dynamic> json) =>
      AddConnectionResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
