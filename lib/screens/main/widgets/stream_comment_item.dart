import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StreamCommentItem extends StatefulWidget {
  const StreamCommentItem({Key? key}) : super(key: key);

  @override
  _StreamCommentItemState createState() => _StreamCommentItemState();
}

class _StreamCommentItemState extends State<StreamCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 11),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.commentBg.withOpacity(0.6)),
      child: Row(
        children: const [
          AddImageWidget(
            ImageBgradius: 20,
            Imageradius: 18,
            IconBgradius: 7,
            Iconradius: 6,
            iconSize: 0,
            iconBgCOlor: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            'Great Video Keep it Up We Love You Much Love From Here',
            style: TextStyle(color: AppColors.smokeWhite),
          )),
        ],
      ),
    );
  }
}
