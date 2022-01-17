import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({Key? key}) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
        Padding(
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
            children: const [
            Text('Frank Trabivas',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
            Text('Frank Trabivas',style: TextStyle(fontSize: 13,color: Colors.grey),),
          ],),
        ),
        Column(children: const [
          CircleAvatar(radius: 12, child: Center(
            child: Text('5'),
          ),),
          Text('12:23pm',style: TextStyle(fontSize: 12),)
        ],),
        
      ],),
    );
  }
}
