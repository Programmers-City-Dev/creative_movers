import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_preview_dialog.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../widget/image_previewer.dart';

class MediaDisplayItem extends StatefulWidget {
  const MediaDisplayItem({Key? key, required this.media}) : super(key: key);

  final Media media;

  @override
  _MediaDisplayItemState createState() => _MediaDisplayItemState();
}

class _MediaDisplayItemState extends State<MediaDisplayItem> {
  late final Future<String?> thumbnailData;

  final _thumbmnailKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    thumbnailData = _thumbnailData();
  }

  Future<String?> _thumbnailData() async {
    try {
      return VideoThumbnail.thumbnailFile(
        video: widget.media.mediaPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 300,
        maxHeight: 300,
        quality: 100,
      );
    } catch (e) {
      log("Wahala: $e");
      return null;
    }
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
            child: SizedBox(
              height: 250,
              child: CachedNetworkImage(
                imageUrl: widget.media.mediaPath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.black,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/pngs/image_bg_placeholder.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : FutureBuilder<String?>(
            key: _thumbmnailKey,
            future: thumbnailData,
            builder: (context, snapshot) {
              // log(widget.media.mediaPath);
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  return Stack(children: [
                    Stack(
                      children: [
                        Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          filterQuality: FilterQuality.high,
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => VideoPreview(
                                    videoUrl: widget.media.mediaPath)));
                      },
                      child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline_outlined,
                            color: AppColors.white,
                            size: 50,
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
            });
  }
}
