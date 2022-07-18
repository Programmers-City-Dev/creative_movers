import 'dart:developer';

import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/profile/views/profile_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/image_previewer.dart';
import 'package:creative_movers/screens/widget/widget_network_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key, this.user_id}) : super(key: key);
  final int? user_id;

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _profileBloc = injector.get<ProfileBloc>();
  final _connectsBloc = ConnectsBloc();
  late bool isFollowing;

  late String isConnected;

  @override
  void initState() {
    super.initState();
    log(widget.user_id.toString());
    widget.user_id == null
        ? _profileBloc.add(const FetchUserProfileEvent())
        : _profileBloc.add(FetchUserProfileEvent(widget.user_id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (ctx,state){
          if (state is ProfileLoadedState) {
            User user = state.user;
            log('ISFOLLOWING ${user.isFollowing.toString()}');
            log('ISCONNECTED ${user.isConnected.toString()}');
            isFollowing = user.isFollowing!;
            isConnected = user.isConnected!;}
        },
        bloc: _profileBloc,
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            User user = state.user;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 340,
                    child: Stack(
                      // clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 250,
                            color: AppColors.primaryColor,
                            // decoration: BoxDecoration(image: ()),
                            child: Hero(
                              tag: "cover_photo",
                              child: GestureDetector(
                                onTap: user.coverPhotoPath != null
                                    ? () => showDialog(
                                          context: mainNavKey.currentContext!,
                                          // isDismissible: false,
                                          // enableDrag: false,
                                          barrierDismissible: true,
                                          builder: (context) => ImagePreviewer(
                                            imageUrl: user.coverPhotoPath!,
                                            heroTag: "cover_photo",
                                            tightMode: true,
                                          ),
                                        )
                                    : null,
                                child: WidgetNetworkImage(
                                  image: user.coverPhotoPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 20,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: user.profilePhotoPath != null
                                            ? () => showMaterialModalBottomSheet(
                                                context: mainNavKey
                                                    .currentContext!,
                                                isDismissible: false,
                                                enableDrag: false,
                                                expand: false,
                                                builder: (context) =>
                                                    ImagePreviewer(
                                                        heroTag:
                                                            "profile_photo",
                                                        imageUrl: user
                                                            .profilePhotoPath!))
                                            : null,
                                        child: CircleImage(
                                          url: user.profilePhotoPath,
                                          withBaseUrl: false,
                                          radius: 70,
                                          borderWidth: 5,
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          right: -5,
                                          bottom: 7,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("Testing");
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoActionSheet(
                                                      title: const Text(
                                                        'Change Profile Picture',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8F8F8F),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            // Navigator.of(context).pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.camera,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   _onImageSelected(pickedFile);
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Take Photo',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.gallery,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   if (pickedFile != null) {
                                                            //     _onImageSelected(pickedFile);
                                                            //   }
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Photo Library',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .content_copy,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF007AFF),
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  AppColors.lightBlue,
                                              child: CircleAvatar(
                                                radius: 22,
                                                child: Icon(
                                                  Icons.photo_camera_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: AppColors.primaryColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                user.username,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: AppColors.primaryColor,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                user.role!.toUpperCase(),
                                                style: const TextStyle(
                                                    color: AppColors.textColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          user.biodata!,
                          style: const TextStyle(
                              fontSize: 16, color: AppColors.textColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const Text(
                        //       'See More About Yourself',
                        //       style: TextStyle(fontWeight: FontWeight.bold),
                        //     ),
                        //     TextButton(
                        //       onPressed: () async {
                        //         Navigator.of(context)
                        //             .pushNamed(profileEditPath);
                        //       },
                        //       child: const Text('Edit Details'),
                        //       style: TextButton.styleFrom(
                        //           backgroundColor: AppColors.lightBlue),
                        //     )
                        //   ],
                        // ),
                        const SizedBox(
                          height: 18,
                        ),
                        UserMetricsOverview(
                          user: user,
                        ),
                        const SizedBox(
                          height: 16,
                        ),


                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              BlocConsumer<ConnectsBloc, ConnectsState>(
                                bloc: _connectsBloc,
                                listener: (context, state) {
                                  listenToFOllowState(context, state);
                                },
                                buildWhen: (prevstate, currentState) {
                                  return currentState
                                  is FollowLoadingState ||
                                      currentState is FollowSuccesState ||
                                      currentState is FollowFailureState;
                                },
                                builder: (context, state) {
                                  return Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomButton(
                                            height: 50,
                                            child: state
                                            is FollowLoadingState
                                                ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                                : Row(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    AppIcons.svgFollowing,
                                                    color: Colors.white),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(isFollowing
                                                    ? 'Unfollow'
                                                    : 'Follow'),
                                              ],
                                            ),
                                            onTap: () {
                                              _connectsBloc.add(
                                                  FollowEvent(user_id: '15'));
                                            },
                                          ),
                                        ],
                                      ));
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),

                              //CONNECTS BUTTON

                              BlocConsumer<ConnectsBloc, ConnectsState>(
                                bloc: _connectsBloc,
                                listener: (context, state) {
                                  listenToConnectState(context, state);
                                },
                                buildWhen: (prevstate, currentState) {
                                  return currentState
                                  is SendRequestLoadingState ||
                                      currentState is SendRequestSuccesState ||
                                      currentState is SendRequestFailureState;
                                },
                                builder: (context, connectState) {
                                  return Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                    AppColors.lightBlue),
                                                onPressed: () {
                                                  _connectsBloc.add(
                                                      SendRequestEvent(
                                                          user.id.toString()));
                                                },
                                                child: connectState
                                                is SendRequestLoadingState
                                                    ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: Colors.blue,
                                                  ),
                                                )
                                                    : Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppIcons
                                                          .svgConnects,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(isConnected == 'Connected'
                                                        ? 'Disconnect' :
                                                        isConnected == 'Pending'?
                                                        'Cancel Request'
                                                        : 'Connect'),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ));
                                },
                              )
                            ],
                          ),
                        ),


                        const SizedBox(
                          height: 18,
                        ),


                        const Text(
                          'CONNECTS',
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        user.connections!.isNotEmpty
                            ? Container(
                                height: 120,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: user.connections?.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: SizedBox(
                                            width: 120,
                                            child: GestureDetector(
                                              // onTap: () {
                                              //   Navigator.of(context)
                                              //       .pushNamed(viewProfilePath, arguments: {
                                              //     "user_id": int.parse(user.connections![index]['id'].toString())
                                              //
                                              //   });
                                              // },
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                shadowColor:
                                                    AppColors.smokeWhite,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Colors.blueAccent,
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                            user.connections![
                                                                    index][
                                                                "profile_photo_path"],
                                                          ),
                                                          radius: 23,
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            '${user.connections![index]['firstname']} ${user.connections![index]['lastname']}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Text(
                                                            '${user.connections![index]['role']}',
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .blueGrey),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    user.connections!.length > 6
                                        ? TextButton(
                                            onPressed: () {},
                                            child: Text(
                                                '+${user.connections!.length - 6}'),
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.lightBlue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10)),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No Connections'),
                                ),
                              ),

                        const SizedBox(
                          height: 16,
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: const [
                        //     Text(
                        //       'BUSINESS/INVESTMENT',
                        //       style: TextStyle(
                        //           color: AppColors.primaryColor,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(
                        //       '+2 more',
                        //       style: TextStyle(
                        //           fontSize: 13,
                        //           color: AppColors.primaryColor,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // Container(
                        //   height: 80,
                        //   child: ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: 4,
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) => Container(
                        //       width: 110,
                        //       margin: const EdgeInsets.only(right: 2),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           image: const DecorationImage(
                        //               fit: BoxFit.cover,
                        //               image: NetworkImage(
                        //                 'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                        //               ))),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          if (state is ProfileErrorState) {
            return AppPromptWidget(
              title: "Unable to load profile",
              message: state.error,
              isSvgResource: true,
              onTap: () => _profileBloc.add(const FetchUserProfileEvent()),
            );
          }
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void listenToConnectState(BuildContext context, ConnectsState state) {


    if (state is SendRequestLoadingState) {}
    if (state is SendRequestSuccesState) {
      setState(() {
        isConnected = state.reactResponse.message!;
      });
      // reaction = state.reactResponse.message!;
      // acceptState = AcceptState.idle;
      // declineState = DeclineState.idle;
      AppUtils.showCustomToast(state.reactResponse.message!);

    }
    if (state is SendRequestFailureState) {
      // setState(() {
      AppUtils.showCustomToast(state.error);
      // acceptState = AcceptState.idle;
      // declineState = DeclineState.idle;
      // });
    }
  }
  void listenToFOllowState(BuildContext context, ConnectsState state) {
    if (state is FollowLoadingState) {}
    if (state is FollowSuccesState) {
      setState(() {
        isFollowing = !isFollowing;
      });
      // reaction = state.reactResponse.message!;
      // acceptState = AcceptState.idle;
      // declineState = DeclineState.idle;

      AppUtils.showCustomToast(state.reactResponse.message!);
    }
    if (state is FollowFailureState) {
      // setState(() {
      AppUtils.showCustomToast(state.error);
      // acceptState = AcceptState.idle;
      // declineState = DeclineState.idle;
      // });
    }


  }
}
