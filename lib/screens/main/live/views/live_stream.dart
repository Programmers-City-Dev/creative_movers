import 'dart:developer' as logger;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/live_chat_message.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

var _scrollController = ScrollController();

_scrollToBottom() {
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
}

int? _remoteUid;
RemoteVideoState? _remoteUserState;

class LiveStream extends StatefulWidget {
  final bool isBroadcaster;
  final int broadcastId;
  final String? token;
  final bool? isFrontCamera;
  final bool? isMuted;
  final String? channel;

  const LiveStream({
    Key? key,
    required this.isBroadcaster,
    required this.broadcastId,
    this.isFrontCamera = true,
    this.isMuted = true,
    this.token,
    this.channel,
  }) : super(key: key);

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  RtcEngine? _engine;

  bool _localUserJoined = false;

  String? channelName;

  // String channel = DateTime.now().toIso8601String();
  final ChatBloc _chatBloc = injector.get<ChatBloc>();

  // bool ready = false;

  @override
  void initState() {
    super.initState();
    logger.log("Channel: ${widget.channel}");
    if (widget.channel != null) {
      channelName = widget.channel!;
    } else {
      channelName = "TestChannel";
    }
    _initAgora();
    // if (widget.token == null) {
    //   _chatBloc.add(GenerateAgoraToken(
    //       channelName: channelName!,
    //       uid: "0"));
    // }

    logger.log("Broadcast Id: ${widget.broadcastId}");
  }

  @override
  void dispose() {
    _engine?.release();
    super.dispose();
  }

