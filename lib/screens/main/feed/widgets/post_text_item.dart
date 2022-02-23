import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTextItem extends StatelessWidget {
  const PostTextItem({Key? key}) : super(key: key);

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
            children: const [
              Text('Noble Okechi 🌞',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Error waiting for a debug connection: The log reader stopped unexpectedly '),
              Text('12min',style: TextStyle(fontSize: 12,color: Colors.grey),),
            ],
          ))
        ],
      ),
    );
  }
}
