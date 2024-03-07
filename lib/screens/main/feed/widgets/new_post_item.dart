import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/buisness_page/views/view_buisness_page_screen.dart';
import 'package:creative_movers/screens/main/feed/views/comments_screen.dart';
import 'package:creative_movers/screens/main/feed/widgets/edit_post_form.dart';
import 'package:creative_movers/screens/main/feed/widgets/like_button.dart';
import 'package:creative_movers/screens/main/feed/widgets/likers_sheet.dart';
import 'package:creative_movers/screens/main/feed/widgets/media_display_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/report_feed_widget.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/screens/widget/adaptive_bottomsheet_menu.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/link_preview.dart';
import 'package:creative_movers/services/dynamic_links_service.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_stack/image_stack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class NewPostItem extends StatefulWidget {
  const NewPostItem({
    Key? key,
    required this.feed,
    this.onCommentBoxClicked,
    required this.onUpdated,
    this.onDeleted,
  }) : super(key: key);
  final Feed feed;
  final VoidCallback? onCommentBoxClicked;
  final VoidCallback onUpdated;
  final Function(Feed feed)? onDeleted;

  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  bool liked = false;
  FeedBloc feedBloc = FeedBloc(injector.get());
  final FeedBloc _likeFeedBloc = FeedBloc(injector.get());
  final ConnectsBloc _connectsBloc = ConnectsBloc();
  CachedUser? user;

  late final ValueNotifier<Feed> _feedNotifier;

  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _feedNotifier = ValueNotifier(widget.feed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: AppColors.white),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleImage(
                    radius: 20,
                    withBaseUrl: false,
                    url: widget.feed.type == 'user_feed'
                        ? widget.feed.user?.profilePhotoPath!
                        : widget.feed.page?.photoPath,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  widget.feed.type == 'user_feed'
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(viewProfilePath,
                                arguments: {
                                  "user_id": int.parse(widget.feed.userId)
                                });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.feed.user?.firstname} ${widget.feed.user?.lastname}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                AppUtils.getTimeAgo(widget.feed.updatedAt),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            widget.feed.userId != user?.id.toString()
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ViewBuisnessPageScreen(
                                            pageId: widget.feed.page!.id
                                                .toString()),
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MyPageTab(),
                                  ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '  ${widget.feed.user?.firstname} ${widget.feed.user?.lastname} ',
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle:
                                        const StrutStyle(fontSize: 12.0),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // const Text()
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '🅿️ ${widget.feed.page?.name} ',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    AppUtils.getTimeAgo(widget.feed.updatedAt),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              MultiBlocListener(
                listeners: [
                  BlocListener(
                    bloc: feedBloc,
                    listener: (context, state) {
                      if (state is DeleteFeedLoadingState) {
                        AppUtils.showAnimatedProgressDialog(context,
                            title: "Deleting Post, please wait...");
                      }
                      if (state is DeleteFeedSuccessState) {
                        widget.onUpdated();
                        widget.onDeleted?.call(widget.feed);
                        Navigator.of(context).pop();
                        // AppUtils.cancelAllShowingToasts();
                        AppUtils.showCustomToast(
                            "Post has been Deleted successfully");
                      }
                      if (state is DeleteFeedFaliureState) {
                        Navigator.of(context).pop();
                        AppUtils.showCustomToast(state.error);
                      }
                    },
                  ),
                  BlocListener<ConnectsBloc, ConnectsState>(
                      bloc: _connectsBloc,
                      listener: ((context, state) {
                        _listenToAccountTypeState(context, state);
                      }))
                ],
                child: IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    _showFeedOptionsSheet(context, widget.feed);
                  },
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: AnimatedSize(
          //     duration: const Duration(milliseconds: 12),
          //     child: ReadMoreText(
          //       widget.feed.content!,
          //       textAlign: TextAlign.start,
          //       style: const TextStyle(color: AppColors.textColor),
          //       trimLines: 2,
          //       trimMode: TrimMode.Line,
          //       trimCollapsedText: 'Show more',
          //       trimExpandedText: 'Show less',
          //       moreStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: ExpandableText(
              widget.feed.content!,
              expandText: 'show more',
              collapseText: "show less",
              maxLines: 6,
              linkColor: Colors.blue,
              animation: true,
              collapseOnTextTap: true,
              // prefixText: 'username',
              onPrefixTap: () {
                // showProfile(username);
              },
              prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
              onHashtagTap: (name) {
                // showHashtag(name);
              },
              expandOnTextTap: true,
              hashtagStyle: const TextStyle(
                color: Color(0xFF30B6F9),
              ),
              onMentionTap: (username) {
                // showProfile(username);
              },
              mentionStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              onUrlTap: (url) {
                AppUtils.launchInAppBrowser(context, url);
              },
              urlStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor),
            ),
          ),
          if (widget.feed.media.isEmpty)
            LinkPreview(
              text: widget.feed.content!,
            ),
          const SizedBox(
            height: 8.0,
          ),
          widget.feed.media.isNotEmpty
              ? Stack(children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller:
                          PageController(keepPage: true, initialPage: 0),
                      pageSnapping: true,
                      onPageChanged: (currentIndex) {
                        setState(() {
                          pageIndex = currentIndex;
                          itemScrollController.scrollTo(
                              index: pageIndex,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOutCubic);
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.feed.media.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          MediaDisplayItem(media: widget.feed.media[index]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.feed.media.length > 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                  backgroundColor:
                                      AppColors.black.withOpacity(0.8),
                                  padding: EdgeInsets.zero,
                                  label: Text(
                                    '${pageIndex + 1}/${widget.feed.media.length} ',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.smokeWhite,
                                        fontWeight: FontWeight.w600),
                                  )),
                            )
                          : const SizedBox(),
                    ],
                  )
                ])
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          widget.feed.media.length > 2
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 8,
                    width: 58,
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.feed.media.length,
                      itemScrollController: itemScrollController,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: DotIndicator(
                          isActive: pageIndex == index,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _showLikersSheet(
                      context, widget.feed.likes.map((e) => e.user).toList());
                },
                child: Container(
                  child: widget.feed.likes.length < 2
                      ? ImageStack(
                          imageList: widget.feed.likes
                              .map((e) => e.user.profilePhotoPath!)
                              .toList(),
                          totalCount: widget.feed.likes.length,
                          // If larger than images.length, will show extra empty circle
                          imageRadius: 25,
                          // Radius of each images
                          imageCount: widget.feed.likes.length,
                          // Maximum number of images to be shown in stack
                          imageBorderWidth: 0, // Border width around the images
                        )
                      : ImageStack(
                          imageList: [
                            widget.feed.likes
                                .elementAt(0)
                                .user
                                .profilePhotoPath!,
                            widget.feed.likes
                                .elementAt(1)
                                .user
                                .profilePhotoPath!,
                          ],
                          totalCount: widget.feed.likes.length,
                          // If larger than images.length, will show extra empty circle
                          imageRadius: 25,
                          // Radius of each images
                          imageCount: 2,
                          // Maximum number of images to be shown in stack
                          imageBorderWidth: 0, // Border width around the images
                        ),
                ),
              ),
              Text(
                '${widget.feed.comments.length} commented',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Divider(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    BlocConsumer<FeedBloc, FeedState>(
                      bloc: _likeFeedBloc,
                      listener: (_, state) {
                        if (state is LikeSuccessState) {
                          widget.feed.liked = !widget.feed.liked;
                        }
                        if (state is LikeFaliureState) {
                          AppUtils.showCustomToast("Unable to send like");
                        }
                        // log("STATE: $state\n VALUE: ${widget.feed.liked}");
                      },
                      builder: (context, feedState) {
                        // log("STATE: $feedState\n VALUE: ${widget.feed.liked}");
                        if (feedState is LikeSuccessState) {
                          // log("STATE: $feedState\n VALUE: ${widget.feed.liked}");
                          return LikeButton(
                              isLiked: widget.feed.liked,
                              isOk: true,
                              onTap: () {
                                _likeFeedBloc.add(LikeEvent(
                                    feeId: widget.feed.id.toString()));
                              });
                        }
                        if (feedState is LikeLoadingState) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )),
                          );
                        }
                        if (feedState is LikeFaliureState) {
                          return LikeButton(
                              isLiked: widget.feed.liked,
                              isOk: false,
                              onTap: () {
                                _likeFeedBloc.add(LikeEvent(
                                    feeId: widget.feed.id.toString()));
                              });
                        }
                        return LikeButton(
                            isLiked: widget.feed.liked,
                            isOk: true,
                            onTap: () {
                              _likeFeedBloc.add(
                                  LikeEvent(feeId: widget.feed.id.toString()));
                            });
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'Like',
                      style: TextStyle(fontSize: 13),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ), // Temporary sized box
                InkWell(
                  onTap: () {
                    if (widget.onCommentBoxClicked != null) {
                      widget.onCommentBoxClicked!();
                    } else {
                      Navigator.of(mainNavKey.currentState!.context)
                          .push(MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          feed: widget.feed,
                        ),
                      ));
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Comment',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                // Row(
                //   children: const [
                //     Icon(
                //       Icons.share_rounded,
                //       color: AppColors.textColor,
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Text(
                //       'Share',
                //       style: TextStyle(fontSize: 13),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _showFeedOptionsSheet(BuildContext context, Feed feed) {
    final ProfileBloc profileBloc = ProfileBloc(injector.get())
      ..add(FetchUserProfileEvent(feed.user?.id));
    return showBarModalBottomSheet(
        context: context,
        expand: false,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return SafeArea(
            child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: profileBloc,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }
                  if (state is ProfileErrorState) {
                    return Center(
                        child: AppPromptWidget(
                      title: "Unable to fetch user profile",
                      message: "Please try again later",
                      onTap: () =>
                          profileBloc.add(FetchUserProfileEvent(feed.user?.id)),
                    ));
                  }
                  if (state is ProfileLoadedState) {
                    String connectionStatus =
                        (state.user.isConnected ?? '').toLowerCase();
                    return injector
                                .get<CacheCubit>()
                                .cachedUser!
                                .id
                                .toString() !=
                            widget.feed.userId
                        ? BottomSheetMenuList(
                            onSelect: (index) {
                              if (index == 0) {
                                _shareFeed(widget.feed);
                              }
                              if (index == 1) {
                                _showConnectionPromptDialog(
                                    context, widget.feed, connectionStatus);
                              }
                              if (index == 2) {
                                _showReportDialog(context, widget.feed);
                              }
                            },
                            items: [
                                // const BottomSheetMenu(
                                //     title: "Save",
                                //     icon: Icon(Icons.bookmark_add)),
                                const BottomSheetMenu(
                                    title: "Share via",
                                    icon: Icon(Icons.share)),
                                BottomSheetMenu(
                                    title: connectionStatus == "connected"
                                        ? "Remove connection with ${widget.feed.user?.fullname}"
                                        : connectionStatus == "pending"
                                            ? "Cancel connection request"
                                            : "Connect with ${widget.feed.user?.fullname}",
                                    icon: Icon(connectionStatus == "connected"
                                        ? Icons.cancel_rounded
                                        : connectionStatus == "pending"
                                            ? Icons.person_remove_outlined
                                            : Icons.connect_without_contact)),
                                const BottomSheetMenu(
                                    title: "Report feed",
                                    icon: Icon(Icons.report)),
                              ])
                        : BottomSheetMenuList(
                            onSelect: (index) {
                              if (index == 0) {
                                _shareFeed(widget.feed);
                              }
                              if (index == 1) {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return EditPostForm(
                                      feed: widget.feed,
                                      onSucces: () {
                                        widget.onUpdated();
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  shape: const RoundedRectangleBorder(),
                                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                                );
                              } else if (index == 2) {
                                _showDeletedFeedPrompt();
                              }
                            },
                            items: const [
                                BottomSheetMenu(
                                    title: "Share via",
                                    icon: Icon(Icons.share)),
                                BottomSheetMenu(
                                    title: "Edit feed", icon: Icon(Icons.edit)),
                                BottomSheetMenu(
                                    title: "Delete this feed",
                                    icon: Icon(Icons.delete)),
                              ]);
                  }
                  return const SizedBox.shrink();
                }),
          );
        });
  }

  Future<dynamic> _showLikersSheet(BuildContext context, List<Poster> posters) {
    return showBarModalBottomSheet(
        context: context,
        expand: false,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return SafeArea(
            child: LikersSheet(likers: posters),
          );
        });
  }

  void _showDeletedFeedPrompt() {
    AppUtils.showConfirmDialog(
      context,
      title: "Delete Feed",
      message: "Are you sure you want to delete this feed?",
      useRootNavigator: true,
      cancelButtonText: "Cancel",
      confirmButtonText: "Delete",
    ).then((value) {
      if (value) {
        feedBloc.add(DeleteFeedEvent(feedId: widget.feed.id.toString()));
      }
    });
  }

  void _listenToAccountTypeState(BuildContext context, ConnectsState state) {
    if (state is ConnectToUserLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }
    if (state is ConnectToUserSuccesState) {
      Navigator.pop(context);
      AppUtils.showCustomToast(state.reactResponse.message!);
    }
    if (state is ConnectToUserFailureState) {
      Navigator.pop(context);
      AppUtils.showCustomToast(state.error);
    }

    if (state is AddConnectionFailureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context,
          message: "Unable to complete request, please try again");
    }
  }

  String getTime(DateTime dateTime) {
    // DateTime dateTime = DateTime.parse(date);
    Duration duration = DateTime.now().difference(dateTime);
    double months = duration.inDays / 28;
    double years = months / 12;

    if (duration.inMinutes < 1) {
      return ' ${duration.inSeconds.toString()}secs agp';
    } else if (duration.inHours < 1) {
      return ' ${duration.inMinutes.toString()}Mins agp';
    } else if (duration.inDays < 1) {
      return '${duration.inHours.toString()}Hrs ago';
    } else if (months < 1) {
      if (duration.inDays > 1) {
        return '${duration.inDays.toString()}Days ago';
      } else {
        return '${duration.inDays.toString()}Day ago';
      }
    } else if (years < 1) {
      return '${months.toString()}Months';
    } else {
      return '${years.toString()}Years';
    }
  }

  Future<bool> isMyPost() async {
    String? userId = await AppUtils.getUserId();
    return userId == widget.feed.userId.toString();
  }

  void _showReportDialog(BuildContext context, Feed feed) {
    showMaterialModalBottomSheet(
        context: context,
        builder: ((context) {
          return ReportFeedWidget(feed: feed);
        }));
  }

  void _showConnectionPromptDialog(
      BuildContext context, Feed feed, String connectionStatus) {
    AppUtils.showConfirmDialog(
      context,
      title: connectionStatus == "connected"
          ? "Remove Connection"
          : connectionStatus == "pending"
              ? "Cancel Request"
              : "Add Connection",
      message: connectionStatus == "connected"
          ? "Are you sure you want to remove this connection?"
          : connectionStatus == "pending"
              ? "Are you sure you want to cancel your connection request"
                  " with ${feed.user?.fullname}?"
              : "Are you sure you want to add ${feed.user?.fullname} "
                  "to your connections?",
      useRootNavigator: true,
      cancelButtonText: "Cancel",
      confirmButtonText: connectionStatus == "connected"
          ? "Remove"
          : connectionStatus == "pending"
              ? "Continue"
              : "Connect",
    ).then((value) {
      if (value) {
        _connectsBloc.add(ConnectToUserEvent(feed.userId));
        Navigator.pop(context);
      }
    });
  }

  void _shareFeed(Feed feed) {
    DynamicLinksService.createFeedDeepLink(feed).then((link) {
      Share.share("Hello Chief, ${feed.user?.fullname} just shared a post on"
          " CreativeMovers platform. You can click on the link below"
          " to read more.\n\n$link");
    });
  }
}
