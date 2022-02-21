import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

enum MediaType { image, video }

class MediaItemModel {
  final MediaType mediaType;
  final String? path;

  MediaItemModel({
    required this.mediaType,
    required this.path,
  });
}
