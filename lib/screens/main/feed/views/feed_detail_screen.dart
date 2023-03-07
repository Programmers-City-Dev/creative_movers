import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/feed/widgets/feed_loader.dart';
import 'package:creative_movers/screens/main/feed/widgets/new_post_item.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FeedBloc _feedBloc = FeedBloc(injector.get());
final _focusNode = FocusNode();

class FeedDetailsScreen extends StatefulWidget {
  final int feedId;

  const FeedDetailsScreen({Key? key, required this.feedId}) : super(key: key);

  @override
  State<FeedDetailsScreen> createState() => _FeedDetailsScreenState();
}

class _FeedDetailsScreenState extends State<FeedDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _feedBloc.add(FetchFeedItemEvent(widget.feedId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        titleTextStyle:
            const TextStyle(color: AppColors.textColor, fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textColor),
        backgroundColor: AppColors.white,
        title: const Text('Feed'),
        centerTitle: true,
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
          bloc: _feedBloc,
          builder: (context, state) {
            if (state is FeedLoading) {
              return const FeedLoader();
            }
            if (state is FeedItemLoadedState) {
              return FeedDetailsWidget(feed: state.feed);
            }
            if (state is FeedFaliureState) {
              return AppPromptWidget(
                message: state.error,
                onTap: () {
                  _feedBloc.add(FetchFeedItemEvent(widget.feedId));
                },
              );
            }
            return Container();
          }),
    );
  }
}

class FeedDetailsWidget extends StatefulWidget {
  final Feed feed;

  const FeedDetailsWidget({
    Key? key,
    required this.feed,
  }) : super(key: key);

  @override
  State<FeedDetailsWidget> createState() => _FeedDetailsWidgetState();
}

