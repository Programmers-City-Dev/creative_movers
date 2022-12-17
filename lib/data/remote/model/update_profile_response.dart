import 'dart:convert';

import 'package:creative_movers/data/remote/model/register_response.dart';

UpdateProfileResponse updateProfileResponseFromJson(String str) =>
    UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) =>
    json.encode(data.toJson());

class UpdateProfileResponse {
  UpdateProfileResponse({
    required this.status,
    required this.user,
    required this.message,
  });

  String status;
  User user;
  String message;

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        status: json["status"],
        user: User.fromMap(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user.toMap(),
        "message": message,
      };
}
