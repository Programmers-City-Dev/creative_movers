import 'dart:io';

import 'package:creative_movers/screens/main/feed/models/mediaitem_model.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_picker_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'image_picker_item.dart';

class MediaItem extends StatefulWidget {
  const MediaItem({
    Key? key,
    required this.mediaItemModel,
    required this.onClose,
    required this.controller,
  }) : super(key: key);

  final MediaItemModel mediaItemModel;
  final VoidCallback onClose;
  final VideoPlayerController controller;

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  @override
  Widget build(BuildContext context) {
    return widget.mediaItemModel.mediaType == 'pictures'
        ? ImagePickerItem(
            image: widget.mediaItemModel.path,
            onClose: widget.onClose,
          )
        : VideoPickerItem(
            onClose: widget.onClose,
            path: widget.mediaItemModel.path!,
            // ),
          );
  }
}
