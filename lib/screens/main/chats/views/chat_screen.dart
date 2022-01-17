import 'package:creative_movers/screens/main/chats/widgets/chat_item.dart';
import 'package:creative_movers/screens/widget/image_list.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(

        children:  [
          Row(
            children: [
              Expanded(
                child: SearchField(
                  hint: 'Search Chats',
                ),
              ),
              SizedBox(width: 16,),
              IconButton(
                onPressed: (){}, icon: Icon(
                Icons.people,
              ),)
            ],
          ),
          SizedBox(height: 10,),
          ImageList(),
          Expanded(child: ListView.builder(itemBuilder: (context, index) => ChatItem(),itemCount: 5,shrinkWrap: true,))
        ],

      ),
    );
  }
}
