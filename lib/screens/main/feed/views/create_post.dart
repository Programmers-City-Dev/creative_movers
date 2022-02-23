import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/models/media.dart';
import 'package:creative_movers/screens/main/feed/models/mediaitem_model.dart';
import 'package:creative_movers/screens/main/feed/widgets/MediaItem.dart';
import 'package:creative_movers/screens/main/feed/widgets/image_picker_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_picker_item.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<String> pickedImages = [];
  List<MultipartFile> imageFiles = [];
  List<String> mediaFiles = [];
  List<MediaItemModel> mediaItems = [];
  List<String?> pickedvideos = [];
  List<MediaItemModel> mediaItem = [];

  final _postController = TextEditingController();
  FeedBloc _feedBloc = FeedBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FeedBloc, FeedState>(
        bloc: _feedBloc,
        listener: (context, state) {
          _listenToAddFeedState(context, state);
          // TODO: implement listener
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                    const Expanded(
                      child: Text(
                        'Create New Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryColor,
                      ),
                      onPressed:
                          mediaItems.isEmpty && _postController.text.isEmpty
                              ? null
                              : () {
                                  postFeed();
                                },
                      child: const Text(
                        'Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.smokeWhite),
                      ),
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
                      'Noble Okechi ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _postController,
                    decoration: const InputDecoration(
                        hintText: 'Have Something to share with the community',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none),
                  ),
                ),
                mediaItems.isNotEmpty
                    ? Container(
                        height: 150,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: mediaItems.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => mediaItems[index]
                                        .mediaType ==
                                    MediaType.image
                                ? ImagePickerItem(
                                    image: mediaItems[index].path,
                                    onClose: () {
                                      setState(() {
                                        mediaItems.remove(mediaItems[index]);
                                        mediaFiles.removeAt(index);

                                      });
                                    },
                                  )
                                : VideoPickerItem(
                                    path: mediaItems[index].path!,
                                    onClose: () {
                                      setState(() {
                                        mediaFiles.removeAt(index);
                                        mediaItems.remove(mediaItems[index]);
                                      });
                                    },
                                  )))
                    : const SizedBox(),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: InkWell(
                    onTap: () {
                      _fetchMedia();
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.perm_media,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Add Photo/Video',
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void postFeed() {
    List<MediaModel> media = mediaItems
        .map((e) => MediaModel(
            file: null ,
            type: e.mediaType == MediaType.image ? 'media' : 'video'))
        .toList();
    _feedBloc.add(AddFeedEvent(
        type: "user_feed", content: _postController.text, media: mediaFiles));
  }

  void _listenToAddFeedState(BuildContext context, FeedState state) {
    if (state is AddFeedLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is AddFeedFaliureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is AddFeedSuccessState) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  void _fetchImage() async {
    var images = await AppUtils.fetchImages(allowMultiple: true);
    if (images.isNotEmpty) {
      setState(() {
        // mediaItem.addAll(images
        //     .map((e) =>
        //     MediaItemModel(mediaType: 'pictures', path: e, onClose: () {}))
        //     .toList());
        // mediaType = 'pictures';
        pickedImages.addAll(images);
      });
    }
  }

  void _fetchMedia() async {
    var images = ['jpg', 'jpeg', 'png','webp'];
    var videos = ['mp4', 'mov'];
    var files = await AppUtils.fetchMedia(allowMultiple: true);

    if (files.isNotEmpty) {
      for (var file in files) {
        if (images.where((element) => element == file.extension).isNotEmpty) {
          mediaItems
              .add(MediaItemModel(mediaType: MediaType.image, path: file.path));
          mediaFiles.add(file.path!);

          setState(() {});
        } else if (videos
            .where((element) => element == file.extension)
            .isNotEmpty) {
          mediaItems
              .add(MediaItemModel(mediaType: MediaType.video, path: file.path));
          mediaFiles.add(file.path!);
          // log('VIDEO ${mediaFiles[0].file?.filename}');

          setState(() {});
        }
      }
    }
  }
}
