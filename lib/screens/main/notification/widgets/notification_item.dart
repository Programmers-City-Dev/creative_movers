import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({Key? key}) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      color: AppColors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'),
                radius: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                'Emmason their is a user with the same idea with you and can invest'
                ' in your ideas, you can reach up with him',
                style: TextStyle(fontSize: 13),
              ),
                      SizedBox(height: 10,),
                      Text(
                        '5mins ago',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  )),
              IconButton(onPressed: (){}, icon:const Icon( Icons.more_horiz))
            ],
          )
        ],
      ),
    );
  }
}
