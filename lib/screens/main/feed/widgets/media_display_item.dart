import 'dart:typed_data';

import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_preview_dialog.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../widget/image_previewer.dart';

class MediaDisplayItem extends StatefulWidget {
  const MediaDisplayItem({Key? key, required this.media}) : super(key: key);

  final Media media;

  @override
  _MediaDisplayItemState createState() => _MediaDisplayItemState();
}

class _MediaDisplayItemState extends State<MediaDisplayItem> {
  VideoPlayerController? _controller;

  // final chewieController = ChewieController(
  //   videoPlayerController: _controller!,
  //   autoPlay: true,
  //   looping: true,
  // );
  @override
  void dispose() {
    // videoPlayerController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.media.type == 'image'
        ? GestureDetector(
            onTap: () => showDialog(
              context: context,
              // isDismissible: false,
              // enableDrag: false,
              barrierDismissible: true,
              builder: (context) => ImagePreviewer(
                imageUrl: widget.media.mediaPath,
                heroTag: "cover_photo",
                tightMode: true,
              ),
            ),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.media.mediaPath))),
            ),
          )
        : FutureBuilder<Uint8List?>(
            future: VideoThumbnail.thumbnailData(
              video: widget.media.mediaPath,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 300,
              maxHeight: 300,
              // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
              quality: 100,
            ),
            builder: (context, snapshot) {
              // log(widget.media.mediaPath);
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  return Stack(children: [
                    SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                VideoPreview(videoUrl: widget.media.mediaPath));
                      },
                      child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ]);
                } else {
                  return Container(
                      color: AppColors.black,
                      child: const Center(child: CircularProgressIndicator()));
                }
              } else {
                return Text(snapshot.error.toString());
              }
            });
  }
}
