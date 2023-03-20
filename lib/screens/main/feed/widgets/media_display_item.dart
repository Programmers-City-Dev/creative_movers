import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_preview_dialog.dart';
import 'package:creative_movers/screens/widget/video_thumbnail_builder.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../widget/image_previewer.dart';

class MediaDisplayItem extends StatefulWidget {
  const MediaDisplayItem({Key? key, required this.media}) : super(key: key);

  final Media media;

  @override
  _MediaDisplayItemState createState() => _MediaDisplayItemState();
}

class _MediaDisplayItemState extends State<MediaDisplayItem> {
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
            child: CachedNetworkImage(
              imageUrl: widget.media.mediaPath,
              width: 250,
              fit: BoxFit.cover,
            ))
        : Stack(children: [
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: VideoThumnailBuilder(
                videoUrl: widget.media.mediaPath,
                builder: (context, imageUrl) {
                  return Image.memory(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                },
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
                    Icons.play_circle_outline_outlined,
                    color: AppColors.white,
                    size: 45,
                  ),
                ),
              ),
            ),
          ]);
  }
}
