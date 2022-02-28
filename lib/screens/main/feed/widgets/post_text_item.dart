import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
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
        children:  [
           CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            radius: 20,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  feed!.user.profilePhotoPath!),
              radius: 18,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(' ${feed!.user.firstname } ${feed!.user.lastname} 🌞',style: const TextStyle(fontWeight: FontWeight.bold),),
              Text(feed!.content!),
              const Text('12min',style: TextStyle(fontSize: 12,color: Colors.grey),),
            ],
          ))
        ],
      ),
    );
  }
}
