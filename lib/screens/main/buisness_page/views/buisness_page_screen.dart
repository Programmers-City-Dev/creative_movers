import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/following_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/page_home.dart';
import 'package:creative_movers/screens/main/buisness_page/views/page_notification.dart';
import 'package:creative_movers/screens/main/buisness_page/widgets/create_post_card.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuisnessPageScreen extends StatefulWidget {
  const BuisnessPageScreen({Key? key}) : super(key: key);

  @override
  _BuisnessPageScreenState createState() => _BuisnessPageScreenState();
}

class _BuisnessPageScreenState extends State<BuisnessPageScreen> {
  List<String> placeholders = [
    AppIcons.icPlaceHolder1,
    AppIcons.icPlaceHolder2,
    AppIcons.icPlaceHolder3,
    AppIcons.icPlaceHolder4
  ];

  List pages = [
    PageHome(),
    FollowingScreen(),
    PageNotifications(),
    PageHome(),
  ];

  int selectedIndex = 0;
  String userType = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jave Network',style: TextStyle(fontSize: 16),),),
      backgroundColor: AppColors.smokeWhite,
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height:40 ,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                 shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                          userType = 'home';
                        });
                      },
                      child: Chip(
                          padding: EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'home'
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          backgroundColor: userType == 'home'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'home'
                                    ? Colors.white
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
                          userType = 'following';
                        });
                      },
                      child: Chip(
                          padding: EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'following'
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          backgroundColor: userType == 'following'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Following',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'following'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'notification';
                          selectedIndex = 2 ;
                        });
                      },
                      child: Chip(
                          avatar: Icon(
                            Icons.notifications_rounded,
                            color: userType == 'notification'
                                ? Colors.white
                                : AppColors.primaryColor,
                            size: 20,
                          ),
                          backgroundColor: userType == 'notification'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Notification',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'notification'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'editPage';
                          selectedIndex =3;
                        });
                      },
                      child: Chip(
                          avatar: Icon(
                            Icons.edit_rounded,
                            color: userType == 'editPage'
                                ? Colors.white
                                : AppColors.primaryColor,
                            size: 20,
                          ),
                          backgroundColor: userType == 'editPage'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Edit Page',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'editPage'
                                    ? Colors.white
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

                onPageChanged: (index){
                  setState(() {
                    selectedIndex =index;
                  });
                },
                scrollBehavior:ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch) ,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[selectedIndex],
              ),
            )
          ],
        ),
      )),
    );
  }
}
