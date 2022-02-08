import 'package:creative_movers/models/message_model.dart';
import 'package:creative_movers/screens/main/chats/widgets/message_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool noText = true;
  TextEditingController _controller = TextEditingController();
  List<MessageModel> mesages = [
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: false, message: 'how are you', messageType: 'video'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'image'),
    MessageModel(isForme: false, message: 'how are you', messageType: 'video'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: false, message: 'how are you', messageType: 'video'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'image'),
    MessageModel(isForme: false, message: 'how are you', messageType: 'text'),
    MessageModel(isForme: true, message: 'how are you', messageType: 'text'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.smokeWhite,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.phone_rounded,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.videocam_rounded,
                ),
              ),
            )
          ],
          iconTheme: IconThemeData(color: AppColors.textColor),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 20,
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
                      Text(
                        'Frank Trabivas',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.primaryColor),
                      ),
                      Text(
                        '@FrankTrabivas',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                itemCount: mesages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>  MessageItem(messageModel: mesages[index],),
              )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.attachment_rounded,
                            ),
                          ),
                           Expanded(
                            child: TextField(
                              onChanged: (val){

                                  setState(() {
                                    noText =val.isEmpty;
                                  });


                              },
                              controller: _controller,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                              minLines: 1,
                              maxLines: 5,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.photo_camera_rounded,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 8,bottom: 16),
                      height: 45,
                      width: 45,
                      child: FloatingActionButton(onPressed: () {},child: noText?AnimatedContainer(
                        duration: Duration(milliseconds: 2000),
                        child: const Icon(
                          Icons.mic_rounded,
                        ),
                      ):AnimatedContainer(
                        duration: const Duration(milliseconds: 2000),
                        child: const Icon(
                          Icons.send_rounded,
                        ),
                      ),))
                ],
              ),
            ],
          ),
        ));
  }
}
