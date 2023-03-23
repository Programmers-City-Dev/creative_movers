import 'package:chewie/chewie.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> _durationNotifier =
      ValueNotifier<Duration>(Duration.zero);

  bool _showControls = true;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  Future<void> _initControllers() async {
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    );
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      _durationNotifier.value = _videoPlayerController.value.position;

      _isPlaying.value = _videoPlayerController.value.isPlaying;
    });
    setState(() {});

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        showOptions: false
        // autoInitialize: true,
        // enable caching by setting the placeholder to a cached network image
        // placeholder: CachedNetworkImage(
        //   imageUrl: widget.videoUrl,
        //   fit: BoxFit.cover,
        // ),
        // customControls:MaterialControls()
        // Center(
        //   child: GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         _showControls = !_showControls;
        //       });
        //     },
        //     child: _showControls
        //         ? AnimatedContainer(
        //             duration: const Duration(milliseconds: 300),
        //             decoration: const BoxDecoration(color: Colors.transparent),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   padding: const EdgeInsets.symmetric(
        //                       horizontal: 8, vertical: 12),
        //                   decoration: BoxDecoration(
        //                       gradient: _controlsGradient(bottom: true)),
        //                   child: Row(
        //                     children: [
        //                       IconButton(
        //                           onPressed: () {
        //                             Navigator.of(context).pop();
        //                           },
        //                           icon: const Icon(
        //                             Icons.close,
        //                             color: Colors.white,
        //                           )),
        //                     ],
        //                   ),
        //                 ),
        //                 ValueListenableBuilder<bool>(
        //                     valueListenable: _isPlaying,
        //                     builder: (context, isPlaying, child) {
        //                       return Expanded(
        //                         child: GestureDetector(
        //                           onTap: () {
        //                             if (isPlaying) {
        //                               _videoPlayerController.pause();
        //                             } else {
        //                               _videoPlayerController.play();
        //                             }
        //                           },
        //                           child: Container(
        //                               width: 50,
        //                               height: 50,
        //                               decoration: BoxDecoration(
        //                                   shape: BoxShape.circle,
        //                                   color: Colors.black.withOpacity(0.1)),
        //                               child: Icon(
        //                                 isPlaying
        //                                     ? Icons.pause
        //                                     : Icons.play_arrow,
        //                                 size: 50,
        //                                 color: Colors.white,
        //                               )),
        //                         ),
        //                       );
        //                     }),
        //                 ValueListenableBuilder<Duration>(
        //                     valueListenable: _durationNotifier,
        //                     builder: (context, duration, child) {
        //                       return Container(
        //                         height: 80,
        //                         decoration: BoxDecoration(
        //                             gradient: _controlsGradient(bottom: true)),
        //                         child: Column(
        //                           mainAxisAlignment: MainAxisAlignment.end,
        //                           children: [
        //                             Padding(
        //                               padding: const EdgeInsets.symmetric(
        //                                   horizontal: 24),
        //                               child: Row(
        //                                 children: [
        //                                   Text(
        //                                     _getCurrentDutation(duration),
        //                                     style: const TextStyle(
        //                                         color: Colors.white),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             Slider(
        //                                 value: _videoPlayerController
        //                                     .value.position.inMilliseconds
        //                                     .toDouble(),
        //                                 min: 0,
        //                                 max: _videoPlayerController
        //                                     .value.duration.inMilliseconds
        //                                     .toDouble(),
        //                                 activeColor: Colors.white,
        //                                 onChanged: (val) {
        //                                   setState(() {});
        //                                 })
        //                           ],
        //                         ),
        //                       );
        //                     }),
        //               ],
        //             ),
        //           )
        //         : const SizedBox.shrink(),
        //   ),
        // )
        );
  }

// final videoPlayerController = VideoPlayerController.network(
//      widget.videoUrl);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: _videoPlayerController.value.isInitialized
            ? Stack(
                children: [
                  AppBar(
                    backgroundColor: Colors.black.withOpacity(0.1),
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: Chewie(
                              controller: _chewieController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                color: AppColors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    ));
  }

  LinearGradient _controlsGradient({required bool bottom}) {
    return bottom
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.04),
                Colors.black.withOpacity(0.01),
              ])
        : LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.1),
              ]);
  }

  String _getCurrentDutation(Duration position) {
    final Duration duration = _videoPlayerController.value.duration;
    final String positionText = position.toString().split('.').first;
    final String durationText = duration.toString().split('.').first;
    return '$positionText / $durationText';
  }
}
