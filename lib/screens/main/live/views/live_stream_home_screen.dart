import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:creative_movers/app_config.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/live/views/join_meeting.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class LiveStreamHomeScreen extends StatefulWidget {
  final bool isBroadcaster;

  const LiveStreamHomeScreen({Key? key, required this.isBroadcaster})
      : super(key: key);

  @override
  State<LiveStreamHomeScreen> createState() => _LiveStreamHomeScreenState();
}

class _LiveStreamHomeScreenState extends State<LiveStreamHomeScreen> {
  bool ready = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !ready && widget.isBroadcaster
            ? const LiveStreamPrepScreen()
            : Meeting(
                isBroadcaster: widget.isBroadcaster,
              ));
  }
}

class LiveStreamPrepScreen extends StatefulWidget {
  const LiveStreamPrepScreen({Key? key}) : super(key: key);

  @override
  State<LiveStreamPrepScreen> createState() => _LiveStreamPrepScreenState();
}

class _LiveStreamPrepScreenState extends State<LiveStreamPrepScreen>
    with WidgetsBindingObserver {
  CameraController? cameraController;

  bool _isMicOn = false;
  bool _isFrontCamera = true;

  final ChatBloc _chatBloc = injector.get<ChatBloc>();

  @override
  void initState() {
    super.initState();
    // log("CAMES: ${cameras.length}");
    cameraController = CameraController(
      _isFrontCamera ? cameras[1] : cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (cameraController!.value.isInitialized)
          CameraPreview(
            cameraController!,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.08,
                        horizontal: 16.0),
                    child: Card(
                      elevation: 0.5,
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white)),
                              const Text(
                                "Before Start",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _isFrontCamera = !_isFrontCamera;
                                    cameraController = CameraController(
                                      _isFrontCamera ? cameras[1] : cameras[0],
                                      ResolutionPreset.high,
                                      enableAudio: false,
                                      imageFormatGroup: ImageFormatGroup.jpeg,
                                    );
                                    cameraController!.initialize().then((_) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {});
                                    });
                                  },
                                  child: const Icon(Icons.cameraswitch_outlined,
                                      color: Colors.white)),
                            ]),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Microphone",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Would you like to enable microphone?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                      child: SvgPicture.asset('assets/svgs/microphone.svg')),
                  SizedBox(
                    width: 100,
                    height: 65,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoSwitch(
                          value: _isMicOn,
                          activeColor: AppColors.primaryColor,
                          trackColor: AppColors.black.withOpacity(0.6),
                          onChanged: (value) {
                            setState(() {
                              _isMicOn = value;
                            });
                          }),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocConsumer<ChatBloc, ChatState>(
                      bloc: _chatBloc,
                      listener: (context, state) {
                        if (state is AgoraTokenGotten) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Meeting(
                                      isBroadcaster: true,
                                      token: state.token,
                                      isFrontCamera: _isFrontCamera,
                                      isMuted: !_isMicOn)));
                        }
                        if (state is AgoraTokenFailed) {
                          AppUtils.showCustomToast(state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          onTap: state is ChatMessageLoading
                              ? null
                              : () {
                                  _chatBloc.add(const GenerateAgoraToken(
                                      channelName: "CreativeMovers"));
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state is ChatMessageLoading
                                    ? "Preparing"
                                    : "Lets Go →",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              state is ChatMessageLoading
                                  ? const SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : Container()
                            ],
                          ),
                          color: AppColors.primaryColor,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = this.cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // onNewCameraSelected(cameraController.description);
    }
  }
}
