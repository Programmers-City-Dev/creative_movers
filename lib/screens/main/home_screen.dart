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
    const FeedScreen(),
    const BuisnessScreen(),
    const ContactScreen(),
    const ChatScreen()
  ];
  int _screenIndex = 0;

  final bottomNavItems = [
    BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.svgFeed, color: Colors.grey),
        // activeColor: AppColors.primaryColor,
        // title: const Text(''),

        activeIcon: const NavSelectedIcon(
          label: 'Feed',
          strIcon: AppIcons.svgFeed,
        ),
        label: 'Feed'),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.svgStore, color: Colors.grey),
        // activeColor: AppColors.primaryColor,
        // title: const Text(''),

        activeIcon: const NavSelectedIcon(
          label: 'Biz',
          strIcon: AppIcons.svgStore,
        ),
        label: 'Biz'),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.svgPeople, color: Colors.grey),
        // activeColor: AppColors.primaryColor,
        // title: const Text(''),

        activeIcon: const NavSelectedIcon(
          label: 'List',
          strIcon: AppIcons.svgPeople,
        ),
        label: 'Contact'),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(AppIcons.svgMessage, color: Colors.grey),
        // activeColor: AppColors.primaryColor,
        // title: const Text(''),

        activeIcon: const NavSelectedIcon(
          label: 'Chat',
          strIcon: AppIcons.svgMessage,
        ),
        label: 'Chat'),
    const BottomNavigationBarItem(
        icon: CircleAvatar(
          backgroundColor: AppColors.lightBlue,
          radius: 22,
          child: CircleAvatar(
            radius: 20,
          ),
        ),
        // activeColor: AppColors.primaryColor,
        // title: const Text(''),

        label: 'Profile'),
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
        backgroundColor: AppColors.smokeWhite,
        appBar: AppBar(
          elevation: 0,
          primary: true,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: AppColors.textColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.notifications,
                color: AppColors.textColor,
              ),
            ),
          ],
          leading: const Icon(
            Icons.menu_outlined,
            color: AppColors.textColor,
          ),
          title: const Text(
            'Creative Movers',
            style: TextStyle(color: AppColors.textColor),
          ),
          backgroundColor: Colors.white,
        ),
        body: screens[_screenIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _screenIndex,
          showElevation: true, // use this to remove appBar's elevation
          itemCornerRadius: 4,
          containerHeight: kToolbarHeight,
          onItemSelected: (index) => setState(() {
            _screenIndex = index;
            // _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: const Icon(Icons.rss_feed_outlined),
                title: const Text('Feed'),
                // textAlign: TextAlign.center,
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                icon: const Icon(Icons.work_outline),
                title: const Text('Biz'),
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blueGrey),
            BottomNavyBarItem(
                icon: const Icon(Icons.chat_bubble_outline_outlined),
                title: const Text('Chats'),
                activeColor: AppColors.primaryColor,
                inactiveColor: AppColors.primaryColor),
            BottomNavyBarItem(
                icon: const CircleAvatar(
                  radius: 17,
                  backgroundImage: AssetImage('assets/images/slide_i.png'),
                ),
                title: const Text('Profile'),
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.blueGrey),
          ],
        ));
  }
}

// SizedBox(
//         height: 55,
//         width: 55,
//         child: BottomNavigationBar(
//           selectedFontSize: 0.0,
//           unselectedFontSize: 0.0,
//           selectedIconTheme: const IconThemeData(size: 1),
//           unselectedIconTheme: const IconThemeData(size: 2),
//           elevation: 25,
//           iconSize: 0,
//           type: BottomNavigationBarType.shifting,
//           showUnselectedLabels: false,
//           showSelectedLabels: false,
//           items: bottomNavItems,
//           currentIndex: _screenIndex,
//           onTap: (index) {
//             setState(() {
//               _screenIndex = index;
//             });
//           },
//         ),
//       ),