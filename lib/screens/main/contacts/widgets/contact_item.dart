import 'dart:developer';

import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../helpers/paths.dart';
import '../../../widget/image_previewer.dart';
import '../../chats/views/messaging_screen.dart';

class ContactItem extends StatefulWidget {
  const ContactItem({Key? key, required this.connection}) : super(key: key);
  final Connection connection;

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                // isDismissible: false,
                // enableDrag: false,
                barrierDismissible: true,
                builder: (context) => ImagePreviewer(
                  imageUrl: widget.connection.profilePhotoPath,
                  heroTag: "cover_photo",
                  tightMode: true,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                foregroundColor: Colors.red,
                backgroundImage:
                    NetworkImage(widget.connection.profilePhotoPath),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    log(' ID :${widget.connection.user_connect_id}');
                    Navigator.of(context)
                        .pushNamed(viewProfilePath, arguments: {
                      "user_id": widget.connection.user_connect_id
                    });
                  },
                  child: Text(
                    widget.connection.firstname +
                        ' ' +
                        widget.connection.lastname,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
                Text(
                  widget.connection.username,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                widget.connection.connects.isNotEmpty
                    ? Row(
                        children: [
                          widget.connection.connects.length < 3
                              ? ImageStack(
                                  imageList: widget.connection.connects
                                      .map((e) => e.profilePhotoPath)
                                      .toList(),
                                  totalCount: widget.connection.connects.length,
                                  // If larger than images.length, will show extra empty circle
                                  imageRadius: 20,
                                  // Radius of each images
                                  imageCount: widget.connection.connects.length,
                                  // Maximum number of images to be shown in stack
                                  imageBorderWidth:
                                      0, // Border width around the images
                                )
                              : ImageStack(
                                  imageList: [
                                    widget.connection.connects[0]
                                        .profilePhotoPath,
                                    widget
                                        .connection.connects[0].profilePhotoPath
                                  ],

                                  totalCount: 2,
                                  // If larger than images.length, will show extra empty circle
                                  imageRadius: 20,
                                  // Radius of each images
                                  imageCount: 2,
                                  // Maximum number of images to be shown in stack
                                  imageBorderWidth:
                                      0, // Border width around the images
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.connection.connects.isNotEmpty
                                ? widget.connection.connects[0].firstname
                                : '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          widget.connection.connects.length > 1
                              ? Text(
                                  '+${widget.connection.connects.length - 1}')
                              : Text(''),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'message') {
                Navigator.of(context,rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        conversationId: widget.connection.conversationId,
                        user: ConversationUser(
                            id:widget.connection.user_connect_id,
                            username: widget.connection.username,
                            firstname: widget.connection.firstname,
                            lastname: widget.connection.lastname,
                            profilePhotoPath: widget.connection.profilePhotoPath),
                      ),
                    ));
              } else {}
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  padding: const EdgeInsets.all(10),
                  onTap: () {

                  },
                  value: 'message',
                  child: Row(
                    children: const [
                      Icon(Icons.sms_rounded,color: Colors.blueGrey,size: 20,),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Message ',style: TextStyle(fontSize: 14,color: Colors.blueGrey),),
                    ],
                  )),
              PopupMenuItem<String>(
                  padding: const EdgeInsets.all(10),
                  value: 'remove',
                  child: SizedBox(

                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline,color: Colors.blueGrey,size: 20,),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Remove Connection',style: TextStyle(fontSize: 14,color: Colors.blueGrey),),
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
