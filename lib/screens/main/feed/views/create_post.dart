import 'package:creative_movers/screens/main/views/live_stream_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  IconButton(onPressed: () {Navigator.of(context).pop();}, icon: const Icon(Icons.close)),
                  const Expanded(
                    child: Text(
                      'Create New Post',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text(
                    'Post',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: AppColors.lightBlue,
                    radius: 20,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.w3schools.com/w3images/avatar6.png'),
                      radius: 18,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Noble Okechi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextFormField(
                  maxLines: 8,
                  decoration: const InputDecoration(
                      hintText: 'Have Something to share with the community',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: InputBorder.none),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo_size_select_actual_rounded,
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
                    SizedBox(
                      width: 16,
                    ),

                    Container(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.videocam_rounded,
                            color: Colors.green,
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
                    SizedBox(
                      width: 16,
                    ),

                    // InkWell(
                    //   onTap: (){
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveStreamScreen(),));
                    //   },
                    //   child: Container(
                    //     child: Row(
                    //       children: const [
                    //         Icon(
                    //           Icons.video_call_rounded,
                    //           color: Colors.red,
                    //         ),
                    //         SizedBox(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           'Go Live',
                    //           style: TextStyle(fontSize: 13),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
