import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CreatePostCard extends StatefulWidget {
  const CreatePostCard({Key? key}) : super(key: key);

  @override
  _CreatePostCardState createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
           padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Row(
                  children: [
                    const AddImageWidget(
                      ImageBgradius: 20,
                      Imageradius: 18,
                      IconBgradius: 7,
                      Iconradius: 6,
                      iconSize: 0,
                      iconBgCOlor: Colors.green,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: const Text('Whats on your mind ?'),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              height: 5,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo_size_select_actual,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Photo',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.videocam_rounded,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Video',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.video_call_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Go Live',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
