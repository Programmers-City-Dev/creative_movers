import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:creative_movers/data/remote/model/media.dart';
import 'package:creative_movers/screens/main/feed/views/comments_screen.dart';
import 'package:creative_movers/screens/main/feed/widgets/media_display_item.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_stack/image_stack.dart';
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
      decoration: const BoxDecoration(color: Colors.white),
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
                      backgroundImage:
                          NetworkImage(widget.feed.user.profilePhotoPath!),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.feed.user.firstname} ${widget.feed.user.lastname}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '12 mins ago',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                      value: 'Notification',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.notifications_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Notification'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: EdgeInsets.all(10),
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
                  PopupMenuItem<String>(
                      padding: const EdgeInsets.all(10),
                      value: 'Copy Link',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.content_copy_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Copy Link'),
                          ],
                        ),
                      )),
                  PopupMenuItem<String>(
                      padding: const EdgeInsets.all(10),
                      value: 'Share',
                      child: Container(
                        child: Row(
                          children: const [
                            Icon(Icons.share_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Share'),
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 12),
              child: ReadMoreText(
                widget.feed.content!,
                style: const TextStyle(color: AppColors.textColor),
                trimLines: 2,
                textAlign: TextAlign.start,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Stack(children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: PageController(keepPage: true, initialPage: 0),
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
                  itemCount: mediaList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      MediaDisplayItem(media: mediaList[index]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                        backgroundColor: Colors.black.withOpacity(0.8),
                        padding: EdgeInsets.zero,
                        label: Text(
                          '${pageIndex + 1}/${mediaList.length} ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.smokeWhite,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              )
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          mediaList.length > 1
              ? Center(
                  child: SizedBox(
                    height: 8,
                    width: 58,
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: mediaList.length,
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
              : SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageStack(
                imageList: images,
                totalCount: images.length,
                // If larger than images.length, will show extra empty circle
                imageRadius: 25,
                // Radius of each images
                imageCount: 3,
                // Maximum number of images to be shown in stack
                imageBorderWidth: 0, // Border width around the images
              ),
              const Text('1,000 commented'),
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
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.thumbsUp,
                        color: AppColors.textColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Like',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(),
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
}
