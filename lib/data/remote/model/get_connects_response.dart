// To parse this JSON data, do
//
//     final fetchConnectionResponse = fetchConnectionResponseFromJson(jsonString);

import 'dart:convert';

FetchConnectionResponse fetchConnectionResponseFromJson(String str) =>
    FetchConnectionResponse.fromJson(json.decode(str));

String fetchConnectionResponseToJson(FetchConnectionResponse data) =>
    json.encode(data.toJson());

class FetchConnectionResponse {
  FetchConnectionResponse({
    required this.connections,
  });

  Connections connections;

  factory FetchConnectionResponse.fromJson(Map<String, dynamic> json) =>
      FetchConnectionResponse(
        connections: Connections.fromJson(json["connections"]),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections.toJson(),
      };
}

class Connections {
  Connections({
    required this.currentPage,
    required this.connectionList,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  int currentPage;
  List<Connection> connectionList;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int total;

  factory Connections.fromJson(Map<String, dynamic> json) => Connections(
        currentPage: json["current_page"],
        connectionList: List<Connection>.from(
            json["data"].map((x) => Connection.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(connectionList.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Connection {
  Connection(
      {this.id,
      this.myId,
      required this.user_connect_id,
      required this.userId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.username,
      required this.role,
      required this.firstname,
      required this.lastname,
      required this.profilePhotoPath,
      required this.connects,
      this.conversationId});

  int? id;
  String? myId;
  String userId;
  int user_connect_id;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String username;
  String role;
  String firstname;
  String lastname;
  int? conversationId;
  String profilePhotoPath;
  List<Connect> connects;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json["id"],
        myId: json["my_id"],
        user_connect_id: json["user_connect_id"],
        userId: json["user_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        role: json["role"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        conversationId: json["conversation_id"],
        connects: List<Connect>.from(
            json["connects"].map((x) => Connect.fromJson(x))),
        profilePhotoPath: json["profile_photo_path"],
      );

  String get fullName => '$firstname $lastname';

  Map<String, dynamic> toJson() => {
        "id": id,
        "my_id": myId,
        "user_id": userId,
        "user_connect_id": user_connect_id,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "username": username,
        "role": role,
        "firstname": firstname,
        "lastname": lastname,
        "profile_photo_path": profilePhotoPath,
        "conversation_id": conversationId,
        "connects": List<dynamic>.from(connects.map((x) => x.toJson())),
      };
}

class Connect {
  Connect({
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.profilePhotoPath,
  });

  String firstname;
  String lastname;
  String role;
  String profilePhotoPath;

  factory Connect.fromJson(Map<String, dynamic> json) => Connect(
        firstname: json["firstname"],
        lastname: json["lastname"],
        role: json["role"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "role": role,
        "profile_photo_path": profilePhotoPath,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
