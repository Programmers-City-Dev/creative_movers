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
import 'package:google_nav_bar/google_nav_bar.dart';

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
        bottomNavigationBar: GNav(
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            // tabActiveBorder:
            //     Border.all(color: Colors.black, width: 1), // tab button border
            // tabBorder:
            //     Border.all(color: Colors.grey, width: 1), // tab button border
            // tabShadow: [
            //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
            // ], // tab button shadow
            curve: Curves.linear, // tab animation curves
            duration: Duration(milliseconds: 200), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: AppColors.primaryColor, // unselected icon color
            activeColor: AppColors.primaryColor, // selected icon and text color
            iconSize: 24,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            backgroundColor: Colors.white,
            onTabChange: (value) {
              setState(() {
                _screenIndex = value;
              });
            },
            tabMargin: EdgeInsets.symmetric(
                vertical: 12, horizontal: 0), // tab button icon size
            tabBackgroundColor: AppColors.primaryColor
                .withOpacity(0.3), // selected tab background color
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 16), // navigation bar padding
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Feeds',
                leading: SvgPicture.asset(
                  'assets/svgs/feed.svg',
                  color: AppColors.primaryColor,
                  width: 24,
                ),
              ),
              GButton(
                icon: Icons.business,
                text: 'Biz Page',
                leading: SvgPicture.asset(
                  'assets/svgs/biz.svg',
                  color: AppColors.primaryColor,
                  width: 24,
                ),
              ),
              GButton(
                icon: Icons.chat_sharp,
                text: 'Chats',
                leading: SvgPicture.asset(
                  'assets/svgs/chats.svg',
                  color: AppColors.primaryColor,
                  width: 24,
                ),
              ),
              // GButton(
              //   icon: Icons.group_outlined,
              //   text: 'People',
              //   leading: SvgPicture.asset(
              //     'assets/svgs/group.svg',
              //     color: AppColors.primaryColor,
              //   ),
              // ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                leading: const CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage('assets/images/slide_i.png'),
                ),
              )
            ]));
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

// BottomNavyBar(
//           selectedIndex: _screenIndex,
//           showElevation: true, // use this to remove appBar's elevation
//           itemCornerRadius: 8,
//           containerHeight: kToolbarHeight + 8,
//           onItemSelected: (index) => setState(() {
//             _screenIndex = index;
//             // _pageController.animateToPage(index,
//             //     duration: Duration(milliseconds: 300), curve: Curves.ease);
//           }),
//           items: [
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/feed.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: const Text(
//                   'Feeds',
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/biz.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: const Text(
//                   'Biz Page',
//                   style: TextStyle(color: AppColors.primaryColor),
//                 ),
//                 activeColor:
//                     _screenIndex == 1 ? AppColors.primaryColor : Colors.white,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/chats.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: Text(
//                   'Chats',
//                   style: TextStyle(
//                     color: _screenIndex == 2
//                         ? AppColors.primaryColor
//                         : Colors.white,
//                   ),
//                 ),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 icon: const CircleAvatar(
//                   radius: 17,
//                   backgroundImage: AssetImage('assets/images/slide_i.png'),
//                 ),
//                 title: const Text('Profile'),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.blueGrey),
//           ],
//         )
