import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:creative_movers/models/media.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaDisplayItem extends StatefulWidget {
  const MediaDisplayItem({Key? key, required this.media}) : super(key: key);

  final MediaModel media;

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
        // _controller?.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.media.type == 'image'
        ? Container(
            height: 250,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://thegadgetflow.com/wp-content/uploads/2021/03/20-Cool-gadgets-to-add-to-your-2021-wish-list-featured-1200x675.jpeg',
                    ))),
          )
        : FutureBuilder<Uint8List?>(
            future: VideoThumbnail.thumbnailData(
              video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              imageFormat: ImageFormat.PNG,
              maxWidth: 128,
              // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
              quality: 150,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                );
              }
              return Container(
                  color: Colors.black,
                  child: Center(child: CircularProgressIndicator()));
            });
  }
}
