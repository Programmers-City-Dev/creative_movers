import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

class ResultItem extends StatefulWidget {
  const ResultItem({Key? key}) : super(key: key);

  @override
  _ResultItemState createState() => _ResultItemState();
}

class _ResultItemState extends State<ResultItem> {
  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: Row(

        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 31,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(
                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
              ),

            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          Text('Frank Trabivas',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),),
                          Text(
                            'Mover', style: TextStyle(fontSize: 13, color: Colors.grey),),


                        ],),
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: () {}, child: Text('connect'), style: TextButton.styleFrom(backgroundColor: AppColors.lightBlue),),
                        SizedBox(width: 5,),
                        Icon(Icons.person_add_rounded,color: AppColors.primaryColor,),
                      ],
                    ),
                  ],
                ),
                Row(children: [
                  ImageStack(
                    imageList: images,
                    totalCount: images.length,
                    // If larger than images.length, will show extra empty circle
                    imageRadius: 20,
                    // Radius of each images
                    imageCount: 3,
                    // Maximum number of images to be shown in stack
                    imageBorderWidth: 3, // Border width around the images
                  ),
                  SizedBox(width: 5,),
                  Text('Peter C. ',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('+ are following'),
                ],),
              ],
            ),
          ),



        ],),
    );
  }
}