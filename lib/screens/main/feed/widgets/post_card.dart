import 'package:creative_movers/screens/main/views/live_stream_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, this.onTap}) : super(key: key);
 final VoidCallback? onTap;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 40),
        decoration: const BoxDecoration(color: AppColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tell us about it',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Do you have anything to share ?',
                    style: TextStyle(fontSize: 13),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveStreamScreen(),));
                    },
                    child: Container(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
