import 'dart:developer';

import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/widgets/create_post_card.dart';
import 'package:creative_movers/screens/main/feed/views/create_post.dart';
import 'package:creative_movers/screens/main/feed/widgets/feed_loader.dart';
import 'package:creative_movers/screens/main/feed/widgets/new_post_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'about_page_screen.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key, required this.page}) : super(key: key);
  final BusinessPage page;

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<String> placeholders = [
    AppIcons.icPlaceHolder1,
    AppIcons.icPlaceHolder2,
    AppIcons.icPlaceHolder3,
    AppIcons.icPlaceHolder4
  ];

  String userType = 'all';
  final BuisnessBloc _buisnessBloc = BuisnessBloc();

  @override
  void initState() {
    super.initState();
    _buisnessBloc.add(PageFeedsEvent(widget.page.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _buisnessBloc.add(PageFeedsEvent(widget.page.id.toString()));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.page.photoPath != null
                          ? widget.page.photoPath!
                          : 'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'))),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          AppColors.black.withOpacity(1),
                          AppColors.black.withOpacity(0.5),
                          AppColors.black.withOpacity(0.3)
                        ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter)),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.page.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Row(
                            //   children: [
                            //     ImageStack.providers(
                            //       imageBorderWidth: 1,
                            //       providers: const [
                            //         NetworkImage(
                            //             'https://encrypted-tbn0.gstatic.com/imag'
                            //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                            //                 'IsMSaTdFerTaA&usqp=CAU'),
                            //         NetworkImage(
                            //             'https://encrypted-tbn0.gstatic.com/imag'
                            //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                            //                 'IsMSaTdFerTaA&usqp=CAU'),
                            //         NetworkImage(
                            //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                            //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                            //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                            //         ),
                            //         NetworkImage(
                            //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                            //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                            //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                            //         )
                            //       ],
                            //       totalCount: 5,
                            //       imageCount: 5,
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.page.followers?.length.toString() ?? '0',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      const Text(
                        'Followers ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AboutPageScreen(page: widget.page),
                          ));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: const [
                              Icon(Icons.info),
                              Text(
                                'About Page',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: AppColors.textColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  log(widget.page.id.toString());
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => CreatePostScreen(
                      pageId: widget.page.id.toString(),
                      postType: "page_feed",
                    ),
                  ))
                      .then((value) {
                    if (value ?? false) {
                      _buisnessBloc
                          .add(PageFeedsEvent(widget.page.id.toString()));
                    }
                  });
                },
                child: const CreatePostCard()),
            BlocProvider.value(
              value: _buisnessBloc,
              child: BlocBuilder<BuisnessBloc, BuisnessState>(
                bloc: _buisnessBloc,
                builder: (context, state) {
                  var feeds = context.watch<BuisnessBloc>().feeds;
                  if (state is PageFeedsLoadingState) {
                    return const FeedLoader();
                  }
                  if (state is PageFeedsSuccesState) {
                    return state.feedsResponse.feeds.data.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.feedsResponse.feeds.data.length,
                            itemBuilder: (context, index) => NewPostItem(
                              feed: state.feedsResponse.feeds.data[index]!,
                              onUpdated: () {},
                              onDeleted: (feed) {
                                _buisnessBloc.add(
                                    PageFeedsEvent(widget.page.id.toString()));
                              },
                            ),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text('You have no feeds yet ..'),
                            ),
                          );
                  }
                  if (state is PageFeedsFailureState) {
                    return AppPromptWidget(
                      isSvgResource: true,
                      message: state.error,
                      onTap: () => _buisnessBloc
                          .add(PageFeedsEvent(widget.page.id.toString())),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
