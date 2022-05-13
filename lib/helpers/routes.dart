import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/auth/views/connection_screen.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/payment/views/payment_history_screen.dart';
import 'package:creative_movers/screens/main/payment/views/payment_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/buisness_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/payment/views/active_subscription_screen.dart';
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
    paymentPath: (context) {
      bool isFirstTime = getArgument(context)['isFirstTime'] ?? false;
      return PaymentScreen(
        isFirstTime: isFirstTime,
      );
    },
    subscriptionPath: (context) => const ActiveSubscriptionScreen(),
    paymentHistoryPath: (context) => const PaymentHistoryScreen(),
    accountSettingsPath: (context) => const AccountSettingsScreen(),
    loginPath: (context) => const LoginScreen(),
    inviteContactsPath: (_) => const InviteContactScreen(),
    profilePath: (context) {
      var userId = getArgument(context)['user_id'];

      return ProfileScreen(
        userId: userId,
      );
    },
    viewProfilePath: (context) {
      var userId = getArgument(context)['user_id'];

      return ViewProfileScreen(
        user_id: userId,
      );
    },
    profileEditPath: (_) => const ProfileEditScreen()
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
