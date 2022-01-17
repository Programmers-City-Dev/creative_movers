import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
class ContactItem extends StatefulWidget {
  const ContactItem({Key? key}) : super(key: key);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 30,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(
                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
              ),

            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text('Frank Trabivas',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                Text('Frank Trabivas',style: TextStyle(fontSize: 13,color: Colors.grey),),
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
                  Text('Peter C. ',style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('+5'),
                ],)
              ],),
          ),
         Icon(Icons.more_horiz),

        ],),
    );
  }
}
