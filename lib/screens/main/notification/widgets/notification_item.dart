import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/app.dart';
import 'package:creative_movers/data/remote/model/notifications_response.dart'
    as notification;
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/main/live/views/live_stream.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NotificationItem extends StatefulWidget {
  final notification.Notification notificationData;
  const NotificationItem({Key? key, required this.notificationData})
      : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    final notifier = widget.notificationData.data.content.notifier;
    final contentData = widget.notificationData.data.content.data;

    return GestureDetector(
      onTap: () {
        _handleClickAction();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleImage(
                  url: notifier.avatar,
                  withBaseUrl: false,
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPostDescription(notifier.name,
                          widget.notificationData.data.type, contentData),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppUtils.getTimeAgo(widget.notificationData.createdAt),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                )),
                // IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleClickAction() async {
    // final notifier = widget.notificationData.data.content.notifier;
    final contentData = widget.notificationData.data.content.data;

    final notificationType = widget.notificationData.data.type;
    if (notificationType == "comments" ||
        notificationType == "likes" ||
        notificationType == "feed") {
      if (contentData.type == "user_feed") {
        showMaterialModalBottomSheet(
            context: mainNavKey.currentState!.context,
            builder: (_) {
              return Container(
                child: FeedDetailsScreen(
                  feedId: contentData.id!,
                ),
              );
            });
      }
    } else if (notificationType == "live_video") {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: ((context) => LiveStream(
                isBroadcaster: false,
                channel: widget.notificationData.data.content.data.channelId,
              ))));
    }
  }

  String _getPostDescription(
      String name, String type, notification.ContentData contentData) {
    if (type == "likes") {
      return "$name liked your post";
    } else if (type == "comments") {
      return "$name commented on your post";
    } else if (type == "follows") {
      return "$name started following you";
    } else if (type == "feed") {
      if (contentData.type == "user_feed") {
        return "$name posted on your feed";
      } else {
        return "$name posted on your profile feed";
      }
    } else if (type == "live_video") {
      return "$name started started a live video.";
    } else {
      return "";
    }
  }
}
