import 'dart:developer';

import 'package:creative_movers/blocs/status/status_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStatusScreen extends StatefulWidget {

  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  _AddStatusScreenState createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final StatusBloc _statusBloc = StatusBloc();
  Color bgColor = Colors.cyanAccent;

  int fontIndex = 0;
  int colorIndex = 0;
  String font = 'Lobster';

  List<String> fonts = [
    'Lobster',
    'Dancing_Script',
    'Syne_Mono'
        'Poppins',
    'Segoe',
  ];

  List<Color> colors =[
   const Color( 0xFF000000,)
  ];
  List<int> theme = [
    0xffC2185B,
    0xffC2185B,
    0xffCB6716,
    0xffCB1616,
    0xff16A102,
    0xffDB06E3,
    0xff000000

    // Colors.lightBlue,
    // Color(0xFFC2185B),
    // // Color(0xFF),
    // // Color(0xFF),
    // // Color(0xFF),
    // // Color(0xFF),
    // // Color(0xFF),
    // // Color(0xFF),
    // // Colors.amberAccent,
    // Colors.purple,
    // Colors.grey,
    // Colors.green,
    // Colors.cyan,
    // Colors.blueGrey
  ];

  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // changeSystemColor(bgColor);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatusBloc, StatusState>(
      bloc: _statusBloc,
      listener: (context, state) {
        _listenToUploadStatusStates(context, state);
      },
      child: Scaffold(
        backgroundColor: Color(theme[colorIndex]),
        floatingActionButton: Visibility(
          visible: _statusController.text.isNotEmpty,
          child: FloatingActionButton(
            onPressed: () {
              uploadStatus();
            },
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.send),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              child: TextFormField(
                controller: _statusController,
                onChanged: (text) {
                  setState(() {});
                },
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                minLines: null,
                expands: true,
                style: TextStyle(
                    fontSize: 40,
                    color: AppColors.white,
                    fontFamily: fonts[fontIndex]),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a status',
                  hintStyle:
                      TextStyle(fontSize: 40, color: AppColors.statusHintColor),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      switchColor();
                      // changeSystemColor(bgColor);
                    },
                    icon: const Icon(Icons.palette_rounded,
                        color: AppColors.lightBlue),
                  ),
                  IconButton(
                    onPressed: () {
                      switchTextStyle();
                    },
                    icon: const Icon(Icons.title_rounded,
                        color: AppColors.lightBlue),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void changeSystemColor(Color color) {
  //   SystemChrome.setSystemUIOverlayStyle(
  //       SystemUiOverlayStyle(statusBarColor: color));
  // }

  void switchColor() {
    // final random = Random();

    setState(() {

      if (colorIndex != theme.length - 1) {
        colorIndex += 1;
      } else {
        colorIndex = 0;
      }

      // bgColor = theme[random.nextInt(theme.length)];
    });
  }

  void switchTextStyle() {
    // final random = Random();

    setState(() {
      if (fontIndex != fonts.length - 1) {
        fontIndex += 1;
      } else {
        fontIndex = 0;
      }

      // font = fonts[random.nextInt(theme.length)];
    });
  }

  void uploadStatus() {
    if (_statusController.text.isEmpty) {
      AppUtils.showCustomToast('Add a text');
    } else {
      log(theme[colorIndex].toRadixString(16));

      _statusBloc.add(UploadStatusEvent(

          text: _statusController.text, bg_color: theme[colorIndex].toRadixString(16), font_name: font)

      );
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
      context.read<StatusBloc>().add(const GetStatusEvent());
      Navigator.popUntil(context,(route) => route.isFirst );

      // Navigator.popAndPushNamed(context,'/home/feeds');
      // Navigator.of(context).pushNamed(feedsPath);
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => HomeScreen(),
      // ));
      // _statusBloc.add(GetStatusEvent());

    }
  }
  bool untill (Route route){
    route.settings.copyWith(arguments: {'showWelcomeDialog':true}) ;
    return route.isFirst;
  }
}
