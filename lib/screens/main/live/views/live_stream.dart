import 'dart:developer' as logger;
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/live_chat_message.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:uuid/uuid.dart';

var _scrollController = ScrollController();

_scrollToBottom() {
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
}

class Meeting extends StatefulWidget {
  final bool isBroadcaster;
  final String? token;
  final bool? isFrontCamera;
  final bool? isMuted;

  const Meeting(
      {Key? key,
      required this.isBroadcaster,
      this.isFrontCamera = true,
      this.isMuted = true,
      this.token})
      : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  String channelName = "TestChannel";

  // String channel = DateTime.now().toIso8601String();
  final ChatBloc _chatBloc = injector.get<ChatBloc>();
  bool ready = false;

  @override
  void initState() {
    _initAgora("");
    _chatBloc.add(GenerateAgoraToken(
        channelName: const Uuid().v1(),
        uid: Random().nextInt(1000000).toString()));

    super.initState();
  }

  @override
  void dispose() {
    _engine?.destroy();
    // _client.destroy();
    super.dispose();
  }

  Future<void> _initAgora(String token) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(Constants.agoraAppId);

    // Enable Agora Video and Video Preview
    await _engine?.enableVideo();
    await _engine?.startPreview();

    // Toggle Microphone
    if (widget.isMuted!) {
      await _engine?.enableLocalAudio(false);
    } else {
      await _engine?.enableLocalAudio(true);
    }

    // Here we set the channel profile for the Video Call
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine?.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine?.setClientRole(ClientRole.Audience);
    }

    _engine?.setEventHandler(
      _handleEvents(),
    );

    await _engine?.joinChannel(token, channelName, null, 0);
    if (widget.isBroadcaster) {
      await _engine?.muteAllRemoteAudioStreams(true);
    }
  }

  RtcEngineEventHandler _handleEvents() {
    return RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        logInfo("local user $uid joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        logInfo("remote user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        logInfo("remote user $uid left channel");
        setState(() {
          _remoteUid = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: _chatBloc,
        listener: (context, state) {
          if (state is ChatMessageLoading) {
            AppUtils.showAnimatedProgressDialog(context,
                title: "Joining Livechat...");
          }
          if (state is AgoraTokenGotten) {
            Navigator.of(context).pop();
            logger.log("Agora Token: ${state.token}");
            // _joinLiveStream(state.token);
          }
          if (state is AgoraTokenFailed) {
            Navigator.of(context).pop();
            logger.log("Agora Token Failed: ${state.error}");
          }
        },
        builder: (context, state) {
          if (state is AgoraTokenGotten) {
            return LiveStreamWidget(
                widget: widget,
                remoteUid: _remoteUid,
                engine: _engine,
                channelName: channelName,
                localUserJoined: _localUserJoined);
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator.adaptive(),
              Text("Please wait, initializing chat..."),
            ],
          ));
        },
      ),
    );
  }

  void logInfo(String s) {
    logger.log(s);
  }
}

class LiveStreamWidget extends StatelessWidget {
  const LiveStreamWidget({
    Key? key,
    required this.widget,
    required int? remoteUid,
    required this.channelName,
    this.engine,
    required bool localUserJoined,
  })  : _remoteUid = remoteUid,
        _localUserJoined = localUserJoined,
        super(key: key);

  final Meeting widget;
  final int? _remoteUid;
  final RtcEngine? engine;
  final String channelName;
  final bool _localUserJoined;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!widget.isBroadcaster && _remoteUid != null)
          Center(
            child: RemoteUserView(engine, channelName, _remoteUid),
          ),
        if (!widget.isBroadcaster && _remoteUid == null)
          const LiveEndedWidget(),
        if (widget.isBroadcaster)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: _localUserJoined
                    ? LocalUserView(engine, channelName)
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

class RemoteUserView extends StatefulWidget {
  final RtcEngine? engine;
  final String channelName;
  final bool? isMicOn;
  final int? remoteUid;

  const RemoteUserView(
    this.engine,
    this.channelName,
    this.remoteUid, {
    Key? key,
    this.isMicOn = false,
  }) : super(key: key);

  @override
  State<RemoteUserView> createState() => _RemoteUserViewState();
}

class _RemoteUserViewState extends State<RemoteUserView> {
  final ChatBloc _chatBloc = ChatBloc(injector.get());
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  final ValueNotifier<bool> _isTextFocusedNotifier = ValueNotifier(false);

