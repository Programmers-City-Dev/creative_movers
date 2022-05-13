import 'dart:io';

import 'package:creative_movers/blocs/status/status_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/feed/models/mediaitem_model.dart';
import 'package:creative_movers/screens/main/status/widgets/status_image_preview.dart';
import 'package:creative_movers/screens/main/status/widgets/status_video_preview.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_screen.dart';

class StatusMediaPreview extends StatefulWidget {
  const StatusMediaPreview({
    Key? key,
    required this.files,
  }) : super(key: key);
  final List<PlatformFile> files;

  @override
  _StatusMediaPreviewState createState() => _StatusMediaPreviewState();
}

class _StatusMediaPreviewState extends State<StatusMediaPreview> {
  final _captionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMedia(widget.files);
  }

  final List<String> mediaFiles = [];
  final List<MediaItemModel> mediaItems = [];
  final StatusBloc _statusBloc = StatusBloc();


  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatusBloc, StatusState>(
      bloc: _statusBloc,
      listener: (context, state) {
        _listenToUploadStatusStates(context,state);

      },
      child: SafeArea(
        child: Scaffold(
            body: mediaItems.isNotEmpty
                ? Container(
              child: Stack(children: [
                Container(
                  color: Colors.black,
                  child: PageView.builder(
                    controller:
                    PageController(keepPage: true, initialPage: 0),
                    pageSnapping: true,
                    onPageChanged: (currentindex) {
                      setState(() {
                        pageIndex = currentindex;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaItems.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                    mediaItems[index]
                        .mediaType ==
                        MediaType.image
                        ? StatusImagePreview(
                      image: mediaItems[index].path!,
                    )
                        : StatusVideoPreview(path: mediaItems[index].path!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.close, color: Colors.white,)),


                      Expanded(child: SizedBox()),
                      SizedBox(width: 20,),
                      IconButton(onPressed: () {
                        _fetchMedia();
                      },
                          icon: const Icon(Icons.add_photo_alternate_outlined,
                            color: AppColors.lightBlue, size: 25,)),
                      SizedBox(width: 20,),
                      IconButton(onPressed: () {
                        setState(() {
                          mediaItems.removeAt(pageIndex);
                          mediaFiles.removeAt(pageIndex);
                          AppUtils.showCustomToast('Removed');
                        });
                      },
                          icon: const Icon(
                            Icons.delete_rounded, color: AppColors.lightBlue,
                            size: 25,)),


                      mediaItems.length > 1
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                            backgroundColor:
                            AppColors.black.withOpacity(0.8),
                            padding: EdgeInsets.zero,
                            label: Text(
                              '${pageIndex + 1}/${mediaItems.length} ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.smokeWhite,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                          : const SizedBox(),

                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(

                              decoration: InputDecoration(
                                fillColor: AppColors.smokeWhite,
                                filled: true,
                                hintText: 'Enter Caption',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),

                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                              ),
                              controller: _captionController,
                              minLines: 1,
                              maxLines: 5,

                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: FloatingActionButton(onPressed: () {
                               uploadStatus();
                              }, child: const Icon(
                                Icons.send,
                              ),))
                        ],
                      ),
                    )),

              ]),
            )
                : const SizedBox()),
      ),
    );
  }

  void getMedia(List<PlatformFile> files) {
    var images = ['jpg', 'jpeg', 'png', 'webp'];
    var videos = ['mp4', 'mov'];
    if (files.isNotEmpty) {
      for (var file in files) {
        if (images
            .where((element) => element == file.extension)
            .isNotEmpty) {
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

  void _fetchMedia() async {
    var images = ['jpg', 'jpeg', 'png', 'webp'];
    var videos = ['mp4', 'mov'];
    var files = await AppUtils.fetchMedia(
        allowMultiple: true, onSelect: (result) {
      if (result!.files.isNotEmpty) {
        for (var file in result.files) {
          if (images
              .where((element) => element == file.extension)
              .isNotEmpty) {
            mediaItems
                .add(
                MediaItemModel(mediaType: MediaType.image, path: file.path));
            mediaFiles.add(file.path!);

            setState(() {});
          } else if (videos
              .where((element) => element == file.extension)
              .isNotEmpty) {
            mediaItems
                .add(
                MediaItemModel(mediaType: MediaType.video, path: file.path));
            mediaFiles.add(file.path!);
            // log('VIDEO ${mediaFiles[0].file?.filename}');

            setState(() {});
          }
        }
      }
    });
  }
   void uploadStatus(){
    if(_captionController.text.isEmpty & mediaFiles.isEmpty){
      AppUtils.showCustomToast('Add an Image or Video');
    }else{
      _statusBloc.add(UploadStatusEvent(text: _captionController.text,media: mediaFiles));
    }
   }
  void _listenToUploadStatusStates(BuildContext context, StatusState state) {
    if (state is AddStatusLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is AddStatusFaliureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is AddStatusSuccessState) {
      Navigator.pop(context);
      // Navigator.of(context).pushNamed(feedsPath);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));

    }

  }

}
