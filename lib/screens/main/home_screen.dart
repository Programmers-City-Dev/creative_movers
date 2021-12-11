import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/buisness_screen.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/widgets/nav_selected_icon.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screens = [
    FeedScreen(),
    BuisnessScreen(),
    ContactScreen(),
    ChatScreen()
  ];
  int _screenIndex = 0;

  final bottomNavItems = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.svgFeed,
        color: AppColors.primaryColor,
      ),
      // activeColor: AppColors.primaryColor,
      // title: const Text(''),

      activeIcon: const NavSelectedIcon(
        label: 'FEED',
        strIcon: AppIcons.svgFeed,
      ),
      label: 'FEED',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.svgFeed,
        color: AppColors.primaryColor,
      ),
      // activeColor: AppColors.primaryColor,
      // title: const Text(''),

      activeIcon: const NavSelectedIcon(
        label: 'FEED',
        strIcon: AppIcons.svgFeed,
      ),
      label: 'FEED',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.svgFeed,
        color: AppColors.primaryColor,
      ),
      // activeColor: AppColors.primaryColor,
      // title: const Text(''),

      activeIcon: const NavSelectedIcon(
        label: 'FEED',
        strIcon: AppIcons.svgFeed,
      ),
      label: 'FEED',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.svgFeed,
        color: AppColors.primaryColor,
      ),
      // activeColor: AppColors.primaryColor,
      // title: const Text(''),

      activeIcon: const NavSelectedIcon(
        label: 'FEED',
        strIcon: AppIcons.svgFeed,
      ),
      label: 'FEED',
    ),
  ];

  // final bottomNavItems = [
  //   BottomNavigationBarItem(
  //
  //     icon: SvgPicture.asset(AppIcons.svgFeed,color: AppColors.primaryColor,),
  //     activeIcon:  const NavSelectedIcon(label: 'FEED', strIcon: AppIcons.svgFeed,),
  //     label: 'FEED',
  //   ),
  //   BottomNavigationBarItem(
  //       icon: SvgPicture.asset(AppIcons.svgStore,color: AppColors.primaryColor,),
  //       activeIcon:  const NavSelectedIcon(label: 'BIZ PAGE', strIcon: AppIcons.svgStore,),
  //       label: 'BUISNESS PAGE'),
  //   BottomNavigationBarItem(
  //       icon: SvgPicture.asset(AppIcons.svgPeople,color: AppColors.primaryColor,),
  //
  //       activeIcon:  const NavSelectedIcon(label: 'CONTACT',strIcon: AppIcons.svgPeople,),
  //       label: 'CONTACT'),
  //   BottomNavigationBarItem(
  //       icon: SvgPicture.asset(AppIcons.svgMessage,color: AppColors.primaryColor,),
  //
  //       activeIcon:  const NavSelectedIcon(label: 'CHAT', strIcon: AppIcons.svgMessage,),
  //       label: 'CHAT'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        backgroundColor: Colors.white,
      ),
      body: screens[_screenIndex],
      bottomNavigationBar: Container(
        height: 50,
        width: 45,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: BottomNavigationBar(

          items: bottomNavItems,
          currentIndex: _screenIndex,
          onTap: (index) {
            setState(() {
              _screenIndex = index;
            });
          },
        ),
      ),
    );
  }
}
