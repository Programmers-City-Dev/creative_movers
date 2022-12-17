import 'package:creative_movers/app.dart';
import 'package:creative_movers/screens/main/live/views/live_stream_home_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 40),
        decoration: const BoxDecoration(color: AppColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tell us about it',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Do you have anything to share ?',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                height: 5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.photo_size_select_actual,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Photo',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.videocam_rounded,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Video',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _joinLiveStream();
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.video_call_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Go Live',
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _joinLiveStream() {
    Navigator.of(mainNavKey.currentState!.context).push(MaterialPageRoute(
      builder: (context) => const LiveStreamHomeScreen(
        isBroadcaster: true,
      ),
    ));
    // showMaterialModalBottomSheet(
    //     context: mainNavKey.currentState!.context,
    //     expand: false,
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(20),
    //       topRight: Radius.circular(20),
    //     )),
    //     builder: (ctx) {
    //       return Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Center(
    //             child: Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Choose your role",
    //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //           ),
    //           ListTile(
    //             onTap: () {
    //               Navigator.of(mainNavKey.currentState!.context)
    //                   .push(MaterialPageRoute(
    //                 builder: (context) => const LiveStreamHomeScreen(
    //                   isBroadcaster: true,
    //                 ),
    //               ));
    //             },
    //             leading: const Icon(Icons.announcement_outlined),
    //             title: const Text("Host"),
    //           ),
    //           ListTile(
    //             onTap: () {
    //               Navigator.of(mainNavKey.currentState!.context)
    //                   .push(MaterialPageRoute(
    //                 builder: (context) => const LiveStreamHomeScreen(
    //                   isBroadcaster: false,
    //                 ),
    //               ));
    //             },
    //             leading: const Icon(Icons.speaker_outlined),
    //             title: const Text("Guest"),
    //           ),
    //         ],
    //       );
    //     });
  }
}

class LiveStreamPrepScreen extends StatefulWidget {
  const LiveStreamPrepScreen({Key? key}) : super(key: key);

  @override
  State<LiveStreamPrepScreen> createState() => _LiveStreamPrepScreenState();
}

class _LiveStreamPrepScreenState extends State<LiveStreamPrepScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
