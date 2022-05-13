import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

class PostItem extends StatefulWidget {
  const PostItem({Key? key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: AppColors.white),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Amanda Berks',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '12 mins ago',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                      padding: const EdgeInsets.all(10),
                      value: 'Edit',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.edit_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Edit'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: EdgeInsets.all(10),
                      value: 'Notification',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.notifications_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Notification'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: EdgeInsets.all(10),
                      value: 'Delete',
                      child: Container(
                        width: 100,
                        child: Row(
                          children: const [
                            Icon(Icons.delete_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Delete'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: const EdgeInsets.all(10),
                      value: 'Copy Link',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.content_copy_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Copy Link'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: const EdgeInsets.all(10),
                      value: 'Share',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.share_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Share'),
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'This is a simple post in the social media platform please like and comment if you can',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                    ))),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageStack(
                imageList: images,
                totalCount: images.length,
                // If larger than images.length, will show extra empty circle
                imageRadius: 25,
                // Radius of each images
                imageCount: 3,
                // Maximum number of images to be shown in stack
                imageBorderWidth: 0, // Border width around the images
              ),
              const Text('1,000 commented'),
            ],
          ),
          const Divider(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.thumb_up_rounded,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Like',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.chat_bubble_rounded,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Comment',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.share_rounded,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Share',
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
