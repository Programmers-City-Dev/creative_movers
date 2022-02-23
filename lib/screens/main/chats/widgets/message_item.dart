import 'package:creative_movers/data/remote/model/message_model.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({Key? key, required this.messageModel}) : super(key: key);
  final MessageModel messageModel;

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: widget.messageModel.isForme
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                child: const CircleAvatar(
                  radius: 18,
                ),
                visible: !widget.messageModel.isForme,
              ),
              Visibility(
                visible: widget.messageModel.messageType == "text",
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(right: 5, left: 5, top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: !widget.messageModel.isForme
                          ? Colors.grey.shade300
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'How was your day  ',
                    style: TextStyle(
                        color: !widget.messageModel.isForme
                            ? AppColors.PtextColor
                            : Colors.white),
                  ),
                ),
              ),
              Visibility(
                visible: widget.messageModel.messageType == 'video',
                child: Container(
                  height: 200,
                  width: 170,
                  margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
                  decoration: BoxDecoration(
                      // gradient: const RadialGradient(
                      //   colors: [
                      //     AppColors.gradient,
                      //     AppColors.gradient2,
                      //   ],
                      //   radius: 0.8,
                      // ),
                      color: AppColors.primaryColor,
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.5), BlendMode.srcOver),
                          fit: BoxFit.cover,
                          image: const NetworkImage(
                            'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                          )),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Icon(
                      Icons.videocam_off_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: widget.messageModel.messageType == 'image',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 220,
                      width: 170,
                      margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.grey.withOpacity(0.5),
                                  BlendMode.srcOver),
                              fit: BoxFit.cover,
                              image: const NetworkImage(
                                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                              )),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
