import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  const PostItem({Key? key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
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
              const Icon(
                Icons.more_vert_rounded,
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
            height: 200,

            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                    image: NetworkImage(
              'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
            ))),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(child: const CircleAvatar(
              radius:8 ,
              backgroundImage: NetworkImage(
              'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
            ),),),
            const Text('1,000 commented'),
          ],),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical:8 ),
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
                      SizedBox(width: 5,),
                      Text('Like',style: TextStyle(fontSize: 13),)
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
                      SizedBox(width: 5,),
                      Text('Comment',style: TextStyle(fontSize: 13),)
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
                      SizedBox(width: 5,),
                      Text('Share',style: TextStyle(fontSize: 13),)
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
