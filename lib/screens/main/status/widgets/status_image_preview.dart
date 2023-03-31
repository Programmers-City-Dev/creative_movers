import 'dart:io';

import 'package:flutter/material.dart';

class StatusImagePreview extends StatefulWidget {
  const StatusImagePreview({Key? key, this.image, this.onClose}) : super(key: key);
  final String? image;
  final VoidCallback? onClose;

  @override
  _StatusImagePreviewState createState() => _StatusImagePreviewState();
}

class _StatusImagePreviewState extends State<StatusImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // image: DecorationImage(image:  AssetImage(AppIcons.imgSlide1)),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.file(
          File(widget.image!),
          fit: BoxFit.cover,
        ),

      ),
    );
  }
}
