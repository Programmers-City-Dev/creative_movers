import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewer extends StatelessWidget {
  final String imageUrl;
  final bool? tightMode;
  final String? heroTag;

  const ImagePreviewer(
      {Key? key, required this.imageUrl, this.tightMode, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      // backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      imageProvider: CachedNetworkImageProvider(imageUrl),
      heroAttributes: PhotoViewHeroAttributes(tag: heroTag ?? ""),
      basePosition: Alignment.center,
      tightMode: tightMode,
      errorBuilder: (context, object, stackTrace) => const Center(
        child: Text('Error loading image'),
      ),
    );
  }
}
