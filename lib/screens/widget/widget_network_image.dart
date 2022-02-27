import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/helpers/app_images.dart';
import 'package:flutter/material.dart';

class WidgetNetworkImage extends StatelessWidget {
  /* 
   * Zubby J.: RE-USEABLE IMAGE WITH PLACEHOLDER
   */
  final String? image;
  final BoxFit? fit;
  final double? width, height;

  const WidgetNetworkImage({
    Key? key,
    @required this.image,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CachedNetworkImage(
          key: UniqueKey(),
          imageUrl: image ?? '',
          fit: fit,
          height: height ?? constraints.maxHeight,
          width: width ?? constraints.maxWidth,
          placeholder: (context, url) => getPlaceHolder(constraints),
          errorWidget: (context, url, error) => getPlaceHolder(constraints),
        );
      },
    );
  }

  Widget getPlaceHolder(BoxConstraints constraints) {
    return Image.asset(
      AppImages.imagePlaceHolder,
      fit: fit,
      height: height ?? constraints.maxHeight,
      width: width ?? constraints.maxWidth,
    );
  }
}
