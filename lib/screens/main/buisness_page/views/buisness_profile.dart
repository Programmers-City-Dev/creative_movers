import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/screens/main/buisness_page/views/create_page_onboarding.dart';
import 'package:creative_movers/screens/main/buisness_page/views/view_buisness_page_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'buisness_page_screen.dart';

class BuisnessProfileScreen extends StatefulWidget {
  const BuisnessProfileScreen(
      {Key? key, required this.profile, required this.onCreatePage})
      : super(key: key);
  final BuisnessProfile profile;
  final VoidCallback onCreatePage;

  @override
  _BuisnessProfileScreenState createState() => _BuisnessProfileScreenState();
}

class _BuisnessProfileScreenState extends State<BuisnessProfileScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  int currentIndex = 0;
  List<BusinessPage> pages = [];

  late TabController _tabController;
  BuisnessBloc _buisnessBloc = BuisnessBloc();

  @override
  void initState() {
    super.initState();
    _buisnessBloc.add(PageSuggestionsEvent());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    if (widget.profile.profile.pages.length > 5) {
      pages = widget.profile.profile.pages.getRange(0, 5).toList();
    } else {
      pages = widget.profile.profile.pages;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: 250,
            decoration: BoxDecoration(
                color: AppColors.black,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.profile.profile.profilePhotoPath,
                    ))),
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.stacked_bar_chart_rounded,
                    color: AppColors.smokeWhite,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Buisness Profile',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      ' ${widget.profile.profile.firstname} ${widget.profile.profile.lastname}',
                      style:  const TextStyle(fontWeight: FontWeight.w700,fontSize:15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 10,
                      width: 2,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.profile.profile.role,
                      style: const TextStyle(
                          color: AppColors.primaryColor, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.profile.profile.biodata,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(
                  height: 16,
                ),
                widget.profile.profile.role == 'creative'
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buisness Category',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Wrap(
                                spacing: 5,
                                children: widget.profile.profile.categories
                                    .map((e) => Chip(
                                          label: Text(
                                            e,
                                            style: const TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                          backgroundColor: Colors.grey.shade200,
                                        ))
                                    .toList()),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Buisness Pages',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(child: SizedBox()),
                                widget.profile.profile.pages.length >=5
                                    ? const Text(
                                        'View more',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            pages.isNotEmpty
                                ? Container(
                              height: 130,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: pages.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          // Navigator.pop(context);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                BuisnessPageScreen(
                                              page: pages[index],
                                            ),
                                          ));
                                        },
                                        child: Card(
                                          elevation: 0,
                                          // shadowColor: AppColors.smokeWhite,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: SizedBox(
                                            width: 110,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  height: 70,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(widget
                                                                      .profile
                                                                      .profile
                                                                      .pages[
                                                                          index]
                                                                      .photoPath !=
                                                                  null
                                                              ? widget
                                                                  .profile
                                                                  .profile
                                                                  .pages[
                                                                      index]
                                                                  .photoPath!
                                                              : 'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'))),

                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  child: Text(
                                                      widget.profile.profile
                                                                .pages[index].name,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  child: Text(
                                                      widget.profile.profile
                                                          .pages[index]
                                                        .category[0],
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.blueGrey),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                                : const NoPageWidget(),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CreatePageOnboarding(),
                                ));
                              },
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: AppColors.white,
                                      ),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'CREATE A BUISNESS PAGE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Preferred Investment Stage',
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.profile.profile.investments[0].stage,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Investment Range',
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${widget.profile.profile.investments[0].minRange} -  ${widget.profile.profile.investments[0].maxRange}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<BuisnessBloc, BuisnessState>(
                  bloc: _buisnessBloc,
                  builder: (context, state) {
                    if (state is PageSuggestionsLoadingState) {
                      return CircularProgressIndicator();
                    }
                    if (state is PageSuggestionsSuccesState) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Page Suggestions',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '+2 more',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 130,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    state.buisnessProfile.sugestedpages.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Card(
                                  elevation: 0,
                                  // shadowColor: AppColors.smokeWhite,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: SizedBox(
                                    width: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewBuisnessPageScreen(
                                                      page_id: state
                                                          .buisnessProfile
                                                          .sugestedpages[index]
                                                          .id
                                                          .toString()),
                                            ));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 70,
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      state
                                                                  .buisnessProfile
                                                                  .sugestedpages[
                                                                      index]
                                                                  .photoPath ==
                                                              null
                                                          ? 'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'
                                                          : state
                                                              .buisnessProfile
                                                              .sugestedpages[
                                                                  index]
                                                              .photoPath!,
                                                    ))),
                                            // child: Stack(
                                            //   children: [
                                            //     Container(
                                            //       decoration: BoxDecoration(
                                            //           gradient: LinearGradient(
                                            //               colors: [
                                            //                 AppColors.black.withOpacity(1),
                                            //                 AppColors.black.withOpacity(0.5),
                                            //                 AppColors.black.withOpacity(0.3)
                                            //               ],
                                            //               begin: Alignment.bottomCenter,
                                            //               end: Alignment.topCenter)),
                                            //     ),
                                            //     Align(
                                            //         alignment: Alignment.bottomLeft,
                                            //         child: Padding(
                                            //           padding: const EdgeInsets.all(16),
                                            //           child: Column(
                                            //             crossAxisAlignment:
                                            //             CrossAxisAlignment.start,
                                            //             mainAxisSize: MainAxisSize.min,
                                            //             children: const [
                                            //               Text(
                                            //                 ' widget.page.name',
                                            //                 style: TextStyle(
                                            //                     color: Colors.white,
                                            //                     fontSize: 20),
                                            //               ),
                                            //               SizedBox(
                                            //                 height: 5,
                                            //               ),
                                            //               // Row(
                                            //               //   children: [
                                            //               //     ImageStack.providers(
                                            //               //       imageBorderWidth: 1,
                                            //               //       providers: const [
                                            //               //         NetworkImage(
                                            //               //             'https://encrypted-tbn0.gstatic.com/imag'
                                            //               //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                                            //               //                 'IsMSaTdFerTaA&usqp=CAU'),
                                            //               //         NetworkImage(
                                            //               //             'https://encrypted-tbn0.gstatic.com/imag'
                                            //               //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                                            //               //                 'IsMSaTdFerTaA&usqp=CAU'),
                                            //               //         NetworkImage(
                                            //               //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                                            //               //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                                            //               //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                                            //               //         ),
                                            //               //         NetworkImage(
                                            //               //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                                            //               //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                                            //               //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                                            //               //         )
                                            //               //       ],
                                            //               //       totalCount: 5,
                                            //               //       imageCount: 5,
                                            //               //     ),
                                            //               //     SizedBox(
                                            //               //       width: 10,
                                            //               //     ),
                                            //               //   ],
                                            //               // ),
                                            //               SizedBox(
                                            //                 height: 5,
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ))
                                            //   ],
                                            // ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Text(
                                            state.buisnessProfile
                                                .sugestedpages[index].name,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Text(
                                            state
                                                .buisnessProfile
                                                .sugestedpages[index]
                                                .category[0],
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.blueGrey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {
      selectedIndex = _tabController.index;
      // log("INDEX:$selectedIndex");
    });
  }
}

class NoPageWidget extends StatelessWidget {
  const NoPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svgs/request.svg',
              height: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'You have no pages yet..',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // child: CustomButton(
              //   child: const Text('CREATE A BUSINESS PAGE'),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => const CreatePageOnboarding(),
              //     ));
              //   },
              // ),
            )
          ],
        ),
      ),
    );
  }
}
