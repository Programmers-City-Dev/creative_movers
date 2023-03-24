import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/blocs/nav/nav_bloc.dart';
import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/services/payment_services.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/routes.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/profile/views/account_settings_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_edit_screen.dart';
import 'package:creative_movers/screens/main/widgets/deeplink/deep_link_listener.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/welcome_dialog.dart';
import 'package:creative_movers/services/dynamic_links_service.dart';
import 'package:creative_movers/services/push_notification_service.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

List<GlobalKey<NavigatorState>> homeNavigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.showWelcomeDialog = false})
      : super(key: key);

  final bool? showWelcomeDialog;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final screens = [
    const FeedScreen(),
    const MyPageTab(),
    const ContactScreen(),
    const ChatScreen(),
    const AccountSettingsScreen()
  ];

  int _navIndex = 0;
  final NavBloc _navBloc = injector.get<NavBloc>();
  bool initConfigured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConfigsAndUpdates();
    _navBloc.add(OpenHomeTabEvent());
    injector.get<ProfileBloc>().add(GetUsernameEvent());
    injector.get<ProfileBloc>().add(const FetchUserProfileEvent());
    injector.get<PaymentBloc>().add(const GetSubscriptionInfoEvent());

    Future.delayed(const Duration(seconds: 4))
        .then((value) => _showDialogIfNecessary());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavBloc, NavState>(
      bloc: _navBloc,
      listener: (context, state) {
        if (state is OpenHomeTabState) {
          _navIndex = 0;
        }
        if (state is OpenBizTabState) {
          _navIndex = 1;
        }
        if (state is OpenConnectsTabState) {
          _navIndex = 2;
        }
        if (state is OpenChatsTabState) {
          _navIndex = 3;
        }
        if (state is OpenProfileTabState) {
          _navIndex = 4;
        }
        if (state is LogoutAppState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
      builder: (context, state) {
        return WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await homeNavigatorKeys[_navIndex].currentState!.maybePop();
              debugPrint('isFirstRouteInCurrentTab: $isFirstRouteInCurrentTab');
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            child: Scaffold(
                backgroundColor: AppColors.smokeWhite,
                body: IndexedStack(index: _navIndex, children: <Widget>[
                  _buildOffstageNavigator(0),
                  _buildOffstageNavigator(1),
                  _buildOffstageNavigator(2),
                  _buildOffstageNavigator(3),
                  _buildOffstageNavigator(4),
                ]),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.grey,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  currentIndex: _navIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        _navBloc.add(OpenHomeTabEvent());
                        break;
                      case 1:
                        _navBloc.add(OpenBizTabEvent());
                        break;
                      case 2:
                        _navBloc.add(OpenConnectsTabEvent());
                        break;
                      case 3:
                        _navBloc.add(OpenChatsTabEvent());
                        break;
                      case 4:
                        _navBloc.add(OpenProfileTabEvent());
                        break;
                    }
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.rss_feed_outlined),
                      label: 'FEED',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.wallet_travel),
                      label: 'Biz Page',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_outlined),
                      label: 'Connects',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.messenger_outlined),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                        icon: BlocProvider.value(
                          value: injector.get<CacheCubit>(),
                          child: BlocBuilder<CacheCubit, CacheState>(
                            builder: (context, state) {
                              var cachedUser =
                                  context.watch<CacheCubit>().cachedUser;
                              return cachedUser == null
                                  ? const CircleAvatar(
                                      radius: 14,
                                      backgroundImage: AssetImage(
                                          'assets/images/slide_i.png'),
                                    )
                                  : CircleImage(
                                      url: cachedUser.profilePhotoPath,
                                      withBaseUrl: false,
                                    );
                            },
                          ),
                        ),
                        label: 'Profile'),
                  ],
                )));
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
      offstage: _navIndex != index,
      child: DeepLinkListener(
        navigatorKey: homeNavigatorKeys[index],
        actWhen: deepLinkActWhenList[index],
        child: Navigator(
          key: homeNavigatorKeys[index],
          // observers: [MyRouteObserver()],
          onGenerateRoute: (routeSettings) {
            debugPrint('Navigating to: ${routeSettings.name} --------------- ');
            debugPrint(
                'Navigating to: ${routeSettings.arguments} --------------- ');

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
          },
        ),
      ),
    );
  }

  void initConfigsAndUpdates() async {
    if (!initConfigured) {
      // await RemoteConfigUtil.isConfigReady;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (!DynamicLinksService.isInitialized) {
          DynamicLinksService.init();
          DynamicLinksService.isInitialized = true;
        }
        PushNotificationService.initialise();
        // setState(() {
        initConfigured = true;
        // });
      });
    }
  }

  _showDialogIfNecessary() {
    if (widget.showWelcomeDialog!) {
      showDialog(
          context: homeNavigatorKeys[0].currentState!.context,
          builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: WelcomeDialog(
                    onNavigate: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ProfileEditScreen()));
                      // _navBloc.add(SwitchNavEvent(4));
                      // Navigator.of(homeNavigatorKeys[4].currentState!.context)
                      //     .pushNamed(profileEditPath);
                    },
                  ))));
    }
  }

  List<bool Function()> deepLinkActWhenList = [
    () => injector<NavBloc>().state is OpenHomeTabState,
    () => injector<NavBloc>().state is OpenBizTabState,
    () => injector<NavBloc>().state is OpenConnectsTabState,
    () => injector<NavBloc>().state is OpenChatsTabState,
    () => injector<NavBloc>().state is OpenProfileTabState,
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log("APP STATE: $state");

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      injector
          .get<ChatBloc>()
          .add(const UpdateUserStatusEvent(status: "offline"));
    } else {
      injector
          .get<ChatBloc>()
          .add(const UpdateUserStatusEvent(status: "online"));
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
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
//                     _screenIndex == 1 ? AppColors.primaryColor : AppColors.white,
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
//                         : AppColors.white,
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
