import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

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
              backgroundImage: NetworkImage(comment.user.profilePhotoPath!),
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
                ' ${comment.user.firstname} ${comment.user.lastname}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(comment.comment),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                   Text(
                     comment.createdAt != null?
                    AppUtils.getTime(comment.createdAt!):'1 sec ago',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // const Text(
                  //   'like',
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // const Text(
                  //   '12 replies',
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: const [
                  //     FaIcon(
                  //       FontAwesomeIcons.solidThumbsUp,
                  //       color: AppColors.primaryColor,
                  //       size: 12,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Text(
                  //       '126',
                  //       style: TextStyle(fontSize: 12, color: Colors.grey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     Container(
              //       width: 30,
              //       height: 1,
              //       color: Colors.grey,
              //     ),
              //     const SizedBox(
              //       width: 7,
              //     ),
              //     const Text(
              //       'View more replies',
              //       style: TextStyle(fontSize: 12, color: Colors.grey),
              //     ),
              //   ],
              // )
            ],
          ))
        ],
      ),
    );
  }
}
