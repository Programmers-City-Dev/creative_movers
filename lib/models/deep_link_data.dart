class DeepLinkData {
  String? title;
  String? message;
  String? type;
  String? path;
  int? id;
  Map<String, dynamic>? data;

  DeepLinkData(
      {this.type, this.path, this.id, this.title, this.message, this.data});

  DeepLinkData copyWith({
    String? title,
    String? message,
    String? type,
    String? path,
    int? id,
    Map<String, dynamic>? data,
  }) {
    return DeepLinkData(
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      path: path ?? this.path,
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'DeepLinkData{title: $title, '
        'message: $message, type: $type, path: $path, id: $id, data: $data}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeepLinkData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          message == other.message &&
          type == other.type &&
          path == other.path &&
          id == other.id &&
          data == other.data);

  @override
  int get hashCode =>
      title.hashCode ^
      message.hashCode ^
      type.hashCode ^
      path.hashCode ^
      data.hashCode ^
      id.hashCode;

  factory DeepLinkData.fromMap(Map<String, dynamic> map) {
    return DeepLinkData(
        title: map['title'],
        message: map['message'],
        type: map['type'] as String?,
        path: map['path'] as String?,
        data: map['other_params'] as Map<String, dynamic>?,
        id: map['id'] == null ? null : int.parse(map['id'].toString()));
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'path': path,
      'id': id,
      'data': data,
    };
  }
}
