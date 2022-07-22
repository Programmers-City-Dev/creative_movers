import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/following_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/page_home.dart';
import 'package:creative_movers/screens/main/buisness_page/views/page_notification.dart';

import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'edit_page_form.dart';

class BuisnessPageScreen extends StatefulWidget {
  final BusinessPage page;



  const BuisnessPageScreen({Key? key, required this.page, }) : super(key: key);

  @override
  _BuisnessPageScreenState createState() => _BuisnessPageScreenState();
}

class _BuisnessPageScreenState extends State<BuisnessPageScreen> {

 late BusinessPage businessPage ;
  List<String> placeholders = [
    AppIcons.icPlaceHolder1,
    AppIcons.icPlaceHolder2,
    AppIcons.icPlaceHolder3,
    AppIcons.icPlaceHolder4
  ];

  List pages = [
  ];

  int selectedIndex = 0;
  String userType = 'home';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      PageHome(page: widget.page,),
      FollowingScreen(),
      PageNotifications(),
       Padding(
        padding: EdgeInsets.all(18),
        child: EditPageForm(businessPage: widget.page,),
      )
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(widget.page.name,style: TextStyle(fontSize: 16),),),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height:40 ,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
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
                          padding: const EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'home'
                                ? AppColors.white
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
                          userType = 'following';
                        });
                      },
                      child: Chip(
                          padding: const EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'following'
                                ? AppColors.white
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
                          userType = 'notification';
                          selectedIndex = 2 ;
                        });
                      },
                      child: Chip(
                          avatar: Icon(
                            Icons.notifications_rounded,
                            color: userType == 'notification'
                                ? AppColors.white
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
                          userType = 'editPage';
                          selectedIndex =3;
                        });
                      },
                      child: Chip(
                          avatar: Icon(
                            Icons.edit_rounded,
                            color: userType == 'editPage'
                                ? AppColors.white
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

                onPageChanged: (index){
                  setState(() {
                    selectedIndex =index;
                  });
                },
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
