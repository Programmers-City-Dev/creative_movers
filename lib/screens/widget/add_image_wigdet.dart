// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget(
      {Key? key,
      this.imageBgradius = 70,
      this.imageRadius = 65,
      this.iconBgRadius = 25,
      this.iconRadius = 22,
      this.iconSize = 24,
      this.iconBgCOlor = AppColors.primaryColor,
      this.imagePath,
      this.onUpload})
      : super(key: key);
  final double imageBgradius;
  final double imageRadius;
  final double iconBgRadius;
  final double iconRadius;
  final double iconSize;
  final Color iconBgCOlor;
  final String? imagePath;
  final VoidCallback? onUpload;

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: CircleAvatar(
            radius: widget.imageRadius,
            child: widget.imagePath == null
                ? null
                : Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
          ),
        ),
        Positioned(
          right: -5,
          bottom: 7,
          child: InkWell(
            onTap: widget.onUpload,
            child: CircleAvatar(
              radius: widget.iconBgRadius,
              backgroundColor: AppColors.lightBlue,
              child: CircleAvatar(
                radius: widget.iconRadius,
                backgroundColor: widget.iconBgCOlor,
                child: Icon(
                  Icons.photo_camera_rounded,
                  size: widget.iconSize,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
