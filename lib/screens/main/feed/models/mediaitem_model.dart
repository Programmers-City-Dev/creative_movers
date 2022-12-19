
enum MediaType { image, video,other }

class MediaItemModel {
  final MediaType mediaType;
  final String? path;

  MediaItemModel({
    required this.mediaType,
    required this.path,
  });
}
