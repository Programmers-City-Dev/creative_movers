import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/about_page_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/widgets/create_post_card.dart';
import 'package:creative_movers/screens/main/feed/widgets/feed_loader.dart';
import 'package:creative_movers/screens/main/feed/widgets/new_post_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_item.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/image_list.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_stack/image_stack.dart';

class ViewBuisnessPageScreen extends StatefulWidget {
  const ViewBuisnessPageScreen({Key? key, required this.page_id})
      : super(key: key);
  final String page_id;

  @override
  _ViewBuisnessPageScreenState createState() => _ViewBuisnessPageScreenState();
}

class _ViewBuisnessPageScreenState extends State<ViewBuisnessPageScreen> {
  BuisnessBloc _buisnessBloc = BuisnessBloc();
  BuisnessBloc _buisnessBloc2 = BuisnessBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buisnessBloc.add(GetPageEvent(widget.page_id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuisnessBloc, BuisnessState>(
      bloc: _buisnessBloc,
      builder: (context, state) {
        if (state is GetPageLoadingState) {
        return  Container(child: Center(child: const CircularProgressIndicator()));
        }
        if (state is GetPageSuccesState) {
          _buisnessBloc2.add(PageFeedsEvent(widget.page_id.toString()));
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(state.getPageResponse.page?.photoPath != null
                                ? state.getPageResponse.page!.photoPath!
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
                                   state.getPageResponse.page!.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      ImageStack.providers(
                                        imageBorderWidth: 1,
                                        providers: const [
                                          NetworkImage(
                                              'https://encrypted-tbn0.gstatic.com/imag'
                                                  'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                                                  'IsMSaTdFerTaA&usqp=CAU'),
                                          NetworkImage(
                                              'https://encrypted-tbn0.gstatic.com/imag'
                                                  'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                                                  'IsMSaTdFerTaA&usqp=CAU'),
                                          NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                                                'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                                                'LZKNzyR9E9kzjH55-w&usqp=CAU',
                                          ),
                                          NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                                                'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                                                'LZKNzyR9E9kzjH55-w&usqp=CAU',
                                          )
                                        ],
                                        totalCount: 5,
                                        imageCount: 5,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            AboutPageScreen(
                                              page: state.getPageResponse.page!,
                                            ),
                                      ));
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.longArrowAltLeft,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'More about Creative Movers',
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  )
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
                                const Text(
                                  '756+ ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
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
                                CustomButton(
                                  height: 50,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(AppIcons.svgFollowing,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      const Text('Follow'),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Column(
                                    children: const [
                                      Text(
                                        '454+ ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Connections ',
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
                                SizedBox(
                                  height: 50,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: AppColors.lightBlue),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.svgConnects,
                                            color: AppColors.primaryColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text('Connect'),
                                        ],
                                      )),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  BlocBuilder<BuisnessBloc, BuisnessState>(
                    bloc: _buisnessBloc2,
                    builder: (context, state) {
                      if (state is PageFeedsLoadingState) {
                        return FeedLoader();
                      }
                      if (state is PageFeedsSuccesState) {
                        return state.feedsResponse.feeds.data.isNotEmpty
                            ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                          state.feedsResponse.feeds.data.length,
                          itemBuilder: (context, index) =>
                              NewPostItem(
                                  feed:
                                  state.feedsResponse.feeds.data[index]),
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
                          onTap: () =>
                              _buisnessBloc
                                  .add(
                                  PageFeedsEvent(widget.page_id.toString())),
                        );
                      }
                      return FeedLoader();
                    },
                  ),
                ],
              ),
            ),
          );
        }
        if (state is GetPageFailureState) {
          return Center(child: Text(state.error),);
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
