import 'dart:io';
import 'dart:typed_data';

import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPickerItem extends StatefulWidget {
  const VideoPickerItem(
      {Key? key, required this.path, this.onClose, this.onAdded, this.onPlay})
      : super(key: key);
  final String path;
  final VoidCallback? onClose;
  final VoidCallback? onAdded;
  final VoidCallback? onPlay;

  @override
  _VideoPickerItemState createState() => _VideoPickerItemState();
}

class _VideoPickerItemState extends State<VideoPickerItem> {
  // VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FutureBuilder<Uint8List?>(
                future: VideoThumbnail.thumbnailData(
                  video: widget.path,
                  imageFormat: ImageFormat.JPEG,
                  maxWidth: 128,
                  // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  quality: 25,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
                  }
                  return Image.asset("assets/images/slide_i.png",
                      fit: BoxFit.cover);
                })),
        decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage(AppIcons.imgSlide1)),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: 100,
        height: 150,
      ),
      Container(
        width: 100,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: widget.onClose,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.smokeWhite,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textColor,
                      size: 16,
                    )),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 100,
        height: 150,
        child: const Center(
          child: Icon(
            Icons.play_arrow,
            color: AppColors.primaryColor,
            size: 40,
          ),
        ),
      ),
    ]);
  }
}
