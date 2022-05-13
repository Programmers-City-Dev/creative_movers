// To parse this JSON data, do
//
//     final paymentHistoryResponse = paymentHistoryResponseFromMap(jsonString);

// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, prefer_null_aware_operators

import 'dart:convert';

PaymentHistoryResponse paymentHistoryResponseFromMap(String str) => PaymentHistoryResponse.fromMap(json.decode(str));

String paymentHistoryResponseToMap(PaymentHistoryResponse data) => json.encode(data.toMap());

class PaymentHistoryResponse {
    PaymentHistoryResponse({
        required this.status,
        this.user,
    });

    final String status;
    final User? user;

    PaymentHistoryResponse copyWith({
        String? status,
        User? user,
    }) => 
        PaymentHistoryResponse(
            status: status ?? this.status,
            user: user ?? this.user,
        );

    factory PaymentHistoryResponse.fromMap(Map<String, dynamic> json) => PaymentHistoryResponse(
        status: json["status"] == null ? null : json["status"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "user": user == null ? null : user!.toMap(),
    };
}

class User {
    User({
        required this.id,
        this.firstname,
        this.lastname,
        required this.username,
        required this.email,
        required this.profilePhotoPath,
        this.coverPhotoPath,
        required this.paymentHistory,
    });

    final int id;
    final String? firstname;
    final String? lastname;
    final String username;
    final String email;
    final String profilePhotoPath;
    final String? coverPhotoPath;
    final List<PaymentHistory> paymentHistory;

    User copyWith({
        int? id,
        String? firstname,
        String? lastname,
        String? username,
        String? email,
        String? profilePhotoPath,
        String? coverPhotoPath,
        List<PaymentHistory>? paymentHistory,
    }) => 
        User(
            id: id ?? this.id,
            firstname: firstname ?? this.firstname,
            lastname: lastname ?? this.lastname,
            username: username ?? this.username,
            email: email ?? this.email,
            profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
            coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
            paymentHistory: paymentHistory ?? this.paymentHistory,
        );

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        profilePhotoPath: json["profile_photo_path"] == null ? null : json["profile_photo_path"],
        coverPhotoPath: json["cover_photo_path"],
        paymentHistory: json["payment_history"] == null ? [] : List<PaymentHistory>.from(json["payment_history"].map((x) => PaymentHistory.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "profile_photo_path": profilePhotoPath == null ? null : profilePhotoPath,
        "cover_photo_path": coverPhotoPath,
        "payment_history": paymentHistory == null ? null : List<dynamic>.from(paymentHistory.map((x) => x.toMap())),
    };
}

class PaymentHistory {
    PaymentHistory({
        required this.id,
        required this.orderId,
        required this.userEmail,
        required this.amount,
        required this.paymentFor,
        required this.duration,
        required this.status,
        required this.stripePid,
        required this.createdAt,
        required this.updatedAt,
    });

    final int id;
    final String orderId;
    final String userEmail;
    final String amount;
    final String paymentFor;
    final String duration;
    final String status;
    final String stripePid;
    final DateTime createdAt;
    final DateTime updatedAt;

    PaymentHistory copyWith({
        int? id,
        String? orderId,
        String? userEmail,
        String? amount,
        String? paymentFor,
        String? duration,
        String? status,
        String? stripePid,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        PaymentHistory(
            id: id ?? this.id,
            orderId: orderId ?? this.orderId,
            userEmail: userEmail ?? this.userEmail,
            amount: amount ?? this.amount,
            paymentFor: paymentFor ?? this.paymentFor,
            duration: duration ?? this.duration,
            status: status ?? this.status,
            stripePid: stripePid ?? this.stripePid,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory PaymentHistory.fromMap(Map<String, dynamic> json) => PaymentHistory(
        id: json["id"] == null ? null : json["id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        userEmail: json["user_email"] == null ? null : json["user_email"],
        amount: json["amount"] == null ? null : json["amount"],
        paymentFor: json["payment_for"] == null ? null : json["payment_for"],
        duration: json["duration"] == null ? null : json["duration"],
        status: json["status"] == null ? null : json["status"],
        stripePid: json["stripe_pid"] == null ? null : json["stripe_pid"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "order_id": orderId == null ? null : orderId,
        "user_email": userEmail == null ? null : userEmail,
        "amount": amount == null ? null : amount,
        "payment_for": paymentFor == null ? null : paymentFor,
        "duration": duration == null ? null : duration,
        "status": status == null ? null : status,
        "stripe_pid": stripePid == null ? null : stripePid,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}
