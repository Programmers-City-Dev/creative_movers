import 'package:creative_movers/screens/main/feed/widgets/post_card.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/status_views.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const StatusViews(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const PostCard(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => PostItem(),
                    itemCount: 5,
                    shrinkWrap: true,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
