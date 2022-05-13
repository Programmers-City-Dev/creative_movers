// To parse this JSON data, do
//
//     final feedsResponse = feedsResponseFromJson(jsonString);

import 'dart:convert';

FeedsResponse feedsResponseFromJson(String str) =>
    FeedsResponse.fromJson(json.decode(str));

String feedsResponseToJson(FeedsResponse data) => json.encode(data.toJson());

class FeedsResponse {
  FeedsResponse({
    required this.status,
    required this.feeds,
  });

  String status;
  Feeds feeds;

  factory FeedsResponse.fromJson(Map<String, dynamic> json) => FeedsResponse(
        status: json["status"],
        feeds: Feeds.fromJson(json["feeds"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "feeds": feeds.toJson(),
      };
}

class Feeds {
  Feeds({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int currentPage;
  List<Feed> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Feeds.fromJson(Map<String, dynamic> json) => Feeds(
        currentPage: json["current_page"],
        data: List<Feed>.from(json["data"].map((x) => Feed.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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

class Feed {
  Feed(
      {required this.id,
      required this.type,
      required this.userId,
      this.pageId,
      this.content,
      required this.media,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.comments,
      required this.likes,
      required this.liked,
      this.user,
      this.page});

  int id;
  String type;
  String userId;
  dynamic pageId;
  String? content;
  List<Media> media;
  String status;
  bool liked;
  DateTime createdAt;
  DateTime updatedAt;
  List<Comment> comments;
  List<Like> likes;
  Poster? user;
  PostPage? page;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
      id: json["id"],
      type: json["type"],
      userId: json["user_id"],
      pageId: json["page_id"],
      content: json["content"],
      liked: json["liked"],
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      comments:
          List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
      likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
      user: Poster.fromJson(json["user"]),
      page: json["page"] == null ? null : PostPage.fromJson(json["page"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "user_id": userId,
        "page_id": pageId,
        "content": content,
        "liked": liked,
        "media": media == null
            ? null
            : List<dynamic>.from(media.map((x) => x.toJson())),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "user": user?.toJson(),
        "page": page == null ? null : page?.toJson(),
      };
}

class Comment {
  Comment(
      {required this.id,
      required this.userId,
      required this.comment,
      required this.feedId,
      this.createdAt,
      this.updatedAt,
      required this.user,
      this.shouldLoad});

  int id;
  String userId;
  String comment;
  String feedId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Poster user;
  bool? shouldLoad;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["user_id"],
        comment: json["comment"] == null ? null : json["comment"],
        feedId: json["feed_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: Poster.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "comment": comment == null ? null : comment,
        "feed_id": feedId,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "user": user.toJson(),
      };
}

class Like {
  Like({
    required this.id,
    required this.userId,
    required this.feedId,
    this.createdAt,
    this.updatedAt,
    required this.user,
  });

  int id;
  String userId;
  String feedId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Poster user;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        userId: json["user_id"],
        feedId: json["feed_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: Poster.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "feed_id": feedId,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "user": user.toJson(),
      };
}

class Media {
  Media({
    required this.type,
    required this.mediaPath,
  });

  String type;
  String mediaPath;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        mediaPath: json["mediaPath"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "mediaPath": mediaPath,
      };
}

class Poster {
  Poster({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.profilePhotoPath,
  });

  int id;
  String firstname;
  String lastname;
  String? profilePhotoPath;

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "profile_photo_path": profilePhotoPath,
      };
}

class Link {
  Link({
    this.url,
    required this.label,
    required this.active,
  });

  String? url;
  String label;
  bool active;

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

class PostPage {
  PostPage({
    required this.id,
    required this.name,
    required this.photoPath,
  });

  int id;
  String name;
  String? photoPath;

  factory PostPage.fromJson(Map<String, dynamic> json) => PostPage(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        photoPath: json["photo_path"] == null ? null : json["photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "photo_path": photoPath == null ? null : photoPath,
      };
}
