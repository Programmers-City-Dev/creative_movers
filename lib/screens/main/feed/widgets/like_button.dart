
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final bool isOk;
  final VoidCallback onTap;
  const LikeButton(
      {Key? key,
      required this.isLiked,
      required this.onTap,
      required this.isOk})
      : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool liked;

  @override
  void initState() {
    super.initState();
    liked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    // log("LIKED: ${widget.isLiked}");
    return InkWell(
      onTap: () {
        setState(() {
          // liked = !liked;
          widget.onTap();
        });
      },
      child: Container(
          child: !(liked && widget.isOk)
              ? const Icon(
                  Icons.thumb_up_outlined,
                  color: AppColors.textColor,
                )
              : const Icon(
                  Icons.thumb_up_outlined,
                  color: AppColors.primaryColor,
                )),
    );
  }
}