  Future<void> _initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine?.initialize(const RtcEngineContext(
      appId: Constants.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Enable Agora Video and Video Preview
    await _engine?.enableVideo();
    await _engine?.startPreview();

    // Enable wakelock
    Wakelock.enable();

    // Toggle Microphone
    if (widget.isMuted!) {
      await _engine?.enableLocalAudio(false);
    } else {
      await _engine?.enableLocalAudio(true);
    }

    // Here we set the channel profile for the Video Call
    await _engine
        ?.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine?.setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    _engine?.registerEventHandler(RtcEngineEventHandler(
      onConnectionStateChanged: (connection, state, reason) {
        logInfo("Connection State Changed: $state, Reason:$reason");
      },
      onJoinChannelSuccess: (RtcConnection conn, int uid) {
        logInfo("onJoinChannelSuccess: user $uid joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      onUserJoined: (RtcConnection conn, int uid, int elapsed) {
        logInfo("onUserJoined: user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      onLeaveChannel: (connection, stats) {
        logInfo("leave channel: ${stats.toJson()}");
        // setState(() {
        //   _localUserJoined = false;
        // });
      },
      onUserOffline:
          (RtcConnection conn, int uid, UserOfflineReasonType reason) {
        logger.log("UserId: $uid left channel, Reason: $reason",
            name: "user offline");
        setState(() {
          _remoteUid = null;
        });
      },
      onUserStateChanged: (connection, remoteUid, state) {},
      onLocalVideoStateChanged: (source, state, error) {
        logInfo("local video state changed");
      },
      onRemoteVideoStateChanged: (RtcConnection conn, x, RemoteVideoState state,
          RemoteVideoStateReason reason, i) {
        logInfo("remote user $state video state changed");
        if (state == RemoteVideoState.remoteVideoStateDecoding) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateDecoding;
          });
        } else if (state == RemoteVideoState.remoteVideoStateStopped) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateStopped;
          });
        } else if (state == RemoteVideoState.remoteVideoStateFrozen) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateFrozen;
          });
        }
      },
    ));
    if (widget.isBroadcaster) {
      await _engine?.muteAllRemoteAudioStreams(true);
    }
    if (widget.token != null) {
      await _joinChannel(widget.token!);
    } else {
      _chatBloc.add(GenerateAgoraToken(channelName: channelName!, uid: "0"));
    }
  }

  Future<void> _joinChannel(String token) async {
    await _engine?.joinChannel(
        channelId: channelName!,
        options: ChannelMediaOptions(
            // token: token,
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
            clientRoleType: widget.isBroadcaster
                ? ClientRoleType.clientRoleBroadcaster
                : ClientRoleType.clientRoleAudience,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
            defaultVideoStreamType: VideoStreamType.videoStreamLow),
        uid: injector.get<CacheCubit>().cachedUser?.id ?? 0,
        token: token);
  }

  RtcEngineEventHandler _handleEvents() {
    return RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection conn, int uid) {
        logInfo("local user $uid joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      onUserJoined: (RtcConnection conn, int uid, int elapsed) {
        logInfo("remote user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      onUserOffline:
          (RtcConnection conn, int uid, UserOfflineReasonType reason) {
        logInfo("remote user $uid left channel");
        setState(() {
          _remoteUid = null;
        });
      },
      onRemoteVideoStateChanged: (RtcConnection conn, x, RemoteVideoState state,
          RemoteVideoStateReason reason, i) {
        logInfo("remote user $state video state changed");
        if (state == RemoteVideoState.remoteVideoStateDecoding) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateDecoding;
          });
        } else if (state == RemoteVideoState.remoteVideoStateStopped) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateStopped;
          });
        } else if (state == RemoteVideoState.remoteVideoStateFrozen) {
          setState(() {
            _remoteUserState = RemoteVideoState.remoteVideoStateFrozen;
          });
        }
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
            // AppUtils.showAnimatedProgressDialog(context,
            //     title: "Joining Livechat...");
          }
          if (state is AgoraTokenGotten) {
            // Navigator.of(context).pop();
            logger.log("Agora Token: ${state.token}");
            _joinChannel(state.token);
            // _joinLiveStream(state.token);
          }
          if (state is AgoraTokenFailed) {
            // Navigator.of(context).pop();
            logger.log("Agora Token Failed: ${state.error}");
          }
        },
        builder: (context, state) {
          // if (state is AgoraTokenGotten) {
          return LiveStreamWidget(
              widget: widget,
              // remoteUid: _remoteUid,
              engine: _engine,
              channelName: channelName!,
              localUserJoined: _localUserJoined);
          // }
          // return Center(
          //     child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: const [
          //     CircularProgressIndicator.adaptive(),
          //     SizedBox(
          //       height: 16.0,
          //     ),
          //     Text("Please wait, initializing video..."),
          //   ],
          // ));
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
    // required int? remoteUid,
    required this.channelName,
    this.engine,
    required bool localUserJoined,
  })  : _localUserJoined = localUserJoined,
        super(key: key);

  final LiveStream widget;

  // final int? _remoteUid;
  final RtcEngine? engine;
  final String channelName;
  final bool _localUserJoined;

  @override
  Widget build(BuildContext context) {
    logger.log(
        "Is broadcaster: ${widget.isBroadcaster}\nRemote User ID: $_remoteUid",
        name: "LiveChat");
    return Stack(
      children: [
        if (!widget.isBroadcaster && _remoteUserState == RemoteVideoState.remoteVideoStateDecoding && _remoteUid != null)

          Center(
            child: RemoteUserView(engine, channelName, _remoteUid),
          ),

        if (!widget.isBroadcaster && _remoteUserState == RemoteVideoState.remoteVideoStateStopped)

          const LiveEndedWidget(),

        if (!widget.isBroadcaster && (_remoteUserState != RemoteVideoState.remoteVideoStateDecoding && _remoteUserState != RemoteVideoState.remoteVideoStateStopped))

          const Center(
            child: CircularProgressIndicator(),
          ),
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
    injector.get<CacheCubit>().fetchCachedUserData();
    _chatBloc.add(ListenToLiveChatEvent(widget.channelName));
  }

  @override
  void dispose() {
    _chatBloc.close();
    widget.engine?.leaveChannel();
    widget.engine?.release();
    // Disables the wakelock again.
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CacheCubit, CacheState>(
      bloc: injector.get<CacheCubit>(),
      buildWhen: (p, c) => c is CachedUserDataFetched,
      builder: (context, state) {
        CachedUser userData = (state as CachedUserDataFetched).cachedUser;
        return WillPopScope(
          onWillPop: () async {
            if (_activeLiveNotifier.value) {
              _showCloseVideoDialog(context, onConfirmed: () {
                widget.engine?.leaveChannel();
                widget.engine?.release();
                Navigator.of(context).pop();
                _activeLiveNotifier.value = false;
              });
              return false;
            }
            return true;
          },
          child: Stack(
            children: [
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: widget.engine!,
                  canvas: VideoCanvas(uid: widget.remoteUid!),
                  connection: RtcConnection(channelId: widget.channelName),
                ),
              ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: BlocConsumer<ChatBloc, ChatState>(
                              bloc: _chatBloc,
                              buildWhen: (previous, current) {
                                return current is LiveChannelMessagesFetched;
                              },
                              listener: (context, state) {
                                if (state is LiveChannelMessagesFetched) {
                                  WidgetsBinding.instance.addPostFrameCallback(
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
                                                      .user
                                                      ?.profilePhotoPath,
                                                  withBaseUrl: false,
                                                ),
                                                const SizedBox(
                                                  width: 16.0,
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: Colors.white
                                                            .withOpacity(0.1)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${messages[index].user?.firstname} ${messages[index].user?.lastname}',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Text(
                                                          '${messages[index].message}',
                                                          style:
                                                              const TextStyle(
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
                                      .addPostFrameCallback((timeStamp) {
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
                                          message: val,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
          ),
        );
      },
    );
  }

  void _showCloseVideoDialog(BuildContext context,
      {required VoidCallback onConfirmed}) {
    AppUtils.showConfirmDialog(
      context,
      message: "Are you sure you want to leave this live?",
      cancelButtonText: "Cancel",
      confirmButtonText: "Leave Video",
    ).then((value) {
      if (value) {
        onConfirmed.call();
      }
    });
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
    _chatBloc.add(ListenToLiveChatEvent(widget.channelName));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _activeLiveNotifier.value = true;
    widget.engine?.leaveChannel();
    widget.engine?.release();
    // Disables the wakelock again.
    Wakelock.disable();
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
                    bottom: WidgetsBinding.instance.window.viewInsets.bottom),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: widget.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: ValueListenableBuilder<
                                            List<LiveChatMessage>>(
                                        valueListenable:
                                            _chatBloc.liveChatMessagesNotifier,
                                        // buildWhen: (previous, current) {
                                        //   return current
                                        //       is LiveChannelMessagesFetched;
                                        // },
                                        // listener: (context, state) {
                                        //   if (state
                                        //       is LiveChannelMessagesFetched) {
                                        //     WidgetsBinding.instance
                                        //         .addPostFrameCallback(
                                        //             (_) => _scrollToBottom());
                                        //   }
                                        // },
                                        builder: (context, messages, child) {
                                          return ListView.builder(
                                              controller: _scrollController,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: messages.length,
                                              itemBuilder: (ctx, index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleImage(
                                                          url: messages[index]
                                                              .user
                                                              ?.profilePhotoPath,
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
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.1)),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${messages[index].user?.firstname} ${messages[index].user?.lastname}',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  '${messages[index].message}',
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
                                        }),
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
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                _isTextFocusedNotifier.value =
                                                    isKeyboardVisible;
                                              });
                                              return child;
                                            },
                                            child: TextField(
                                              controller: _textController,
                                              focusNode: _textFocus,
                                              textInputAction:
                                                  TextInputAction.send,
                                              keyboardType: TextInputType.name,
                                              onSubmitted: (val) {
                                                if (val.isNotEmpty) {
                                                  _chatBloc.add(
                                                      SendLiveChannelMessage(
                                                          message: val,
                                                          channelName: widget
                                                              .channelName));
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
                                                  hintText:
                                                      "Write comment here...",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(width: 1, color: Colors.white))),
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                            valueListenable:
                                                _isTextFocusedNotifier,
                                            builder:
                                                (context, value, snapshot) {
                                              return Visibility(
                                                visible: !value,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _isMicOn =
                                                                !_isMicOn;
                                                            widget.engine
                                                                ?.enableLocalAudio(
                                                                    _isMicOn);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          _isMicOn
                                                              ? Icons
                                                                  .mic_rounded
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
                                                    // IconButton(
                                                    //     onPressed: () {},
                                                    //     icon: const Icon(
                                                    //       Icons
                                                    //           .emoji_emotions_outlined,
                                                    //       color: Colors.white,
                                                    //     )),
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
    AppUtils.showConfirmDialog(
      context,
      message: "Are you sure you want to end this video?",
      cancelButtonText: "Cancel",
      confirmButtonText: "End Video",
    ).then((value) {
      if (value) {
        Navigator.of(context).pop();
        _activeLiveNotifier.value = false;
      }
    });
  }

  void _showInviteDialog(BuildContext context) {
    ChatBloc chatBloc = ChatBloc(injector.get());
    int value = 0;
    final inviteTypeNotifier = ValueNotifier<int>(0);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Invite"),
            content: ValueListenableBuilder<int>(
                valueListenable: inviteTypeNotifier,
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
                            inviteTypeNotifier.value = 0;
                          },
                          title: const Text("Invite by Followers")),
                      RadioListTile<int>(
                          value: 1,
                          groupValue: value,
                          onChanged: (v) {
                            value = v!;
                            inviteTypeNotifier.value = 1;
                          },
                          title: const Text("Invite by Connects")),
                      RadioListTile<int>(
                          value: 2,
                          groupValue: value,
                          onChanged: (v) {
                            value = v!;
                            inviteTypeNotifier.value = 2;
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
                    child: Text(
                      state is ChatMessageLoading ? "Inviting..." : "Invite",
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
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
          const Text("This Live has ended", style: TextStyle(fontSize: 18)),
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
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
