import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/di/injector.dart';
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
  ChatItemState createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var lastMessage = injector.get<ChatBloc>().chatMessagesNotifier.value.lastOrNull ?? widget.conversation.lastMessage;
    // var lastMessage = widget.conversation.lastMessage;
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
              conversationId: widget.conversation.id, user: user!),
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
                  // const SizedBox(
                  //   height: 8.0,
                  // ),
                  lastMessage!.media.isEmpty
                      ? Text(
                          "${lastMessage.body}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      : ConversationTypeWidget(message: lastMessage),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.conversation.unreadMessages! > 0)
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
                  AppUtils.formatTimeAgo(lastMessage.createdAt),
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

class ConversationTypeWidget extends StatelessWidget {
  final Message message;
  const ConversationTypeWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4.0),
        if (message.media.first.type == "image")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: const Border.fromBorderSide(
                    BorderSide(width: 1, color: Colors.grey))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Image"),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.photo,
                  size: 16,
                )
              ],
            ),
          ),
        if (message.media.first.type == "document" ||
            message.media.first.type == "unknown")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: const Border.fromBorderSide(
                    BorderSide(width: 1, color: Colors.grey))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("File"),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.description_outlined,
                  size: 16,
                )
              ],
            ),
          ),
        if (message.media.first.type == "music")
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: const Border.fromBorderSide(
                      BorderSide(width: 1, color: Colors.grey))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Music"),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.music_note,
                    size: 16,
                  )
                ],
              )),
        if (message.media.first.type == "video")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: const Border.fromBorderSide(
                    BorderSide(width: 1, color: Colors.grey))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Video"),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.video_collection_outlined,
                  size: 16,
                )
              ],
            ),
          )
      ],
    );
  }
}
