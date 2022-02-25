import 'dart:developer';

import 'package:creative_movers/blocs/nav/nav_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/routes.dart';
import 'package:creative_movers/screens/main/buisness_page/views/buisness_screen.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/profile/views/account_settings_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

List<GlobalKey<NavigatorState>> homeNavigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

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
    const ChatScreen(),
    const AccountSettingsScreen()
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

  int _navIndex = 0;
  final NavBloc _navBloc = injector.get<NavBloc>();

  @override
  void initState() {
    _navBloc.add(SwitchNavEvent(_navIndex));
    injector.get<ProfileBloc>().add(GetUsernameEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavBloc, NavState>(
      bloc: _navBloc,
      listener: (context, state) {
        if (state is BuyerNavItemSelected) {
          _navIndex = state.selectedIndex;
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            final isFirstRouteInCurrentTab =
                !await homeNavigatorKeys[_navIndex].currentState!.maybePop();
            debugPrint('isFirstRouteInCurrentTab: ' +
                isFirstRouteInCurrentTab.toString());
            // let system handle back button if we're on the first route
            return isFirstRouteInCurrentTab;
          },
          child: Scaffold(
              backgroundColor: AppColors.smokeWhite,
              // appBar: AppBar(
              //   elevation: 0,
              //   primary: true,
              //   actions: const [
              //     Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: Icon(
              //         Icons.search,
              //         color: AppColors.textColor,
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: Icon(
              //         Icons.notifications,
              //         color: AppColors.textColor,
              //       ),
              //     ),
              //   ],
              //   leading: const Icon(
              //     Icons.menu_outlined,
              //     color: AppColors.textColor,
              //   ),
              //   title: const Text(
              //     'Creative Movers',
              //     style: TextStyle(color: AppColors.textColor),
              //   ),
              //   backgroundColor: Colors.white,
              // ),
              body: IndexedStack(index: _navIndex, children: <Widget>[
                _buildOffstageNavigator(0),
                _buildOffstageNavigator(1),
                _buildOffstageNavigator(2),
                _buildOffstageNavigator(3),
                _buildOffstageNavigator(4),
              ]),
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
                  duration: const Duration(
                      milliseconds: 200), // tab animation duration
                  gap: 8, // the tab button gap between icon and text
                  color: AppColors.primaryColor, // unselected icon color
                  activeColor:
                      AppColors.primaryColor, // selected icon and text color
                  iconSize: 18,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  backgroundColor: Colors.white,
                  onTabChange: (index) {
                    setState(() {
                      _navBloc.add(SwitchNavEvent(index));
                    });
                  },
                  tabMargin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 0), // tab button icon size
                  tabBackgroundColor: AppColors.primaryColor
                      .withOpacity(0.3), // selected tab background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8), // navigation bar padding
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Feeds',
                      leading: SvgPicture.asset(
                        'assets/svgs/feed.svg',
                        color: AppColors.primaryColor,
                        width: 24,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    GButton(
                      icon: Icons.business,
                      text: 'Biz Page',
                      leading: SvgPicture.asset(
                        'assets/svgs/biz.svg',
                        color: AppColors.primaryColor,
                        width: 24,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    GButton(
                      icon: Icons.group_outlined,
                      text: 'Connects',
                      leading: SvgPicture.asset(
                        'assets/svgs/group.svg',
                        color: AppColors.primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    GButton(
                      icon: Icons.chat_sharp,
                      text: 'Chats',
                      leading: SvgPicture.asset(
                        'assets/svgs/chats.svg',
                        color: AppColors.primaryColor,
                        width: 24,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                      borderRadius: BorderRadius.circular(4),
                      leading: const CircleAvatar(
                        radius: 14,
                        backgroundImage:
                            AssetImage('assets/images/slide_i.png'),
                      ),
                    )
                  ])),
        );
      },
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return screens.elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _navBloc.currentTabIndex != index,
      child: Navigator(
        key: homeNavigatorKeys[index],
        // observers: [MyRouteObserver()],
        onGenerateRoute: (routeSettings) {
          print('Navigating to: ${routeSettings.name} --------------- ');

          PageTransitionType? transitionType;
          var arguments = routeSettings.arguments;
          if (arguments != null) {
            var args = arguments as Map;
            transitionType = args['transition-type'];
            log("Transition:$transitionType");
          }

          if (transitionType != null) {
            return PageTransition(
              child: Builder(builder: (context) {
                if (routeSettings.name == '/') {
                  return routeBuilders[routeSettings.name]!(context);
                } else {
                  return AppRoutes.routes[routeSettings.name]!(context);
                }
              }),
              type: transitionType,
              alignment: Alignment.center,
              childCurrent: const SizedBox.shrink(),
              settings: routeSettings,
              // duration: Duration(milliseconds: 300),
            );
          }

          return CupertinoPageRoute(
              builder: (context) {
                if (routeSettings.name == '/') {
                  return routeBuilders[routeSettings.name]!(context);
                } else {
                  return AppRoutes.routes[routeSettings.name]!(context);
                }
              },
              settings: routeSettings);

          // return PageRouteBuilder(
          //     settings:
          //         routeSettings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
          //     pageBuilder: (_, __, ___) {
          //       if (routeSettings.name == '/') {
          //         return routeBuilders[routeSettings.name]!(context);
          //       } else {
          //         return BuyerRoutes.routes[routeSettings.name]!(context);
          //       }
          //     },
          //     transitionsBuilder: (_, a, __, c) =>
          //         FadeTransition(opacity: a, child: c));
          // Unknown route
          // return MaterialPageRoute(builder: (_) => UnknownPage());

          // return PageRouteBuilder(
          //     pageBuilder: (context, anim1, anim2) {
          //       if (routeSettings.name == '/') {
          //         return routeBuilders[routeSettings.name]!(context);
          //       } else {
          //         return BuyerRoutes.routes[routeSettings.name]!(context);
          //       }
          //     },
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) => index == 2
          //             ? SlideTransition(
          //                 position: Tween<Offset>(
          //                   begin: const Offset(0.0, 1.0),
          //                   end: const Offset(0.0, 0.0),
          //                 ).animate(animation),
          //                 child: child)
          //             : SlideTransition(
          //                 position: Tween<Offset>(
          //                   begin: const Offset(1.0, 0.0),
          //                   end: const Offset(0.0, 0.0),
          //                 ).animate(animation),
          //                 child: child),
          //     settings: routeSettings,
          //     reverseTransitionDuration: Duration(milliseconds: 200),
          //     transitionDuration: Duration(milliseconds: 200));
        },
      ),
    );
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
