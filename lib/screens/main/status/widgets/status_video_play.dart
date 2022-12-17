import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StatusVideoPlay extends StatefulWidget {
  const StatusVideoPlay({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  _StatusVideoPlayState createState() => _StatusVideoPlayState();
}

class _StatusVideoPlayState extends State<StatusVideoPlay> {
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
    videoPlayerController = VideoPlayerController.file(File(widget.videoUrl));
    await videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
    );
    return _chewieController!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: FutureBuilder<ChewieController>(
          future: _initControllers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Chewie(
                controller: snapshot.data!,
              );
            }
            return Container(
              color: AppColors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
