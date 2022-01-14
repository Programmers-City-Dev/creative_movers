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
          itemCornerRadius: 8,
          containerHeight: kToolbarHeight + 8,
          onItemSelected: (index) => setState(() {
            _screenIndex = index;
            // _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                // icon: const Icon(Icons.work_outline),
                icon: SvgPicture.asset(
                  'assets/svgs/feed.svg',
                  color: AppColors.primaryColor,
                ),
                title: const Text(
                  'Feeds',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.transparent),
            BottomNavyBarItem(
                // icon: const Icon(Icons.work_outline),
                icon: SvgPicture.asset(
                  'assets/svgs/biz.svg',
                  color: AppColors.primaryColor,
                ),
                title: const Text(
                  'Biz Page',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
                activeColor:
                    _screenIndex == 1 ? AppColors.primaryColor : Colors.white,
                inactiveColor: Colors.transparent),
            BottomNavyBarItem(
                // icon: const Icon(Icons.work_outline),
                icon: SvgPicture.asset(
                  'assets/svgs/chats.svg',
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  'Chats',
                  style: TextStyle(
                    color: _screenIndex == 2
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                ),
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.transparent),
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