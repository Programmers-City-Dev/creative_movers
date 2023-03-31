import 'package:creative_movers/blocs/status/status_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/feed/models/mediaitem_model.dart';
import 'package:creative_movers/screens/main/status/views/add_status_screen.dart';
import 'package:creative_movers/screens/main/status/views/status_media_preview.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateStoryDialog extends StatefulWidget {
  const CreateStoryDialog({Key? key}) : super(key: key);

  @override
  State<CreateStoryDialog> createState() => _CreateStoryDialogState();
}

class _CreateStoryDialogState extends State<CreateStoryDialog> {
  List<String> mediaFiles = [];
  List<MediaItemModel> mediaItems = [];

  @override
  Widget build(BuildContext context) {
    var statusBloc = context.read<StatusBloc>();
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
                Expanded(
                    child: Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Text(
                      'Create Story',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Icon(
                      Icons.blur_on,
                    ),
                  ]),
                )),
              ],
            ),
            Expanded(
                child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppIcons.icStory,
                    height: 250,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'What will you like to share ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: statusBloc,
                                  child: const AddStatusScreen(),
                                ),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: AppColors.primaryColor,
                              elevation: 0,
                              child: Container(
                                height: 170,
                                width: 120,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        end: Alignment.bottomRight,
                                        begin: Alignment.topLeft,
                                        colors: [
                                          Colors.teal,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColors.white,
                                        child: Icon(
                                          Icons.text_rotation_none,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Text',
                                        style: TextStyle(
                                            color: AppColors.lightBlue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _fetchMedia(context);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                              child: Container(
                                height: 170,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const LinearGradient(
                                        end: Alignment.bottomRight,
                                        begin: Alignment.topLeft,
                                        colors: [
                                          Colors.pinkAccent,
                                          Colors.indigo,
                                          Colors.lightBlue,
                                        ])),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColors.white,
                                        child: Icon(
                                          Icons.filter_vintage,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Image/Video',
                                        style: TextStyle(
                                            color: AppColors.lightBlue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _fetchMedia(BuildContext context) async {
    var images = ['jpg', 'jpeg', 'png', 'webp'];
    var videos = ['mp4', 'mov'];
    var files = await AppUtils.fetchMedia(
        allowMultiple: true,
        onSelect: (result) {
          if (result != null) {
            if (result.files.isNotEmpty) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StatusMediaPreview(
                  files: result.files,
                ),
              ));
            } else {}
          }
        });
  }
}
