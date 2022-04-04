import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/app_images.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    this.url,
    this.radius,
    this.withBaseUrl = true,
    this.borderWidth = 0,
  }) : super(key: key);

  final String? url;
  final double? radius;
  final bool? withBaseUrl;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    double mRadius = radius != null ? radius! * 2 : 32;

    return Container(
      width: mRadius,
      height: mRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: borderWidth!,
        ),
      ),
      child: url != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: withBaseUrl! ? ApiConstants.BASE_URL + url! : url!,
                fit: BoxFit.cover,
                width: mRadius,
                height: mRadius,
                placeholder: (context, url) => SizedBox(
                  width: mRadius,
                  height: mRadius,
                  child: Shimmer.fromColors(
                    child: Container(
                      width: mRadius,
                      height: mRadius,
                    ),
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                    width: mRadius,
                    height: mRadius,
                    child: Image.asset(
                      AppImages.imagePlaceHolder,
                      fit: BoxFit.cover,
                    )),
              ),
            )
          : ClipOval(
              child: Image.asset(
                AppImages.imagePlaceHolder,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
