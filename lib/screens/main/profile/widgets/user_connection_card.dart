import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

import '../../../../data/remote/model/get_connects_response.dart';
import '../../../../helpers/paths.dart';
import '../../../../theme/app_colors.dart';

class UserConnectionCard extends StatefulWidget {
  const UserConnectionCard({Key? key, required this.connection})
      : super(key: key);
  final Connection connection;

  @override
  State<UserConnectionCard> createState() => _UserConnectionCardState();
}

class _UserConnectionCardState extends State<UserConnectionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightGrey)),
      shadowColor: AppColors.smokeWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.lightBlue,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.connection.profilePhotoPath,
              ),
              radius: 24,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${widget.connection.firstname} ${widget.connection.lastname}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                widget.connection.role,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageStack(
                  imageBorderWidth: 1,
                  imageList: widget.connection.connects
                      .map((e) => e.profilePhotoPath)
                      .toList(),
                  totalCount: widget.connection.connects.length,
                  showTotalCount: true,
                  imageRadius: 25,
                  extraCountTextStyle: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(viewProfilePath,
                  arguments: {"user_id": widget.connection.user_connect_id});
            },
            style: TextButton.styleFrom(
                shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.primaryColor)),
                padding: const EdgeInsets.symmetric(horizontal: 16)),
            child: const Text(
              'View Profile',
              style: TextStyle(fontSize: 11, color: AppColors.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
