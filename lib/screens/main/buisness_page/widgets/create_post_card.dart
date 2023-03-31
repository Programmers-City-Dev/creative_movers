import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../app.dart';
import '../../live/views/live_stream_home_screen.dart';

class CreatePostCard extends StatefulWidget {
  const CreatePostCard({Key? key}) : super(key: key);

  @override
  _CreatePostCardState createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
           padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Row(
                  children: [
                    const AddImageWidget(
                      ImageBgradius: 20,
                      Imageradius: 18,
                      IconBgradius: 7,
                      Iconradius: 6,
                      iconSize: 0,
                      iconBgCOlor: Colors.green,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text('Whats on your mind ?'),
                      ),
                    )
                  ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
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
                ),
                Container(
                  child: Row(
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
                ),
                InkWell(
                  onTap: (){
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
    );
  }
  void _joinLiveStream() {
    Navigator.of(mainNavKey.currentState!.context)
        .push(MaterialPageRoute(
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
