import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_card.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/status_views.dart';
import 'package:creative_movers/screens/main/notification/views/notification_screen.dart';
import 'package:creative_movers/screens/main/search/views/search__screen.dart';
import 'package:creative_movers/screens/widget/sliver_persistent_delegate.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  String? username;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFeedAppBar(
        username: username,
      ),
      body: NestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // SliverPersistentHeader(
            //     pinned: true,
            //     floating: true,
            //     delegate: SliverAppBarDelegate(
            //       const PreferredSize(
            //           preferredSize: Size.fromHeight(0),
            //           child: SizedBox.shrink()),
            //     )),
            // SliverPersistentHeader(
            //     pinned: true,
            //     // floating: true,
            //     delegate: SliverAppBarDelegate(
            //       const PreferredSize(
            //         preferredSize: Size.fromHeight(100),
            //         child: StatusViews(
            //           curvedBottom: true,
            //         ),
            //       ),
            //     )),
          ];
        },
        body: CustomScrollView(
          // controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
                // pinned: true,
                floating: true,
                delegate: SliverAppBarDelegate(
                  const PreferredSize(
                    preferredSize: Size.fromHeight(100),
                    child: StatusViews(
                      curvedBottom: true,
                    ),
                  ),
                )),
            const SliverToBoxAdapter(child: PostCard()),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return const PostItem();
                  },
                  childCount: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomFeedAppBar({Key? key, this.username}) : super(key: key);
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 45, left: 10, right: 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hello $username!',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text('${greeting()} 🌞',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return ' Good Morning';
    }
    if (hour < 17) {
      return ' Good Afternoon';
    }
    return ' Good Evening';
  }
}
