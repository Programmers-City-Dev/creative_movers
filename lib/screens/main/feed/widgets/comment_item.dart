import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            radius: 20,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.w3schools.com/w3images/avatar6.png'),
              radius: 18,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Anyanwu Nzubechi',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Error waiting for a debug connection: The log reader stopped unexpectedly '),
              SizedBox(height: 10,),

              Row(
                children: [
                  Text('12min',style: TextStyle(fontSize: 12,color: Colors.grey),),
                  SizedBox(width: 16,),
                  Text('like',style: TextStyle(fontSize: 12,color: Colors.grey),),
                  SizedBox(width: 10,),
                  Text('12 replies',style: TextStyle(fontSize: 12,color: Colors.grey),),
                  SizedBox(width: 16,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.solidThumbsUp,color: AppColors.primaryColor,size: 12,),
                      SizedBox(width: 5,),
                      Text('126',style: TextStyle(fontSize: 12,color: Colors.grey),),

                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),

              Row(children: [
                Container(width: 30,height: 1,color: Colors.grey,),
                SizedBox(width: 7,),
                Text('View more replies',style: TextStyle(fontSize: 12,color: Colors.grey),),


              ],)
            ],
          ))
        ],
      ),
    );
  }
}
