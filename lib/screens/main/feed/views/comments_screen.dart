import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_text_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.feed}) : super(key: key);
  final Feed feed;

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentScrollController = ScrollController();

  @override
  void initState() {
    injector.get<CacheCubit>().fetchCachedUserData();
    super.initState();
  }

  // final _commentController = TextEditingController();
  // final FeedBloc _feedBloc = FeedBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle:
            const TextStyle(color: AppColors.textColor, fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textColor),
        backgroundColor: AppColors.white,
        title: const Text('Comments'),
      ),
      body: BlocBuilder<CacheCubit, CacheState>(
        bloc: injector.get<CacheCubit>(),
        builder: (context, state) {
          if (state is CachedUserDataFetched) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _commentScrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PostTextItem(
                          feed: widget.feed,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.feed.comments.isEmpty
                            ? const Center(child: Text('No Comments'))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.feed.comments.length,
                                itemBuilder: (context, index) =>
                                    CommentItemWidget(
                                  comment: widget.feed.comments[index],
                                  feedId: '${widget.feed.id}',
                                  shouldLoad:
                                      widget.feed.comments[index].shouldLoad,
                                  onCommentSent: () {
                                    widget.feed.comments[index].shouldLoad =
                                        false;
                                  },
                                ),
                              ),
                      ],
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
                          setState(() {});
                          widget.feed.comments.add(Comment(
                              id: 4,
                              userId: widget.feed.userId,
                              comment: text,
                              feedId: ' ${widget.feed.id}',
                              user: Poster(
                                  id: int.parse(widget.feed.userId),
                                  firstname: state.cachedUser.firstname!,
                                  lastname: state.cachedUser.lastname!,
                                  profilePhotoPath:
                                      state.cachedUser.profilePhotoPath),
                              shouldLoad: true));
                          _commentScrollController.animateTo(
                            _commentScrollController.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: Column(
                //     children: [
                //       const Divider(),
                //       Row(
                //         children: [
                //           CircleAvatar(
                //             backgroundColor: AppColors.lightBlue,
                //             radius: 20,
                //             child: CircleAvatar(
                //               backgroundImage: NetworkImage(
                //                   state.cachedUser.profilePhotoPath!),
                //               radius: 18,
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 15,
                //           ),
                //           Expanded(
                //               child: TextField(
                //             controller: _commentController,
                //             minLines: 1,
                //             maxLines: 5,
                //             decoration: const InputDecoration(
                //                 border: InputBorder.none,
                //                 hintText: 'Add a comment'),
                //           )),
                //           InkWell(
                //             onTap: () {
                //               setState(() {
                //                 _feedBloc.add(CommentEvent(
                //                     feedId: widget.feed.id.toString(),
                //                     comment: _commentController.text));
                //                 widget.feed.comments.add(Comment(
                //                     id: 4,
                //                     userId: widget.feed.userId,
                //                     comment: _commentController.text,
                //                     feedId: ' ${widget.feed.id}',
                //                     user: Poster(
                //                         id: 4,
                //                         firstname: state.cachedUser.firstname!,
                //                         lastname: state.cachedUser.lastname!,
                //                         profilePhotoPath: widget
                //                             .feed.user!.profilePhotoPath)));
                //                 _commentController.clear();
                //               });
                //             },
                //             child: const Text(
                //               'Post',
                //               style: TextStyle(
                //                 color: AppColors.primaryColor,
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
