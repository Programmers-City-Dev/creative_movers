// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/repository/profile_repository.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/extension.dart';
import 'package:creative_movers/helpers/subscription_helper.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/profile/views/profile_screen.dart';
import 'package:creative_movers/screens/main/profile/views/user_connects_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/image_previewer.dart';
import 'package:creative_movers/screens/widget/widget_network_image.dart';
import 'package:creative_movers/services/dynamic_links_service.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key, this.userId}) : super(key: key);
  final int? userId;

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _profileBloc = injector.get<ProfileBloc>();
  final _profileBlockBloc = ProfileBloc(injector.get<ProfileRepository>());
  final _connectsBloc = ConnectsBloc();
  late bool isFollowing;

  late String isConnected;

  final _scrollController = ScrollController();

  final ValueNotifier<double> _avatarRadiusNotifier =
      ValueNotifier<double>(70.0);

  @override
  void initState() {
    super.initState();
    log(widget.userId.toString());
    widget.userId == null
        ? _profileBloc.add(const FetchUserProfileEvent())
        : _profileBloc.add(FetchUserProfileEvent(widget.userId));
    _scrollController.addListener(() {
      _avatarRadiusNotifier.value =
          (_scrollController.position.extentAfter * 0.5).clamp(0, 70);

      // log(_scrollController.position.pixels.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: BlocListener<ProfileBloc, ProfileState>(
        bloc: _profileBlockBloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            AppUtils.showAnimatedProgressDialog(context);
          }
          if (state is AccountBlocked) {
            Navigator.of(context)
              ..pop()
              ..pop();
            AppUtils.showCustomToast(state.message);
          }
          if (state is ProfileErrorState) {
            Navigator.of(context).pop();
            AppUtils.showCustomToast(state.error);
          }
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            listener: (ctx, state) {
              if (state is ProfileLoadedState) {
                User user = state.user;
                log('ISFOLLOWING ${user.isFollowing.toString()}');
                log('ISCONNECTED ${user.isConnected.toString()}');
                isFollowing = user.isFollowing!;
                isConnected = user.isConnected!;
              }
            },
            builder: (context, state) {
              if (state is ProfileLoadedState) {
                User user = state.user;
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        _profileBloc.add(FetchUserProfileEvent(widget.userId));
                      },
                      child: CustomScrollView(
                        controller: _scrollController,
                        clipBehavior: Clip.none,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 320,
                                  child: WidgetNetworkImage(
                                    image: user.coverPhotoPath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 250),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // width: double.infinity,
                                        // height: 120,
                                        // margin: const EdgeInsets.only(left: 16),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: GestureDetector(
                                                onTap: user.profilePhotoPath !=
                                                        null
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
                                                child: ValueListenableBuilder<
                                                        double>(
                                                    valueListenable:
                                                        _avatarRadiusNotifier,
                                                    builder: (context, value,
                                                        child) {
                                                      return Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 140,
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                CircleImage(
                                                                  url: user
                                                                      .profilePhotoPath,
                                                                  withBaseUrl:
                                                                      false,
                                                                  radius: value
                                                                      .clamp(40,
                                                                          70),
                                                                  borderWidth:
                                                                      5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 32),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 24 * 2,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          user.username,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      // mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          color: AppColors
                                                              .primaryColor,
                                                          size: 25,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          user.role!
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .textColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.biodata!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.textColor),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BlocConsumer<ConnectsBloc,
                                                      ConnectsState>(
                                                    bloc: _connectsBloc,
                                                    listener: (context, state) {
                                                      listenToFOllowState(
                                                          context, state);
                                                    },
                                                    buildWhen: (prevstate,
                                                        currentState) {
                                                      return currentState
                                                              is FollowLoadingState ||
                                                          currentState
                                                              is FollowSuccesState ||
                                                          currentState
                                                              is FollowFailureState;
                                                    },
                                                    builder: (context, state) {
                                                      return Expanded(
                                                          child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
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
                                                                      strokeWidth:
                                                                          2,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )
                                                                : Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SvgPicture.asset(
                                                                          AppIcons
                                                                              .svgFollowing,
                                                                          color:
                                                                              Colors.white),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(isFollowing
                                                                          ? 'Unfollow'
                                                                          : 'Follow'),
                                                                    ],
                                                                  ),
                                                            onTap: () {
                                                              _connectsBloc.add(
                                                                  const FollowEvent(
                                                                      userId:
                                                                          '15'));
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

                                                  SubscriptionHelper
                                                          .hasActiveSubscription()
                                                      ? BlocConsumer<
                                                          ConnectsBloc,
                                                          ConnectsState>(
                                                          bloc: _connectsBloc,
                                                          listener:
                                                              (context, state) {
                                                            listenToConnectState(
                                                                context, state);
                                                          },
                                                          buildWhen: (prevstate,
                                                              currentState) {
                                                            return currentState
                                                                    is ConnectToUserLoadingState ||
                                                                currentState
                                                                    is ConnectToUserSuccesState ||
                                                                currentState
                                                                    is ConnectToUserFailureState;
                                                          },
                                                          builder: (context,
                                                              connectState) {
                                                            return Expanded(
                                                                child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                SizedBox(

                                                                  height: 50,
                                                                  child: TextButton(
                                                                      style: TextButton.styleFrom(backgroundColor: AppColors.lightBlue),
                                                                      onPressed: () {
                                                                        _connectsBloc.add(ConnectToUserEvent(user
                                                                            .id
                                                                            .toString()));
                                                                      },
                                                                      child: connectState is ConnectToUserLoadingState
                                                                          ? const SizedBox(
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: CircularProgressIndicator.adaptive(),
                                                                            )
                                                                          : Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  AppIcons.svgConnects,
                                                                                  color: AppColors.primaryColor,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(isConnected == 'Connected'
                                                                                    ? 'Disconnect'
                                                                                    : isConnected == 'Pending'
                                                                                        ? 'Cancel Request'
                                                                                        : 'Connect'),
                                                                              ],
                                                                            )),
                                                                ),
                                                              ],
                                                            ));
                                                          },
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 16,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'CONNECTS',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Visibility(
                                                  visible:
                                                      user.connections!.length >
                                                          5,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserConnectsScreen(
                                                            user_id: user.id
                                                                .toString(),
                                                          ),
                                                        ));
                                                      },
                                                      child: const Text(
                                                          "View All",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .primaryColor))),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            user.connections!.isNotEmpty
                                                ? SizedBox(
                                                    height: 120,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount: user
                                                                        .connections!
                                                                        .length >
                                                                    5
                                                                ? user
                                                                    .connections
                                                                    ?.getRange(
                                                                        0, 5)
                                                                    .length
                                                                : user
                                                                    .connections!
                                                                    .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 8),
                                                              child: SizedBox(
                                                                width: 120,
                                                                child:
                                                                    GestureDetector(
                                                                  child: Card(

                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6)),
                                                                    shadowColor:
                                                                        AppColors
                                                                            .smokeWhite,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                25,
                                                                            backgroundColor:
                                                                                Colors.blueAccent,
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundImage: NetworkImage(
                                                                                user.connections![index]["profile_photo_path"],
                                                                              ),
                                                                              radius: 23,
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: Text(
                                                                                '${user.connections![index]['firstname']} ${user.connections![index]['lastname']}',
                                                                                style: const TextStyle(fontSize: 11),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          Center(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                '${user.connections![index]['role']}',
                                                                                style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                      onTap: () {
                                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                          builder: (context) => ViewProfileScreen(
                                                                            userId: user.connections![index]['id'],
                                                                          ),
                                                                        ));
                                                                      },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // user.connections!.length > 6
                                                        //     ? TextButton(
                                                        //         onPressed: () {},
                                                        //         child: Text(
                                                        //             '+${user.connections!.length - 6}'),
                                                        //         style: TextButton.styleFrom(
                                                        //             backgroundColor:
                                                        //                 AppColors.lightBlue,
                                                        //             padding:
                                                        //                 const EdgeInsets.symmetric(
                                                        //                     vertical: 10)),
                                                        //       )
                                                        //     : const SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  )
                                                : const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                          'No Connections'),
                                                    ),
                                                  ),

                                            const SizedBox(
                                              height: 300,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<double>(
                        valueListenable: _avatarRadiusNotifier,
                        builder: (context, value, child) {
                          return AnimatedContainer(
                            padding: const EdgeInsets.fromLTRB(
                                16, kTextTabBarHeight, 16, 16),
                            // height: kToolbarHeight,
                            duration: const Duration(milliseconds: 200),
                            color: value <= kTextTabBarHeight
                                ? Colors.white
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        child: Icon(
                                          Platform.isAndroid
                                              ? Icons.arrow_back
                                              : Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: value <= kTextTabBarHeight - 32,
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.username,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                user.role!.toFirstUppercase,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Container(
                                    //   padding: const EdgeInsets.all(8),
                                    //   decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: Colors.black.withOpacity(0.5)),
                                    //   child: Icon(
                                    //     Platform.isAndroid
                                    //         ? Icons.arrow_back
                                    //         : Icons.arrow_back_ios,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    PopupMenuButton(
                                      onSelected: (val) {
                                        if (val == 1) {
                                          _shareUserProfile(user);
                                        }
                                        if (val == 2) {
                                          _showBlockUserPrompt(user);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text('Share Profile'),
                                        ),
                                        const PopupMenuItem(
                                          value: 2,
                                          child: Text('Block User'),
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        child: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ],
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
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return const SizedBox.shrink();
            }),
      ),
    );
  }

  void listenToConnectState(BuildContext context, ConnectsState state) {
    if (state is ConnectToUserLoadingState) {}
    if (state is ConnectToUserSuccesState) {
      setState(() {
        isConnected = state.reactResponse.message!;
      });
      // reaction = state.reactResponse.message!;
      // acceptState = AcceptState.idle;
      // declineState = DeclineState.idle;
      AppUtils.showCustomToast(state.reactResponse.message!);
    }
    if (state is ConnectToUserFailureState) {
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

  void _showBlockUserPrompt(User user) {
    AppUtils.showConfirmDialog(
      context,
      title: "Block User",
      message:
          "Are you sure you want to block ${user.firstname} ${user.lastname}?"
          "\n\n"
          "Note: You will no longer be connected or recieve updates "
          "from this person.",
      useRootNavigator: true,
      cancelButtonText: "Cancel",
      confirmButtonText: "Block",
    ).then((value) {
      if (value) {
        _profileBlockBloc.add(BlockAccount(userId: user.id));
      }
    });
  }

  void _shareUserProfile(User user) {
    DynamicLinksService.createProfileDeepLink(user).then((link) {
      Share.share("Hello there!\nView my profile on @CreativeMovers by "
          "clicking on the link below:\n"
          "$link");
    });
  }
}
