import 'dart:typed_data';

import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_preview_dialog.dart';
import 'package:creative_movers/screens/main/status/widgets/status_video_play.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
class StatusVideoPreview extends StatefulWidget {
  const StatusVideoPreview({Key? key, required this.path, this.onClose, this.onAdded, this.onPlay}) : super(key: key);
  final String path;
  final VoidCallback? onClose;
  final VoidCallback? onAdded;
  final VoidCallback? onPlay;

  @override
  _StatusVideoPreviewState createState() => _StatusVideoPreviewState();
}

class _StatusVideoPreviewState extends State<StatusVideoPreview> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(children: [
          Center(
            child: Container(
              height: 300,
              width:  MediaQuery.of(context).size.width,
              child: FutureBuilder<Uint8List?>(
                  future: VideoThumbnail.thumbnailData(
                    video: widget.path,
                    imageFormat: ImageFormat.JPEG,
                    maxWidth: MediaQuery.of(context).size.width.toInt(),
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
                  }),
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage(AppIcons.imgSlide1)),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),

            ),
          ),

           Center(
            child: IconButton(
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primaryColor,
                size: 60,
              ), onPressed: () { showDialog(context: context, builder: (context) => StatusVideoPlay(videoUrl:widget.path)); },
            ),
          ),
        ]),
      ),
    );
  }
}
