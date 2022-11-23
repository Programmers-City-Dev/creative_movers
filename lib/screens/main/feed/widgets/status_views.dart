import 'dart:developer';
import 'dart:typed_data';

import 'package:creative_movers/blocs/status/status_bloc.dart';
import 'package:creative_movers/data/remote/model/view_status_response.dart';
import 'package:creative_movers/screens/main/status/views/view_status_screen.dart';
import 'package:creative_movers/screens/main/status/widgets/create_story_dialog.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:status_view/status_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class StatusViews extends StatefulWidget {
  final bool? curvedBottom;
  final ViewStatusResponse viewStatusResponse;

  const StatusViews(
      {Key? key, this.curvedBottom = false, required this.viewStatusResponse})
      : super(key: key);

  @override
  _StatusViewsState createState() => _StatusViewsState();
}

class _StatusViewsState extends State<StatusViews> {
  @override
  void initState() {
    super.initState();
    if (widget.viewStatusResponse.activeStatus!.status.isNotEmpty) {
      log(widget.viewStatusResponse.activeStatus!.status.length.toString());
      Status? status = widget.viewStatusResponse.activeStatus;
      status?.firstname = 'My status';
      _list.add(status!);
    }

    //
    _list.addAll(widget.viewStatusResponse.otherStatus);
  }

  final List<Status> _list = [];

  @override
  Widget build(BuildContext context) {
    var statusBloc = context.read<StatusBloc>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.curvedBottom!
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : BorderRadius.zero,
        // border: const Border(
        //     bottom: BorderSide(
        //         width: 10, color: Colors.red, style: BorderStyle.none)),
        color: AppColors.white,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(),
            height: 90,
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlocProvider.value(
                            value: statusBloc,
                            child: const CreateStoryDialog());
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 25,
                    foregroundColor: Colors.red,
                    backgroundImage: const NetworkImage(
                      'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.lightGrey.withOpacity(0.5),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(
                            Icons.add,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  dragStartBehavior: DragStartBehavior.start,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _list.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(

                                MaterialPageRoute(
                                  fullscreenDialog: true,
                              maintainState: true,

                              builder: (context) => ViewStatusScreen(
                                alllStatus: _list,
                                status: (_list[index].status),
                                currentStatus: index,
                              ),
                            ));
                          },
                          child: _list[index].status.last.mediaType != null
                              ? _list[index].status.last.mediaType == 'image'
                                  ? StatusView(
                                      radius: 25,
                                      spacing: 15,
                                      strokeWidth: 2,
                                      // indexOfSeenStatus: 2,
                                      numberOfStatus:
                                          _list[index].status.length,
                                      padding: 4,
                                      seenColor: Colors.grey,
                                      unSeenColor: AppColors.primaryColor,
                                      centerImageUrl: _list[index]
                                          .status.last
                                          .file
                                          .toString(),
                                    )
                                  : FutureBuilder<Uint8List?>(
                                      future: VideoThumbnail.thumbnailData(
                                        video: _list[index].status.last.file ?? '',
                                        imageFormat: ImageFormat.JPEG,
                                        maxWidth: 24,
                                        maxHeight: 24,
                                        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                        quality: 100,
                                      ),
                                      builder: (context, snapshot) {
                                        // log(widget.media.mediaPath);
                                        if (!snapshot.hasError) {
                                          if (snapshot.hasData) {
                                          return  Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Center(
                                                  child: StatusView(
                                                    radius: 25,
                                                    spacing: 15,
                                                    strokeWidth: 2,
                                                    // indexOfSeenStatus: 2,
                                                    numberOfStatus:
                                                    _list[index].status.length,
                                                    padding: 4,
                                                    seenColor: Colors.grey,
                                                    unSeenColor: AppColors.primaryColor, centerImageUrl: '',

                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 4,
                                                    right: 4,
                                                    top: 4,
                                                    child: Center(
                                                        child: CircleAvatar(
                                                          radius: 21,

                                                          child: ClipRRect(
                                                            
                                                            borderRadius: BorderRadius.circular(20),
                                                            
                                                            child: Image.memory(

                                                              snapshot.data!,
                                                              fit: BoxFit.cover,
                                                              filterQuality:
                                                              FilterQuality.high,
                                                              width: 50,
                                                              height: 50,
                                                              alignment: Alignment.center,
                                                            ),
                                                          ),
                                                        )))
                                              ],
                                            );



                                          }
                                        }
                                        return StatusView(
                                          radius: 25,
                                          spacing: 15,
                                          strokeWidth: 2,
                                          // indexOfSeenStatus: 2,
                                          numberOfStatus:
                                          _list[index].status.length,
                                          padding: 4,
                                          seenColor: Colors.grey,
                                          unSeenColor: AppColors.primaryColor,
                                          centerImageUrl: _list[index]
                                              .status[0]
                                              .file
                                              .toString(),
                                        );
                                      })
                              : Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Center(
                                      child: StatusView(
                                        radius: 25,
                                        spacing: 15,
                                        strokeWidth: 2,
                                        // indexOfSeenStatus: 2,
                                        numberOfStatus:
                                            _list[index].status.length,
                                        padding: 4,
                                        seenColor: Colors.grey,
                                        unSeenColor: AppColors.primaryColor,
                                        centerImageUrl: _list[index]
                                            .status.last
                                            .file
                                            .toString(),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 4,
                                        right: 4,
                                        top: 4,
                                        child: Center(
                                            child: CircleAvatar(
                                          radius: 21,
                                          backgroundColor: Color(int.parse(
                                              _list[index].status.last.bgColor!,radix: 16)),

                                          child: Center(
                                              child: SizedBox(
                                                  height: 23,
                                                  width: 23,
                                                  child: Center(
                                                      child: Text(
                                                    _list[index]
                                                        .status.last
                                                        .text!,
                                                    style: const TextStyle(
                                                        fontSize: 5,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Colors.white),
                                                    maxLines: 4,
                                                    textAlign: TextAlign.center,
                                                  )))),

                                        )))
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Center(
                            child: Text(
                          _list[index].firstname,
                          style: const TextStyle(fontSize: 10),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
