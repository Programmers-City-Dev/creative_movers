import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
class UserConnectionCard extends StatefulWidget {
  const UserConnectionCard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UserConnectionCard> createState() => _UserConnectionCardState();
}

class _UserConnectionCardState extends State<UserConnectionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              6)),
      shadowColor:
      AppColors.smokeWhite,
      child: Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
              Colors.blueAccent,
              child: CircleAvatar(
                backgroundImage:
                NetworkImage(
                  widget.user.connections![
                  index][
                  "profile_photo_path"],
                ),
                radius: 23,
              ),
            ),
            Center(
              child: Padding(
                padding:
                const EdgeInsets
                    .all(5.0),
                child: Text(
                  '${user.connections![index]['firstname']} ${user.connections![index]['lastname']}',
                  style:
                  const TextStyle(
                      fontSize:
                      11),
                  overflow:
                  TextOverflow
                      .ellipsis,
                  textAlign: TextAlign
                      .center,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding:
                const EdgeInsets
                    .all(1.0),
                child: Text(
                  '${user.connections![index]['role']}',
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors
                          .blueGrey),
                  overflow:
                  TextOverflow
                      .ellipsis,
                  textAlign: TextAlign
                      .center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