  final ValueNotifier<bool> _activeLiveNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _chatBloc.add(FetchLiveChannelMessages(channelName: widget.channelName));
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CacheCubit, CacheState>(
      bloc: injector.get<CacheCubit>()..fetchCachedUserData(),
      buildWhen: (p, c) => c is CachedUserDataFetched,
      builder: (context, state) {
        CachedUser userData = (state as CachedUserDataFetched).cachedUser;
        return Stack(
          children: [
            rtc_remote_view.SurfaceView(
                uid: widget.remoteUid!, channelId: widget.channelName),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 35, left: 8),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.red,
                        child: const Text("● Live",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )),
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: BlocConsumer<ChatBloc, ChatState>(
                            bloc: _chatBloc,
                            buildWhen: (previous, current) {
                              return current is LiveChannelMessagesFetched;
                            },
                            listener: (context, state) {
                              if (state is LiveChannelMessagesFetched) {
                                WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) => _scrollToBottom());
                              }
                            },
                            builder: (context, state) {
                              if (state is LiveChannelMessagesFetched) {
                                final List<LiveChatMessage> messages =
                                    state.messages;
                                return ListView.builder(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: messages.length,
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleImage(
                                                url: messages[index]
                                                    .userCoverPhoto,
                                                withBaseUrl: false,
                                              ),
                                              const SizedBox(
                                                width: 16.0,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      color: Colors.white
                                                          .withOpacity(0.1)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        messages[index]
                                                            .username,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        messages[index].message,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      );
                                    });
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(8.0),
                      //   margin: const EdgeInsets.all(32.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(0.5),
                      //     borderRadius: BorderRadius.circular(16.0),
                      //   ),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       ListView(
                      //         // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           IconButton(
                      //               onPressed: () {},
                      //               icon: const Icon(
                      //                 Icons.emoji_emotions_outlined,
                      //                 color: Colors.white,
                      //               )),
                      //           FloatingActionButton(
                      //             onPressed: () {
                      //               widget.engine?.stopPreview();
                      //               widget.engine?.leaveChannel();
                      //               widget.engine?.destroy();
                      //               Navigator.of(context).pop();
                      //             },
                      //             backgroundColor: Colors.red,
                      //             child: const Icon(
                      //               Icons.call_end,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           IconButton(
                      //               onPressed: () {
                      //                 showBottomSheet(
                      //                     context: context,
                      //                     // expand: false,
                      //                     builder: (ctx) {
                      //                       return CommentBox(
                      //                           focused: true,
                      //                           profilePhotoPath: '',
                      //                           onCommentSent: (msg) {
                      //                             _chatBloc.add(
                      //                                 SendLiveChannelMessage(
                      //                                     message: LiveChatMessage(
                      //                                       message: msg,
                      //                                       username:
                      //                                           userData.username!,
                      //                                       firstName:
                      //                                           userData.firstname!,
                      //                                       lastName:
                      //                                           userData.lastname!,
                      //                                       email: userData.email!,
                      //                                       userCoverPhoto: userData
                      //                                           .coverPhotoPath,
                      //                                       userPhoto: userData
                      //                                           .profilePhotoPath,
                      //                                       userId: userData.id,
                      //                                       timestamp: DateTime
                      //                                               .now()
                      //                                           .millisecondsSinceEpoch,
                      //                                     ),
                      //                                     channelName:
                      //                                         widget.channelName));
                      //                             Navigator.of(context).pop();
                      //                           });
                      //                     });
                      //               },
                      //               icon: const Icon(
                      //                 Icons.messenger_rounded,
                      //                 color: Colors.white,
                      //               ))
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // margin: const EdgeInsets.all(32.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: KeyboardVisibilityBuilder(
                              builder: (BuildContext context, Widget child,
                                  bool isKeyboardVisible) {
                                WidgetsBinding.instance
                                    ?.addPostFrameCallback((timeStamp) {
                                  _isTextFocusedNotifier.value =
                                      isKeyboardVisible;
                                });
                                return child;
                              },
                              child: TextField(
                                controller: _textController,
                                focusNode: _textFocus,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.name,
                                onSubmitted: (val) {
                                  if (val.isNotEmpty) {
                                    _chatBloc.add(SendLiveChannelMessage(
                                        message: LiveChatMessage(
                                          message: val,
                                          username: userData.username!,
                                          firstName: userData.firstname!,
                                          lastName: userData.lastname!,
                                          email: userData.email!,
                                          userCoverPhoto:
                                              userData.coverPhotoPath,
                                          userPhoto: userData.profilePhotoPath,
                                          userId: userData.id,
                                          timestamp: DateTime.now()
                                              .millisecondsSinceEpoch,
                                        ),
                                        channelName: widget.channelName));
                                    _textController.clear();
                                    _textFocus.unfocus();
                                  }
                                },
                                maxLines: 1,
                                minLines: 1,
                                style: const TextStyle(
                                    // height: 2,
                                    fontSize: 14,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    hintText: "Write comment here...",
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.white))),
                              ),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: _isTextFocusedNotifier,
                              builder: (context, value, snapshot) {
                                return Visibility(
                                  visible: !value,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.emoji_emotions_outlined,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class LocalUserView extends StatefulWidget {
  final RtcEngine? engine;
  final String channelName;
  final bool? isMicOn;

  const LocalUserView(
    this.engine,
    this.channelName, {
    Key? key,
    this.isMicOn = false,
  }) : super(key: key);

  @override
  State<LocalUserView> createState() => _LocalUserViewState();
}

class _LocalUserViewState extends State<LocalUserView> {
  bool _isMicOn = true;

  final ChatBloc _chatBloc = ChatBloc(injector.get());
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  final ValueNotifier<bool> _isTextFocusedNotifier = ValueNotifier(false);

  final ValueNotifier<bool> _activeLiveNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _textFocus.addListener(() {
      // _isTextFocusedNotifier.value = _textFocus.hasFocus;
    });
    _chatBloc.add(FetchLiveChannelMessages(channelName: widget.channelName));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _activeLiveNotifier.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CacheCubit, CacheState>(
      bloc: injector.get<CacheCubit>()..fetchCachedUserData(),
      buildWhen: (p, c) => c is CachedUserDataFetched,
      builder: (context, state) {
        CachedUser userData = (state as CachedUserDataFetched).cachedUser;
        ChatRepository(injector.get()).broadcastLiveVideo(
            message: "${userData.fullname} started a live video.");
        return WillPopScope(
          onWillPop: () async {
            if (_activeLiveNotifier.value) {
              _showCloseVideoDialog(context);
              return false;
            }
            return true;
          },
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: WidgetsBinding.instance!.window.viewInsets.bottom),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const rtc_local_view.SurfaceView()),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _activeLiveNotifier,
                  builder: (context, value, child) {
                    return Visibility(
                      visible: value,
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(top: 35),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      color: Colors.red,
                                      child: const Text("● Live",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              _showInviteDialog(context);
                                            },
                                            icon: const Icon(
                                              Icons.person_add_outlined,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              _showCloseVideoDialog(context);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: BlocConsumer<ChatBloc, ChatState>(
                                  bloc: _chatBloc,
                                  buildWhen: (previous, current) {
                                    return current
                                        is LiveChannelMessagesFetched;
                                  },
                                  listener: (context, state) {
                                    if (state is LiveChannelMessagesFetched) {
                                      WidgetsBinding.instance
                                          ?.addPostFrameCallback(
                                              (_) => _scrollToBottom());
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LiveChannelMessagesFetched) {
                                      final List<LiveChatMessage> messages =
                                          state.messages;
                                      return ListView.builder(
                                          controller: _scrollController,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: messages.length,
                                          itemBuilder: (ctx, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleImage(
                                                      url: messages[index]
                                                          .userCoverPhoto,
                                                      withBaseUrl: false,
                                                    ),
                                                    const SizedBox(
                                                      width: 16.0,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.1)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              messages[index]
                                                                  .username,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              messages[index]
                                                                  .message,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            );
                                          });
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              // margin: const EdgeInsets.all(32.0),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: KeyboardVisibilityBuilder(
                                        builder: (BuildContext context,
                                            Widget child,
                                            bool isKeyboardVisible) {
                                          WidgetsBinding.instance
                                              ?.addPostFrameCallback(
                                                  (timeStamp) {
                                            _isTextFocusedNotifier.value =
                                                isKeyboardVisible;
                                          });
                                          return child;
                                        },
                                        child: TextField(
                                          controller: _textController,
                                          focusNode: _textFocus,
                                          textInputAction: TextInputAction.send,
                                          keyboardType: TextInputType.name,
                                          onSubmitted: (val) {
                                            if (val.isNotEmpty) {
                                              _chatBloc.add(
                                                  SendLiveChannelMessage(
                                                      message: LiveChatMessage(
                                                        message: val,
                                                        username:
                                                            userData.username!,
                                                        firstName:
                                                            userData.firstname!,
                                                        lastName:
                                                            userData.lastname!,
                                                        email: userData.email!,
                                                        userCoverPhoto: userData
                                                            .coverPhotoPath,
                                                        userPhoto: userData
                                                            .profilePhotoPath,
                                                        userId: userData.id,
                                                        timestamp: DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch,
                                                      ),
                                                      channelName:
                                                          widget.channelName));
                                              _textController.clear();
                                              _textFocus.unfocus();
                                            }
                                          },
                                          maxLines: 1,
                                          minLines: 1,
                                          style: const TextStyle(
                                              // height: 2,
                                              fontSize: 14,
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              hintText: "Write comment here...",
                                              hintStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      16.0),
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.white)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.white)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  borderSide: const BorderSide(width: 1, color: Colors.white))),
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder<bool>(
                                        valueListenable: _isTextFocusedNotifier,
                                        builder: (context, value, snapshot) {
                                          return Visibility(
                                            visible: !value,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isMicOn = !_isMicOn;
                                                        widget.engine
                                                            ?.enableLocalAudio(
                                                                _isMicOn);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _isMicOn
                                                          ? Icons.mic_rounded
                                                          : Icons
                                                              .mic_off_outlined,
                                                      color: Colors.white,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      widget.engine
                                                          ?.switchCamera();
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .switch_camera_outlined,
                                                      color: Colors.white,
                                                    )),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons
                                                          .emoji_emotions_outlined,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        );
      },
    );
  }

  void _showCloseVideoDialog(BuildContext context) {
    AppUtils.showShowConfirmDialog(context,
        message: "Are you sure you want to end this video?",
        cancelButtonText: "Cancel",
        confirmButtonText: "End Video", onConfirmed: () async {
      await widget.engine?.destroy();
      Navigator.of(context).pop();
      _activeLiveNotifier.value = false;
    }, onCancel: () {
      Navigator.of(context).pop();
    });
  }

  void _showInviteDialog(BuildContext context) {
    ChatBloc chatBloc = ChatBloc(injector.get());
    int value = 0;
    final _inviteTypeNotifier = ValueNotifier<int>(0);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Invite"),
            content: ValueListenableBuilder<int>(
                valueListenable: _inviteTypeNotifier,
                builder: (context, val, child) {
                  logger.log("VAL: $value");
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Invite your contacts to join this video"),
                      const SizedBox(height: 10),
                      RadioListTile<int>(
                          value: 0,
                          groupValue: value,
                          onChanged: (v) {
                            value = v!;
                            _inviteTypeNotifier.value = 0;
                          },
                          title: const Text("Invite by Followers")),
                      RadioListTile<int>(
                          value: 1,
                          groupValue: value,
                          onChanged: (v) {
                            value = v!;
                            _inviteTypeNotifier.value = 1;
                          },
                          title: const Text("Invite by Connects")),
                      RadioListTile<int>(
                          value: 2,
                          groupValue: value,
                          onChanged: (v) {
                            value = v!;
                            _inviteTypeNotifier.value = 2;
                          },
                          title: const Text("Invite All")),
                    ],
                  );
                }),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              BlocConsumer<ChatBloc, ChatState>(
                bloc: chatBloc,
                listener: (context, state) {
                  if (state is InviteSent) {
                    Navigator.of(ctx).pop();
                    AppUtils.showCustomToast("Invitation sent successfully");
                  }
                  if (state is ChatError) {
                    AppUtils.showCustomToast(state.errorModel.errorMessage);
                  }
                },
                builder: (context, state) {
                  return TextButton(
                    child: Text(
                      state is ChatMessageLoading ? "Inviting..." : "Invite",
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                    onPressed: state is ChatMessageLoading
                        ? null
                        : () {
                            chatBloc.add(SendInviteEvent(
                                channelName: widget.channelName,
                                inviteType: value == 0
                                    ? "followers"
                                    : value == 1
                                        ? "connections"
                                        : "all"));
                          },
                  );
                },
              ),
            ],
          );
        });
  }
}

class LiveEndedWidget extends StatelessWidget {
  const LiveEndedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.primaryColor.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.stop_screen_share,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10),
          const Text("This Live has ended",
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Widget child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    required this.child,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance?.window.viewInsets.bottom;
    final newValue = bottomInset! > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}
