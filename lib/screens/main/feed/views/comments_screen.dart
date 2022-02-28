import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/screens/main/feed/widgets/comment_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_text_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.feed}) : super(key: key);
  final Feed feed;

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    injector.get<CacheCubit>().fetchCachedUserData();
    super.initState();
  }

  var _commentController = TextEditingController();
  FeedBloc _feedBloc = FeedBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle:
        const TextStyle(color: AppColors.textColor, fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textColor),
        backgroundColor: Colors.white,
        title: const Text('Comments'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.paperPlane),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: BlocBuilder<CacheCubit, CacheState>(
        bloc: injector.get<CacheCubit>(),
        builder: (context, state) {
          if (state is CachedUserDataFetched) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                              CommentItem(
                                comment: widget.feed.comments[index],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        children: [
                           CircleAvatar(
                            backgroundColor: AppColors.lightBlue,
                            radius: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  state.cachedUser.profilePhotoPath!),
                              radius: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: TextField(
                                controller: _commentController,
                                minLines: 1,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Add a comment'),
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _feedBloc.add(CommentEvent(
                                    feed_id: widget.feed.id.toString(),
                                    comment: _commentController.text));
                                widget.feed.comments.add(Comment(
                                    id: 4,
                                    userId: '',
                                    comment: _commentController.text,
                                    feedId: '',
                                    user: Poster(
                                        id: 4,
                                        firstname: state.cachedUser.firstname!,
                                        lastname: state.cachedUser.lastname!,
                                        profilePhotoPath: 'csac')));
                                _commentController.clear();
                              });
                            },
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
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
