import 'dart:io';

import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ImagePickerItem extends StatefulWidget {
  const ImagePickerItem({Key? key, this.image, this.onClose}) : super(key: key);
  final String? image;
  final VoidCallback? onClose;

  @override
  _ImagePickerItemState createState() => _ImagePickerItemState();
}

class _ImagePickerItemState extends State<ImagePickerItem> {
  // List<String> Images
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(widget.image!),
              fit: BoxFit.cover,
            )),
        decoration: BoxDecoration(
          // image: DecorationImage(image:  AssetImage(AppIcons.imgSlide1)),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: 100,
        height: 150,
      ),
      InkWell(
        onTap: widget.onClose,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.smokeWhite,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textColor,
                size: 16,
              )),
        ),
      )
    ]);
  }
}
