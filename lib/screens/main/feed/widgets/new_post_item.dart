import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:creative_movers/data/remote/model/media.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/buisness_page/views/view_buisness_page_screen.dart';
import 'package:creative_movers/screens/main/feed/views/comments_screen.dart';
import 'package:creative_movers/screens/main/feed/widgets/media_display_item.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NewPostItem extends StatefulWidget {
  const NewPostItem({
    Key? key,
    required this.feed,
  }) : super(key: key);
  final Feed feed;

  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  bool liked = false;
  FeedBloc feedBloc = FeedBloc();
  CachedUser? user = null;

  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];
  List<MediaModel> mediaList = [
    MediaModel(type: 'image'),
    MediaModel(type: 'video'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image'),
    MediaModel(type: 'image')
  ];
  int pageIndex = 0;

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
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.feed.type == 'user_feed'
                          ? NetworkImage(widget.feed.user!.profilePhotoPath!)
                          : widget.feed.page!.photoPath != null
                          ? NetworkImage(widget.feed.page!.photoPath!)
                          : const NetworkImage(
                          'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    widget.feed.type == 'user_feed'
                        ? InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(
                            viewProfilePath, arguments: {"user_id": int.parse(
                            widget.feed.userId)}
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.feed.user?.firstname} ${widget.feed.user
                                ?.lastname}',

                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppUtils.getTime(widget.feed.updatedAt),
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    )
                        : InkWell(
                      onTap: () {
                        
                        widget.feed.userId != user?.id.toString() ?
                        Navigator.of(context).push(MaterialPageRoute(builder: (
                            context) =>
                            ViewBuisnessPageScreen(
                                page_id: widget.feed.page!.id.toString()),))
                        : Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MyPageTab(),
                        )
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(

                                '  ${widget.feed.page!.name} ',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 12.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text('🅿️')
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                ' Posetd by ${widget.feed.user?.firstname} ',
                                maxLines: 1,
                                style: const TextStyle(fontSize: 10,),
                              ),
                              Text(
                                AppUtils.getTime(widget.feed.updatedAt),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<CacheCubit, CacheState>(
                bloc: injector.get<CacheCubit>()
                  ..fetchCachedUserData(),
                builder: (context, state) {
                  if (state is CachedUserDataFetched) {
                    user = state.cachedUser;
                  }
                  if (state is CachedUserDataFetched &&
                      state.cachedUser.id.toString() == widget.feed.userId) {
                    return PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                            padding: const EdgeInsets.all(10),
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
                            padding: EdgeInsets.all(10),
                            value: 'Delete',
                            child: Container(
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
                    );
                  } else {
                    Container(color: Colors.green, height: 55, width: 55,);
                  }

                  return SizedBox();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 12),
              child: ReadMoreText(
                widget.feed.content!,
                textAlign: TextAlign.start,
                style: const TextStyle(color: AppColors.textColor),
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          widget.feed.media.isNotEmpty
              ? Container(
            child: Stack(children: [
              Container(
                height: 300,
                child: PageView.builder(
                  controller:
                  PageController(keepPage: true, initialPage: 0),
                  pageSnapping: true,
                  onPageChanged: (currentindex) {
                    setState(() {
                      pageIndex = currentindex;
                      itemScrollController.scrollTo(
                          index: pageIndex,
                          duration: Duration(seconds: 2),
                          curve: Curves.easeInOutCubic);
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.feed.media.length,
                  physics: BouncingScrollPhysics(),
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
                          '${pageIndex + 1}/${mediaList.length} ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.smokeWhite,
                              fontWeight: FontWeight.w600),
                        )),
                  )
                      : SizedBox(),
                ],
              )
            ]),
          )
              : SizedBox(),
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
                itemBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: DotIndicator(
                        isActive: pageIndex == index,
                      ),
                    ),
              ),
            ),
          )
              : SizedBox(),
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
              Text(
                '${widget.feed.comments.length} commented',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Divider(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            liked = !liked;
                            feedBloc.add(
                                LikeEvent(feed_id: widget.feed.id.toString()));
                          });
                        },
                        child: Container(
                            child: !liked
                                ? const FaIcon(
                              FontAwesomeIcons.thumbsUp,
                              color: AppColors.textColor,
                            )
                                : const FaIcon(
                              FontAwesomeIcons.solidThumbsUp,
                              color: AppColors.primaryColor,
                            )),
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
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(
                            feed: widget.feed,
                          ),
                    ));
                  },
                  child: Container(
                    child: Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.comment,
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
                ),
                Container(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.share_rounded,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
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
