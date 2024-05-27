import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PostTextItem extends StatelessWidget {
  const PostTextItem({Key? key, this.feed}) : super(key: key);
  final Feed? feed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            radius: 20,
            child: CircleAvatar(
              backgroundImage: NetworkImage(feed?.type == 'user_feed'
                  ? feed!.user!.profilePhotoPath!
                  : feed?.page!.photoPath != null
                      ? feed!.page!.photoPath!
                      : 'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'),
              radius: 18,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feed!.type == 'user_feed'
                    ? ' ${feed!.user?.firstname} ${feed!.user?.lastname} 🌞'
                    : ' ${feed!.page?.name} 🌞',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(feed!.content ?? ""),
              Text(
                AppUtils.getTimeAgo(feed!.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
