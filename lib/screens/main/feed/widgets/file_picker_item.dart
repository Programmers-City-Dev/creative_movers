
import 'package:creative_movers/theme/app_colors.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';

class FilePickerItem extends StatefulWidget {
  const FilePickerItem({Key? key, this.filePath, this.onClose})
      : super(key: key);
  final String? filePath;
  final VoidCallback? onClose;

  @override
  State<FilePickerItem> createState() => _FilePickerItemState();
}

class _FilePickerItemState extends State<FilePickerItem> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = p.extension(widget.filePath.toString());

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image:  AssetImage(AppIcons.imgSlide1)),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: 100,
        height: 150,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Text(fileExtension.replaceFirst('.', '').toUpperCase()),
            )),
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
