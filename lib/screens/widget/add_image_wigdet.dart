import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
class AddImageWidget extends StatefulWidget {
  const AddImageWidget({Key? key}) : super(key: key);

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          CircleAvatar(
            radius: 70,
            backgroundColor: AppColors.lightBlue,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
              ),
              radius: 65,
            ),
          ),
          Positioned(
            right: -5,
            bottom: 7,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.lightBlue,
              child: CircleAvatar(
                radius: 22,
                child: Icon(
                  Icons.photo_camera_rounded,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
