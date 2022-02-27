import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

enum ImageType {
  asset,
  file,
  network,
}

class ImagePreviewer extends StatelessWidget {
  final String imageUrl;
  final bool? tightMode;
  final String? heroTag;
  final ImageType? imageType;

  const ImagePreviewer(
      {Key? key,
      required this.imageUrl,
      this.tightMode,
      this.heroTag,
      this.imageType = ImageType.network})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      // backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      imageProvider: imageType == ImageType.asset
          ? AssetImage(imageUrl)
          : imageType == ImageType.file
              ? FileImage(File(imageUrl)) as ImageProvider
              : CachedNetworkImageProvider(imageUrl),
      heroAttributes: PhotoViewHeroAttributes(tag: heroTag ?? ""),
      basePosition: Alignment.center,
      tightMode: tightMode,
      errorBuilder: (context, object, stackTrace) => const Center(
        child: Text('Error loading image'),
      ),
    );
  }
}
