import 'dart:developer' as logger;

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/data/remote/model/media.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/chats/widgets/message_item.dart';
import 'package:creative_movers/screens/main/feed/models/mediaitem_model.dart';
import 'package:creative_movers/screens/main/feed/widgets/file_picker_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/image_picker_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_picker_item.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:path/path.dart' as p;

class MessagingScreen extends StatefulWidget {
  final int? conversationId;
  final ConversationUser user;

  const MessagingScreen({
    Key? key,
    this.conversationId,
    required this.user,
  }) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool noText = true;
  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final _chatScrollController = ScrollController();
  final ChatBloc _chatBloc = ChatBloc(injector.get());
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  ValueNotifier<bool> noTextNotifier = ValueNotifier(true);
  List<MediaItemModel> mediaItems = [];
  List<String> mediaFiles = [];

  int? conversationId;

  // late int otherUserId;

  @override
  void initState() {
    super.initState();
    if (widget.conversationId != null) {
      conversationId = widget.conversationId;
      _chatBloc.add(
          FetchConversationsMessagesEvent(conversationId: conversationId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.log("OTHER USER ID: ${widget.user.toMap()}");
    return Scaffold(
        backgroundColor: AppColors.smokeWhite,
        appBar: AppBar(
          // actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.phone_rounded,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 5),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.videocam_rounded,
          //     ),
          //   ),
          // )
          // ],
          elevation: 1,
          iconTheme: const IconThemeData(color: AppColors.textColor),
          titleSpacing: 0,
          backgroundColor: AppColors.white,
          toolbarHeight: 60,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleImage(
                    url: widget.user.profilePhotoPath,
                    withBaseUrl: false,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.user.firstname} ${widget.user.lastname}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.primaryColor),
                      ),
                      Text(
                        _status(widget.user),
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is ConversationMessagesFetched) {
              _chatBloc.add(ListenToChatEvent(state.id, state.channel));
            }
          },
          builder: (context, state) {
            if (state is ChatMessageLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is ChatError) {
              return Center(
                  child: AppPromptWidget(
                onTap: () {
                  _chatBloc.add(FetchConversationsMessagesEvent(
                      conversationId: conversationId!));
                },
                canTryAgain: true,
                isSvgResource: true,
                imagePath: "assets/svgs/request.svg",
                title: "Something went wrong",
                message: state.errorModel.errorMessage,
              ));
            }
            if (state is ConversationMessagesFetched ||
                widget.conversationId == null) {
              return ValueListenableBuilder<List<Message>>(
                  valueListenable: _chatBloc.chatMessagesNotifier,
                  builder: (context, messages, snapshot) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _scrollChatToBottom();
                    });
                    // List<Message> messages = msgs.reversed.toList();
                    return Column(
                      children: [
                        if (messages.isEmpty)
                          const Expanded(
                            child: Center(
                                child: AppPromptWidget(
                              canTryAgain: false,
                              isSvgResource: true,
                              imagePath: "assets/svgs/request.svg",
                              title: "Empty conversation",
                              message:
                                  "Start a new conversation by sending a message.",
                            )),
                          ),
                        if (messages.isNotEmpty)
                          Expanded(
                              child: GroupedListView<Message, int>(
                            controller: _chatScrollController,
                            // shrinkWrap: true,
                            // reverse: true,
                            elements: messages,
                            groupBy: (message) => DateTime(
                                    message.createdAt.year,
                                    message.createdAt.month,
                                    message.createdAt.day)
                                .millisecondsSinceEpoch,
                            groupSeparatorBuilder: (groupByValue) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: Text(
                                      AppUtils.getGroupLabel(groupByValue),
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            itemBuilder: (context, message) => MessageItem(
                              chatMessage: message,
                              shouldLoad: message.shouldLoad,
                              files: mediaFiles,
                              otherUserId: widget.user.id,
                              onMessageSent: (msg) {
                                conversationId = int.parse(msg.conversationId);
                                _chatBloc.resetChatMessage(msg, message.id);
                              },
                              onDeleteMessage: (message) {},
                            ),
                            itemComparator: (item1, item2) => item1
                                .createdAt.millisecondsSinceEpoch
                                .compareTo(
                                    item2.createdAt.millisecondsSinceEpoch),
                            // optional
                            useStickyGroupSeparators: true,
                            // optional
                            floatingHeader: true,
                            // optional
                            order: GroupedListOrder.ASC, // optional
                          )),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mediaItems.isNotEmpty
                                ? SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: mediaItems.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            mediaItems[index].mediaType ==
                                                    MediaType.image
                                                ? ImagePickerItem(
                                                    image:
                                                        mediaItems[index].path,
                                                    onClose: () {
                                                      setState(() {
                                                        mediaItems.remove(
                                                            mediaItems[index]);
                                                        mediaFiles
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  )
                                                : mediaItems[index].mediaType ==
                                                        MediaType.image
                                                    ? VideoPickerItem(
                                                        path: mediaItems[index]
                                                            .path!,
                                                        onClose: () {
                                                          setState(() {
                                                            mediaFiles.removeAt(
                                                                index);
                                                            mediaItems.remove(
                                                                mediaItems[
                                                                    index]);
                                                          });
                                                        },
                                                      )
                                                    : FilePickerItem(
                                                        filePath:
                                                            mediaItems[index]
                                                                .path!,
                                                        onClose: () {
                                                          setState(() {
                                                            mediaFiles.removeAt(
                                                                index);
                                                            mediaItems.remove(
                                                                mediaItems[
                                                                    index]);
                                                          });
                                                        },
                                                      )))
                                : const SizedBox(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppColors.white),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SpeedDial(
                                          elevation: 0,
                                          spaceBetweenChildren: 16,
                                          overlayOpacity: 0.3,
                                          overlayColor: Colors.black,
                                          childPadding: EdgeInsets.zero,
                                          renderOverlay: true,
                                          backgroundColor: Colors.transparent,
                                          activeForegroundColor:
                                              Colors.transparent,
                                          activeBackgroundColor:
                                              Colors.transparent,
                                          useRotationAnimation: false,
                                          children: [
                                            SpeedDialChild(
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.purple,
                                              child: const IconButton(
                                                  onPressed: null,
                                                  icon: Icon(
                                                    Icons.description,
                                                    color: Colors.white,
                                                  )),
                                              onTap: () async {
                                                _fetchMedia();
                                              },
                                            ),
                                            SpeedDialChild(
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.indigo,
                                              child: const IconButton(
                                                  onPressed: null,
                                                  icon: Icon(
                                                    Icons.image,
                                                    color: Colors.white,
                                                  )),
                                              onTap: () async {
                                                _selectImage(context);
                                              },
                                            ),
                                          ],
                                          activeChild: const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.attachment_rounded,
                                                color: Colors.black,
                                              )),
                                          child: const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.attachment_rounded,
                                                color: Colors.black,
                                              )),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            focusNode: _focusNode,
                                            onChanged: (val) {
                                              noTextNotifier.value =
                                                  val.isEmpty ||
                                                      val.trim().isEmpty;
                                            },
                                            controller: _textController,
                                            decoration: const InputDecoration(
                                                filled: true,
                                                hintText: "Type your message",
                                                hintStyle: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                                fillColor: AppColors.white,
                                                contentPadding: EdgeInsets.zero,
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none)),
                                            minLines: 1,
                                            maxLines: 5,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _selectCameraImage();
                                          },
                                          icon: const Icon(
                                            Icons.photo_camera_rounded,
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        right: 8, bottom: 16),
                                    height: 45,
                                    width: 45,
                                    child: FloatingActionButton(
                                      onPressed: () {},
                                      child: ValueListenableBuilder<bool>(
                                          valueListenable: noTextNotifier,
                                          builder: (context, value, snapshot) {
                                            return value
                                                ? AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 2000),
                                                    child: const Icon(
                                                      Icons.mic_rounded,
                                                    ),
                                                  )
                                                : AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 2000),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_textController
                                                            .text.isNotEmpty) {
                                                          _sendMessage();
                                                        }
                                                      },
                                                      child: const Icon(
                                                        Icons.send_rounded,
                                                      ),
                                                    ),
                                                  );
                                          }),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            }
            return const SizedBox.shrink();
          },
        ));
  }

  void _scrollChatToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController
          .jumpTo(_chatScrollController.position.maxScrollExtent + 100);
    }
  }

  void _sendMessage({
    MediaModel? mediaModel,
  }) {
    Message message = Message(
        id: 0,
        body: _textController.text,
        conversationId:
            conversationId == null ? '-1' : conversationId.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        media: mediaModel == null ? [] : [mediaModel],
        status: 'unread',
        userId: injector.get<CacheCubit>().cachedUser!.id.toString(),
        profilePhotoPath:
            injector.get<CacheCubit>().cachedUser!.profilePhotoPath,
        shouldLoad: true);
    _chatBloc.pushMessage(message);
    _textController.clear();
  }

  String _status(ConversationUser user) {
    if (user.status == "online") {
      return "Online";
    } else {
      return AppUtils.getLastSeen(user.updatedAt!);
    }
  }

  void _fetchMedia() async {
    var pickedFiles = await AppUtils.fetchMedia(
      allowMultiple: true,
    );

    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        mediaFiles.add(file.path!);

        _sendMessage(
            mediaModel: MediaModel(
                type: getFileTypeFromPath(file.path!), mediaPath: file.path!));
      }
    }

    //TODO UNCOMMENT IF MULTIPLE IMAGE PREVIEW IS ALLOWED
    // if (pickedFiles.isNotEmpty) {
    //   for (var file in pickedFiles) {
    //     if (images.where((element) => element == file.extension).isNotEmpty) {
    //       mediaItems
    //           .add(MediaItemModel(mediaType: MediaType.image, path: file.path));
    //
    //       mediaFiles.add(file.path!);
    //
    //       setState(() {});
    //     } else if (videos
    //         .where((element) => element == file.extension)
    //         .isNotEmpty) {
    //       mediaItems
    //           .add(MediaItemModel(mediaType: MediaType.video, path: file.path));
    //       mediaFiles.add(file.path!);
    //       setState(() {});
    //
    //       // log('VIDEO ${mediaFiles[0].file?.filename}');
    //
    //       setState(() {});
    //     } else {
    //       mediaItems
    //           .add(MediaItemModel(mediaType: MediaType.other, path: file.path));
    //       mediaFiles.add(file.path!);
    //       setState(() {});
    //     }
    //   }
    // }

    // var pickedFiles = [];
    // AppUtils.selectImage(context, (p0) {
    //   setState(() {
    //     pickedFiles = p0.map((e) => File(e)).toList();
    //   });
    //   if (pickedFiles.isNotEmpty) {
    //     for (File file in pickedFiles) {
    //       if (images
    //           .where((element) =>
    //       element == p.extension(file.path).replaceFirst('.', ''))
    //           .isNotEmpty) {
    //         mediaItems.add(
    //             MediaItemModel(mediaType: MediaType.image, path: file.path));
    //
    //         mediaFiles.add(file.path);
    //         AppUtils.showCustomToast(mediaFiles.length.toString());
    //         AppUtils.showCustomToast(file.path.toString());
    //
    //         setState(() {});
    //       } else if (videos
    //           .where((element) => element == p.extension(file.path))
    //           .isNotEmpty) {
    //         mediaItems.add(
    //             MediaItemModel(mediaType: MediaType.video, path: file.path));
    //         mediaFiles.add(file.path);
    //         // log('VIDEO ${mediaFiles[0].file?.filename}');
    //
    //         setState(() {});
    //       }
    //     }
    //   }
    // });
  }

  void _selectImage(BuildContext context) {
    AppUtils.selectFiles(context, (filePaths) {
      if (filePaths.isNotEmpty) {
        for (var filePath in filePaths) {
          mediaFiles.add(filePath);
          _sendMessage(
              mediaModel: MediaModel(
                  type: getFileTypeFromPath(filePath), mediaPath: filePath));
        }
      }
    }, allowMultiple: false);
  }

  void _selectCameraImage() async {
    var picture = await AppUtils.fetchImageFromCamera();
    if (picture != null) {
      mediaFiles.add(picture);
      _sendMessage(
          mediaModel: MediaModel(
              type: getFileTypeFromPath(picture), mediaPath: picture));
    }
  }
}

String getFileTypeFromPath(String path) {
  var images = ['jpg', 'jpeg', 'png', 'webp', 'PNG'];
  var videos = ['mp4', 'mov'];
  var fileType = '';
  var extension = p.extension(path).replaceFirst('.', '');

  logger.log(extension);

  if (images.contains(extension)) {
    fileType = 'image';
  } else if (videos.contains(extension)) {
    fileType = 'video';
  } else if (extension == 'pdf') {
    fileType = 'pdf';
  } else if (extension == 'doc' || extension == 'docx') {
    fileType = 'document';
  } else {
    fileType = 'other';
  }

  return fileType;
}
