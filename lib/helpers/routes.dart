import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/auth/views/connection_screen.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/buisness_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = <String, WidgetBuilder>{
    feedsPath: (_) => const FeedScreen(),
    bizPath: (context) => const BuisnessScreen(),
    connectsPath: (context) {
      var connections = getArgument(context)['connections'];
      var role = getArgument(context)['role'];
      return ConnectionScreen(
        connections: connections,
        role: role,
      );
    },
    chatsPath: (context) => const ChatScreen(),
    profilePath: (context) => const ProfileScreen(),
    loginPath: (context) => const LoginScreen(),
    inviteContactsPath: (_) => const InviteContactScreen(),
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
