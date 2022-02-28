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
    videoPlayerController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  Future<ChewieController> _initControllers() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
    );
    return _chewieController!;
  }

// final videoPlayerController = VideoPlayerController.network(
//      widget.videoUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<ChewieController>(
          future: _initControllers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Chewie(
                controller: snapshot.data!,
              );
            }
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
