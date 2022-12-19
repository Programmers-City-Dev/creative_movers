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
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
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
          ),
          Positioned(
            left: 16,
            top: 32,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
