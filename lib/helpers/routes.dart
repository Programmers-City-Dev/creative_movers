import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/auth/views/connection_screen.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/buisness_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_edit_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_screen.dart';
import 'package:creative_movers/screens/main/profile/views/account_settings_screen.dart';
import 'package:creative_movers/screens/main/profile/views/view_profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = <String, WidgetBuilder>{
    feedsPath: (_) => const FeedScreen(),
    bizPath: (context) => const MyPageTab(),
    connectsPath: (context) {
      var connections = getArgument(context)['connections'];
      var role = getArgument(context)['role'];
      return ConnectionScreen(
        connections: connections,
        role: role,
      );
    },
    chatsPath: (context) => const ChatScreen(),
    accountSettingsPath: (context) => const AccountSettingsScreen(),
    loginPath: (context) => const LoginScreen(),
    inviteContactsPath: (_) => const InviteContactScreen(),
    profilePath: (context)  {
      var user_id = getArgument(context)['user_id'];

      return  ProfileScreen(user_id: user_id,);},
    viewProfilePath: (context)  {
      var user_id = getArgument(context)['user_id'];

      return  ViewProfileScreen(user_id: user_id,);},
    profileEditPath: (_) => ProfileEditScreen()
  };
}

Map<String, dynamic> getArgument(BuildContext context) {
  var data = ModalRoute.of(context)!.settings.arguments;
  if (data != null) {
    return data as Map<String, dynamic>;
  } else {
    return {};
  }
}
