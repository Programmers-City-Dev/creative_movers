import 'dart:developer' as logger;
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/live_chat_message.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/enums.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:uuid/uuid.dart';

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
  late RtcEngine _engine;
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
    _engine.destroy();
    // _client.destroy();
    super.dispose();
  }

  Future<void> _initAgora(String token) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(Constants.agoraAppId);

    // Enable Agora Video and Video Preview
    await _engine.enableVideo();
    await _engine.startPreview();

    // Toggle Microphone
    if (widget.isMuted!) {
      await _engine.enableLocalAudio(false);
    } else {
      await _engine.enableLocalAudio(true);
    }

    // Here we set the channel profile for the Video Call
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine.setClientRole(ClientRole.Audience);
    }

    _engine.setEventHandler(
      _handleEvents(),
    );

    await _engine.joinChannel(token, channelName, null, 0);
    if (widget.isBroadcaster) {
      await _engine.muteAllRemoteAudioStreams(true);
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
          return Stack(
            children: [
              if (!widget.isBroadcaster && _remoteUid != null)
                Center(
                  child: RemoteUserView(_engine, channelName, _remoteUid),
                ),
              if (widget.isBroadcaster)
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: _localUserJoined
                          ? LocalUserView(_engine, channelName)
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 35),
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
                        // const Text(
                        //   'Agora Video Call',
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.group_outlined,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return rtc_remote_view.SurfaceView(
        uid: _remoteUid!,
        channelId: channelName,
      );
    } else {
      return const Text(
        'Please wait for remote Host starts the Livestream',
        textAlign: TextAlign.center,
      );
    }
  }

  void logInfo(String s) {
    logger.log(s);
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
                uid: widget.remoteUid!,
                channelId: widget.channelName,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocConsumer<ChatBloc, ChatState>(
                          bloc: _chatBloc
                            ..add(FetchLiveChannelMessages(
                                channelName: widget.channelName)),
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is LiveChannelMessagesFetched) {
                              final List<LiveChatMessage> messages =
                                  state.messages;
                              return ListView.builder(
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      messages[index].username,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      messages[index].message,
                                                      style: const TextStyle(
                                                          color: Colors.white),
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
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ReactionButtonEx(
                                onReaction: (reactionType) {},
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  if (widget.engine != null) {
                                    widget.engine?.stopPreview();
                                    widget.engine?.leaveChannel();
                                    widget.engine?.destroy();
                                  }
                                },
                                backgroundColor: Colors.red,
                                child: const Icon(
                                  Icons.call_end,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showBottomSheet(
                                        context: context,
                                        // expand: false,
                                        builder: (ctx) {
                                          return CommentBox(
                                              focused: true,
                                              profilePhotoPath: '',
                                              onCommentSent: (msg) {
                                                _chatBloc.add(
                                                    SendLiveChannelMessage(
                                                        message:
                                                            LiveChatMessage(
                                                          message: msg,
                                                          username: userData
                                                              .username!,
                                                          firstName: userData
                                                              .firstname!,
                                                          lastName: userData
                                                              .lastname!,
                                                          email:
                                                              userData.email!,
                                                          userCoverPhoto: userData
                                                              .coverPhotoPath,
                                                          userPhoto: userData
                                                              .profilePhotoPath,
                                                          userId: userData.id,
                                                          timestamp: DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch,
                                                        ),
                                                        channelName: widget
                                                            .channelName));
                                                Navigator.of(context).pop();
                                              });
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.messenger_rounded,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

class LocalUserView extends StatefulWidget {
  final RtcEngine engine;
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

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.channel.getMembers().then((value) {
    //   logger.log("CHANNEL: ${value.first.userId}");
    // });
    return BlocBuilder<CacheCubit, CacheState>(
      bloc: injector.get<CacheCubit>()..fetchCachedUserData(),
      buildWhen: (p, c) => c is CachedUserDataFetched,
      builder: (context, state) {
        CachedUser userData = (state as CachedUserDataFetched).cachedUser;
        return Stack(
          children: [
            const rtc_local_view.SurfaceView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocConsumer<ChatBloc, ChatState>(
                        bloc: _chatBloc
                          ..add(FetchLiveChannelMessages(
                              channelName: widget.channelName)),
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is LiveChannelMessagesFetched) {
                            final List<LiveChatMessage> messages =
                                state.messages;
                            return ListView.builder(
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
                                            url: messages[index].userCoverPhoto,
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    messages[index].username,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    messages[index].message,
                                                    style: const TextStyle(
                                                        color: Colors.white),
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isMicOn = !_isMicOn;
                                    widget.engine.enableLocalAudio(_isMicOn);
                                  });
                                },
                                icon: Icon(
                                  _isMicOn
                                      ? Icons.mic_rounded
                                      : Icons.mic_off_outlined,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  widget.engine.switchCamera();
                                },
                                icon: const Icon(
                                  Icons.switch_camera_outlined,
                                  color: Colors.white,
                                )),
                            FloatingActionButton(
                              onPressed: () {
                                widget.engine.stopPreview();
                                widget.engine.leaveChannel();
                                widget.engine.destroy();
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                              ),
                            ),
                            ReactionButtonEx(
                              onReaction: (reactionType) {},
                            ),
                            IconButton(
                                onPressed: () {
                                  _showCommentBox((msg) {
                                    _chatBloc.add(SendLiveChannelMessage(
                                        message: LiveChatMessage(
                                          message: msg,
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
                                  });
                                },
                                icon: const Icon(
                                  Icons.messenger_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _showCommentBox(Function(String) onComment) {
    showBottomSheet(
        context: context,
        // expand: false,
        builder: (ctx) {
          return CommentBox(
              focused: true,
              profilePhotoPath: '',
              onCommentSent: (msg) {
                onComment(msg);
                Navigator.of(context).pop();
              });
        });
  }
}

class ReactionButtonEx extends StatelessWidget {
  const ReactionButtonEx({Key? key, required this.onReaction})
      : super(key: key);

  final Function(ReactionType) onReaction;

  @override
  Widget build(BuildContext context) {
    return ReactionButton<ReactionType>(
      onReactionChanged: (ReactionType? value) {},
      shouldChangeReaction: false,
      itemScale: 0.8,
      reactions: [
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset(
                "assets/images/like.gif",
                width: 32,
              ),
            ),
            value: ReactionType.like),
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset("assets/images/love.gif", width: 32),
            ),
            value: ReactionType.love),
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset("assets/images/angry.gif", width: 32),
            ),
            value: ReactionType.angry),
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset("assets/images/wow.gif", width: 32),
            ),
            value: ReactionType.wow),
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset("assets/images/sad.gif", width: 32),
            ),
            value: ReactionType.sad),
        Reaction(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: Image.asset("assets/images/haha.gif", width: 32),
            ),
            value: ReactionType.haha),
      ],
      initialReaction: Reaction<ReactionType>(
        value: ReactionType.like,
        icon: const Icon(
          Icons.emoji_emotions,
          color: Colors.white,
        ),
      ),
      boxColor: Colors.black.withOpacity(0.5),
      boxRadius: 10,
      boxDuration: const Duration(milliseconds: 300),
      itemScaleDuration: const Duration(milliseconds: 200),
    );
  }
}
