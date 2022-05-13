// To parse this JSON data, do
//
//     final subscriptionResponse = subscriptionResponseFromMap(jsonString);

// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison, prefer_null_aware_operators

import 'dart:convert';

SubscriptionResponse subscriptionResponseFromMap(String str) =>
    SubscriptionResponse.fromMap(json.decode(str));

String subscriptionResponseToMap(SubscriptionResponse data) =>
    json.encode(data.toMap());

class SubscriptionResponse {
  SubscriptionResponse({
    required this.status,
    required this.user,
  });

  final String status;
  final SubscribedUser? user;

  SubscriptionResponse copyWith({
    String? status,
    SubscribedUser? user,
  }) =>
      SubscriptionResponse(
        status: status ?? this.status,
        user: user ?? this.user,
      );

  factory SubscriptionResponse.fromMap(Map<String, dynamic> json) =>
      SubscriptionResponse(
        status: json["status"] == null ? null : json["status"],
        user:
            json["user"] == null ? null : SubscribedUser.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "user": user == null ? null : user!.toMap(),
      };
}

class SubscribedUser {
  SubscribedUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.profilePhotoPath,
    required this.coverPhotoPath,
    required this.subscription,
  });

  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String? profilePhotoPath;
  final String? coverPhotoPath;
  final Subscription? subscription;

  SubscribedUser copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? profilePhotoPath,
    String? coverPhotoPath,
    Subscription? subscription,
  }) =>
      SubscribedUser(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        email: email ?? this.email,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
        subscription: subscription ?? this.subscription,
      );

  factory SubscribedUser.fromMap(Map<String, dynamic> json) => SubscribedUser(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        profilePhotoPath: json["profile_photo_path"] == null
            ? null
            : json["profile_photo_path"],
        coverPhotoPath:
            json["cover_photo_path"] == null ? null : json["cover_photo_path"],
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromMap(json["subscription"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "profile_photo_path":
            profilePhotoPath == null ? null : profilePhotoPath,
        "cover_photo_path": coverPhotoPath == null ? null : coverPhotoPath,
        "subscription": subscription == null ? null : subscription!.toMap(),
      };
}

class Subscription {
  Subscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.subType,
    required this.amount,
    required this.duration,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String userId;
  final String type;
  final String subType;
  final String amount;
  final String duration;
  final DateTime expiryDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription copyWith({
    int? id,
    String? userId,
    String? type,
    String? subType,
    String? amount,
    String? duration,
    DateTime? expiryDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Subscription(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        subType: subType ?? this.subType,
        amount: amount ?? this.amount,
        duration: duration ?? this.duration,
        expiryDate: expiryDate ?? this.expiryDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        type: json["type"] == null ? null : json["type"],
        subType: json["sub_type"] == null ? null : json["sub_type"],
        amount: json["amount"] == null ? null : json["amount"],
        duration: json["duration"] == null ? null : json["duration"],
        expiryDate: DateTime.parse(json["expiry_date"]),
        status: json["status"] == null ? null : json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "type": type == null ? null : type,
        "sub_type": subType == null ? null : subType,
        "amount": amount == null ? null : amount,
        "duration": duration == null ? null : duration,
        "expiry_date": expiryDate == null ? null : expiryDate.toIso8601String(),
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
