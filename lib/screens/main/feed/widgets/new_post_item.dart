
import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'dart:ui';

import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/buisness_page/views/view_buisness_page_screen.dart';
import 'package:creative_movers/screens/main/feed/views/comments_screen.dart';
import 'package:creative_movers/screens/main/feed/widgets/edit_post_form.dart';
import 'package:creative_movers/screens/main/feed/widgets/media_display_item.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/link_preview.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_stack/image_stack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class NewPostItem extends StatefulWidget {
  const NewPostItem({
    Key? key,
    required this.feed,
    this.onCommentBoxClicked,
    required this.onUpdated,
  }) : super(key: key);
  final Feed feed;
  final VoidCallback? onCommentBoxClicked;
  final VoidCallback onUpdated;

  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  bool liked = false;
  FeedBloc feedBloc = FeedBloc();
  final FeedBloc _likeFeedBloc = FeedBloc();
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
                        ? widget.feed.user!.profilePhotoPath!
                        : widget.feed.page!.photoPath != null
                            ? widget.feed.page!.photoPath!
                            : 'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg',
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
              BlocBuilder<CacheCubit, CacheState>(
                bloc: injector.get<CacheCubit>()..fetchCachedUserData(),
                builder: (context, state) {
                  if (state is CachedUserDataFetched) {
                    user = state.cachedUser;
                  }
                  if (state is CachedUserDataFetched &&
                      state.cachedUser.id.toString() == widget.feed.userId) {
                    return BlocListener<FeedBloc, FeedState>(
                      bloc: feedBloc,
                      listener: (context, state) {
                        if (state is DeleteFeedLoadingState) {
                          AppUtils.showAnimatedProgressDialog(context,
                              title: "Deleting Post, please wait...");
                        }
                        if (state is DeleteFeedSuccessState) {
                          widget.onUpdated();
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
                      child: PopupMenuButton<String>(
                        onSelected: (val) {
                          if (val == 'Edit') {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: EditPostForm(
                                      feed: widget.feed,
                                      onSucces: () {
                                        widget.onUpdated();
                                        Navigator.pop(context);
                                      },
                                    ));
                              },
                              shape: const RoundedRectangleBorder(),
                              // clipBehavior: Clip.antiAliasWithSaveLayer,
                            );
                          } else {
                            feedBloc.add(DeleteFeedEvent(
                                feed_id: widget.feed.id.toString()));
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              padding: const EdgeInsets.all(10),
                              onTap: () {
                                // showMaterialModalBottomSheet(
                                //   context: context,
                                //   builder: (context) {
                                //     return BackdropFilter(
                                //         filter: ImageFilter.blur(
                                //             sigmaX: 5, sigmaY: 5),
                                //         child: EditGenderDialog(
                                //           onSuccess: () {
                                //             Navigator.pop(context);
                                //           },
                                //         ));
                                //   },
                                //   shape: const RoundedRectangleBorder(),
                                //   // clipBehavior: Clip.antiAliasWithSaveLayer,
                                // );
                              },
                              value: 'Edit',
                              child: Container(
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit_rounded),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Edit'),
                                  ],
                                ),
                              )),
                          PopupMenuItem<String>(
                              padding: const EdgeInsets.all(10),
                              value: 'Delete',
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: const [
                                    Icon(Icons.delete_rounded),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Delete'),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
                  } else {
                    Container(
                      color: Colors.green,
                      height: 55,
                      width: 55,
                    );
                  }

                  return const SizedBox();
                },
              )
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
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
                    height: 300,
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
              widget.feed.likes.length < 2
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
                        widget.feed.likes.elementAt(0).user.profilePhotoPath!,
                        widget.feed.likes.elementAt(1).user.profilePhotoPath!,
                      ],
                      totalCount: widget.feed.likes.length,
                      // If larger than images.length, will show extra empty circle
                      imageRadius: 25,
                      // Radius of each images
                      imageCount: 2,
                      // Maximum number of images to be shown in stack
                      imageBorderWidth: 0, // Border width around the images
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
                const SizedBox(width: 20,),// Temporary sized box
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
                  child: Row(
                    children: const [
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
}

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final bool isOk;
  final VoidCallback onTap;
  const LikeButton(
      {Key? key,
      required this.isLiked,
      required this.onTap,
      required this.isOk})
      : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool liked;

  @override
  void initState() {
    super.initState();
    liked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    // log("LIKED: ${widget.isLiked}");
    return InkWell(
      onTap: () {
        setState(() {
          // liked = !liked;
          widget.onTap();
        });
      },
      child: Container(
          child: !(liked && widget.isOk)
              ? const Icon(
                  Icons.thumb_up_outlined,
                  color: AppColors.textColor,
                )
              : const Icon(
                  Icons.thumb_up_outlined,
                  color: AppColors.primaryColor,
                )),
    );
  }
}
