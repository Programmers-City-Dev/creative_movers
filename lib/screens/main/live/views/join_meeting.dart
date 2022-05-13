import 'dart:developer' as logger;
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/enums.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
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
  late AgoraRtmClient _client;
  int? _remoteUid;
  bool _localUserJoined = false;

  String channel = "TestChannel";
  // String channel = DateTime.now().toIso8601String();

  final ChatBloc _chatBloc = injector.get<ChatBloc>();
  bool ready = false;

  @override
  void initState() {
    _chatBloc.add(GenerateAgoraToken(
        channelName: const Uuid().v1(),
        uid: Random().nextInt(1000000).toString()));
    _initAgora("");
    super.initState();
  }

  @override
  void dispose() {
    _engine.destroy();
    _client.destroy();
    super.dispose();
  }

  Future<void> _initAgora(String token) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    //create the engine
    _engine = await RtcEngine.create(Constants.agoraAppId);
    _client = await AgoraRtmClient.createInstance(Constants.agoraAppId);
    await _engine.enableVideo();
    await _engine.startPreview();
    if (widget.isMuted!) {
      await _engine.enableLocalAudio(false);
    } else {
      await _engine.enableLocalAudio(true);
    }

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    _engine.setEventHandler(
      _handleEvents(),
    );

    _client.onConnectionStateChanged = ((state, reason) {});
    await _engine.joinChannel(token, channel, null, 0);
    if (widget.isBroadcaster) {
      await _engine.muteAllRemoteAudioStreams(true);
    }
  }

  RtcEngineEventHandler _handleEvents() {
    return RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        logger.log("local user $uid joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      userJoined: (int uid, int elapsed) {
        logger.log("remote user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        logger.log("remote user $uid left channel");
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
          if (state is ChatLoading) {
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
              if (!widget.isBroadcaster)
                Center(
                  child: _remoteVideo(),
                ),
              if (widget.isBroadcaster)
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: _localUserJoined
                          ? LocalUserView(_engine)
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
                        const Text(
                          'Agora Video Call',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
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
        channelId: channel,
      );
    } else {
      return const Text(
        'Please wait for remote Host starts the Livestream',
        textAlign: TextAlign.center,
      );
    }
  }

  void _joinLiveStream(String token) async {
    // await _engine.joinChannel(token, channel, null, 0);
    _initAgora(token);
  }
}

class LocalUserView extends StatefulWidget {
  final RtcEngine engine;
  final bool? isMicOn;

  const LocalUserView(
    this.engine, {
    Key? key,
    this.isMicOn = false,
  }) : super(key: key);

  @override
  State<LocalUserView> createState() => _LocalUserViewState();
}

class _LocalUserViewState extends State<LocalUserView> {
  bool _isMicOn = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const rtc_local_view.SurfaceView(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
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
                      _isMicOn ? Icons.mic_rounded : Icons.mic_off_outlined,
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
                      _showCommentBox();
                    },
                    icon: const Icon(
                      Icons.messenger_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showCommentBox() {
    showBottomSheet(
        context: context,
        // expand: false,
        builder: (ctx) {
          return CommentBox(
              focused: true,
              profilePhotoPath: '',
              onCommentSent: (msg) {
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
