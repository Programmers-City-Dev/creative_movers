
import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/buisness_page/views/view_buisness_page_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuisnessScreen extends StatefulWidget {
  const BuisnessScreen({Key? key, required this.page}) : super(key: key);
  final BusinessPage page;

  @override
  _BuisnessScreenState createState() => _BuisnessScreenState();
}

BuisnessBloc _buisnessBloc = BuisnessBloc();

class _BuisnessScreenState extends State<BuisnessScreen>   with SingleTickerProviderStateMixin{

  int selectedIndex = 0;
  List<Widget> pages =  [];



  late TabController _tabController;

  String pageType = 'my_pages';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _buisnessBloc.add(BuisnessProfileEvent());
    pages = [
      MyPageTab(),
      ViewBuisnessPageScreen(
        pageId: widget.page.id.toString(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              height: 40,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        pageType = 'my_pages';
                      });
                    },
                    child: Chip(
                        padding: EdgeInsets.all(7),
                        avatar: SvgPicture.asset(
                          AppIcons.svgPeople,
                          color: pageType == 'my_pages'
                              ? AppColors.white
                              : AppColors.primaryColor,
                        ),
                        backgroundColor: pageType == 'my_pages'
                            ? AppColors.primaryColor
                            : AppColors.lightBlue,
                        label: Text(
                          'My Pages',
                          style: TextStyle(
                              fontSize: 13,
                              color: pageType == 'my_pages'
                                  ? AppColors.white
                                  : AppColors.textColor),
                        )),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                        pageType = 'following_pages';
                      });
                    },
                    child: Chip(
                        padding: EdgeInsets.all(7),
                        avatar: SvgPicture.asset(
                          AppIcons.svgPeople,
                          color: pageType == 'following_pages'
                              ? AppColors.white
                              : AppColors.primaryColor,
                        ),
                        backgroundColor: pageType == 'following_pages'
                            ? AppColors.primaryColor
                            : AppColors.lightBlue,
                        label: Text(
                          'Following',
                          style: TextStyle(
                              fontSize: 13,
                              color: pageType == 'following_pages'
                                  ? AppColors.white
                                  : AppColors.textColor),
                        )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pages.length,
              itemBuilder: (context, index) => pages[selectedIndex],
            ),
          )
        ],
      ),
    ));
  }

  void _handleTabSelection() {
    setState(() {
      selectedIndex = _tabController.index;
      // log("INDEX:$selectedIndex");
    });
  }
}
