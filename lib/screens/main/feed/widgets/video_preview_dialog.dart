import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize();
  _chewieController =  ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
    ) ;
    super.initState();
  }

// final videoPlayerController = VideoPlayerController.network(
//      widget.videoUrl);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Chewie(
          controller:_chewieController!,
        ),
      ),
    );
  }
}
