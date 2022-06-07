import 'dart:developer';

import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/chats/views/messaging_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  final Conversation conversation;
  final int userId;

  const ChatItem({Key? key, required this.conversation, required this.userId})
      : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var lastMessage = widget.conversation.lastMessage;
    var user1 = widget.conversation.user1;

    ConversationUser? user;
    if (user1?.id == widget.userId) {
      user = widget.conversation.user2;
    } else {
      user = widget.conversation.user1;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => MessagingScreen(
            conversation: widget.conversation,
            user: user!
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleImage(
                url: user?.profilePhotoPath,
                withBaseUrl: false,
                radius: 24,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user?.firstname} ${user?.lastname}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(
                    '${lastMessage?.body}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 10,
                  child: Center(
                    child: Text(
                      '${widget.conversation.unreadMessages}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Text(
                  AppUtils.formatTimeAgo(lastMessage!.createdAt),
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