class _FeedDetailsWidgetState extends State<FeedDetailsWidget> {
  final _commentScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RefreshIndicator(
              onRefresh: () async {
                _feedBloc.add(FetchFeedItemEvent(widget.feed.id));
              },
              child: SingleChildScrollView(
                controller: _commentScrollController,
                child: Column(
                  children: [
                    NewPostItem(
                      feed: widget.feed,
                      onCommentBoxClicked: () {
                        _focusNode.unfocus();
                        _focusNode.requestFocus();
                      },
                      onUpdated: () {},
                    ),
                    widget.feed.comments.isEmpty
                        ? const Center(child: Text('No Comments'))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.feed.comments.length,
                            itemBuilder: (context, index) => CommentItemWidget(
                              comment: widget.feed.comments[index],
                              onCommentSent: () {
                                widget.feed.comments[index].shouldLoad = false;
                              },
                              feedId: '${widget.feed.id}',
                              shouldLoad:
                                  widget.feed.comments[index].shouldLoad,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<CacheCubit, CacheState>(
          bloc: CacheCubit()..fetchCachedUserData(),
          buildWhen: (_, state) => state is CachedUserDataFetched,
          builder: (context, state) {
            if (state is CachedUserDataFetched) {
              var user = state.cachedUser;
              return CommentBox(
                profilePhotoPath: user.profilePhotoPath,
                onCommentSent: (text) {
                  widget.feed.comments.add(Comment(
                      id: 4,
                      userId: widget.feed.userId,
                      comment: text,
                      feedId: ' ${widget.feed.id}',
                      user: Poster(
                          id: int.parse(widget.feed.userId),
                          firstname: widget.feed.user!.firstname,
                          lastname: widget.feed.user!.lastname,
                          profilePhotoPath: widget.feed.user!.profilePhotoPath),
                      shouldLoad: true));
                  _commentScrollController.animateTo(
                    _commentScrollController.position.maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                  setState(() {});
                },
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}

class CommentBox extends StatefulWidget {
  final bool? focused;
  final String? profilePhotoPath;
  final Function(String) onCommentSent;

  const CommentBox(
      {Key? key,
      this.profilePhotoPath,
      required this.onCommentSent,
      this.focused = false})
      : super(key: key);

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final _commentController = TextEditingController();

  final _commentBoxTextListener = ValueNotifier(false);

  @override
  void initState() {
    if (widget.focused!) _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Row(
            children: [
              CircleImage(
                url: widget.profilePhotoPath!,
                radius: 20,
                withBaseUrl: false,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: TextField(
                focusNode: _focusNode,
                controller: _commentController,
                minLines: 1,
                maxLines: 4,
                onChanged: (value) {
                  _commentBoxTextListener.value =
                      _commentController.text.isNotEmpty;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Add a comment'),
              )),
              ValueListenableBuilder<bool>(
                  valueListenable: _commentBoxTextListener,
                  builder: (context, hasText, child) {
                    return InkWell(
                      onTap: !hasText
                          ? null
                          : () {
                              widget.onCommentSent(_commentController.text);
                              _commentController.clear();
                              _focusNode.unfocus();
                            },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: hasText
                                ? AppColors.primaryColor
                                : Colors.grey[100],
                            shape: BoxShape.circle),
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(
                          Icons.send,
                          size: 24,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }
}

class CommentItemWidget extends StatefulWidget {
  const CommentItemWidget(
      {Key? key,
      required this.comment,
      this.shouldLoad = false,
      this.onCommentSent,
      required this.feedId})
      : super(key: key);
  final Comment comment;
  final bool? shouldLoad;
  final String feedId;
  final VoidCallback? onCommentSent;

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  final FeedBloc _feedBloc = FeedBloc(injector.get());

  @override
  void initState() {
    if (widget.shouldLoad != null) {
      // log("kjdzhvjsvbnukbjnwuibhnwoiubhnweiuobhweoibuhewbiuo");
      if (widget.shouldLoad!) {
        _feedBloc.add(CommentEvent(
            feedId: widget.feedId, comment: widget.comment.comment));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleImage(
            url: widget.comment.user.profilePhotoPath!,
            radius: 18,
            withBaseUrl: false,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${widget.comment.user.firstname} ${widget.comment.user.lastname}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.comment.comment),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  BlocConsumer<FeedBloc, FeedState>(
                      bloc: _feedBloc,
                      listener: (_, state) {
                        if (state is CommentsSuccessState) {
                          log("Comment sent: ${state.postCommentsResponse}");
                          if (widget.onCommentSent != null) {
                            widget.onCommentSent!();
                          }
                        }
                        if (state is CommentsFaliureState) {
                          log("Comment Error: ${state.error}");
                          if (widget.onCommentSent != null) {
                            widget.onCommentSent!();
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is CommentsSuccessState) {
                          return Text(
                            widget.comment.createdAt != null
                                ? AppUtils.getTimeAgo(widget.comment.createdAt!)
                                : '1 sec ago',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          );
                        }
                        if (state is CommentsLoadingState) {
                          return const Text(
                            'Sending...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        if (state is CommentsFaliureState) {
                          return GestureDetector(
                              onTap: () {
                                if (widget.shouldLoad!) {
                                  _feedBloc.add(CommentEvent(
                                      feedId: widget.feedId,
                                      comment: widget.comment.comment));
                                }
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'Retry',
                                    style:
                                        TextStyle(color: AppColors.textColor),
                                  ),
                                ],
                              ));
                        }
                        return Text(
                          widget.comment.createdAt != null
                              ? AppUtils.getTimeAgo(widget.comment.createdAt!)
                              : '1 sec ago',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        );
                      }),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // const Text(
                  //   'like',
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // const Text(
                  //   '12 replies',
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: const [
                  //     FaIcon(
                  //       FontAwesomeIcons.solidThumbsUp,
                  //       color: AppColors.primaryColor,
                  //       size: 12,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Text(
                  //       '126',
                  //       style: TextStyle(fontSize: 12, color: Colors.grey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     Container(
              //       width: 30,
              //       height: 1,
              //       color: Colors.grey,
              //     ),
              //     const SizedBox(
              //       width: 7,
              //     ),
              //     const Text(
              //       'View more replies',
              //       style: TextStyle(fontSize: 12, color: Colors.grey),
              //     ),
              //   ],
              // )
            ],
          ))
        ],
      ),
    );
  }
}
