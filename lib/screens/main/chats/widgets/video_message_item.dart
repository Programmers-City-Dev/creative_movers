import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../feed/widgets/video_preview_dialog.dart';

class VideoMessageItem extends StatefulWidget {
  const VideoMessageItem({Key? key, required this.chatMessage})
      : super(key: key);
  final Message chatMessage;

  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  Future<Uint8List?> getThumbnail() async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: widget.chatMessage.media[0].mediaPath!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        maxHeight: 300,
        quality: 100,
      );
    } catch (e) {
      log("Error generating thumbnail: $e");
      return null;
    }
  }

  late final Future<Uint8List?> thumbnailData;
  @override
  void initState() {
    super.initState();
    thumbnailData = getThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder<Uint8List?>(
            future: thumbnailData,
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
                            builder: (context) => VideoPreview(
                                videoUrl:
                                    widget.chatMessage.media[0].mediaPath!));
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
                      color: AppColors.white,
                      child: const Center(child: CircularProgressIndicator()));
                }
              } else {
                return Text(snapshot.error.toString());
              }
            }),
      ),
    );
  }
}
