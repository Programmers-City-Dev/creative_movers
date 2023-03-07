// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/main/live/views/live_stream.dart';
import 'package:creative_movers/screens/main/profile/views/view_profile_screen.dart';
import 'package:flutter/material.dart';

class DeeplinkNavigator {
  // this handles navigation to various routes depending on notification type
// before being taken to specific detail pages according to id
  static void handleAllRouting(
      BuildContext context, String? type, int? id, Map<String, dynamic>? data,
      {String? path, bool fromInApp = false}) async {
    if (type == null) return;
    // await RemoteConfigUtil.isConfigReady;
    await Future.delayed(const Duration(milliseconds: 500));
    log('type: $type, id: $id, path: $path, fromInApp: $fromInApp');
    if (fromInApp) {
      injector<DeepLinkCubit>()
          .saveRecentNotification(DeepLinkData(type: type, id: id, path: path));
    } else {
      if (type == 'live_video') {
        _handleRoute(context, LiveDeepLink(type, path, data));
      } else if (type == 'feed') {
        _handleRoute(context, FeedsDeepLink(type, id));
      } else if (type == "profile") {
        _handleRoute(context, ProfileDeepLink(type, id));
      }
      // _handleRoute(context, LiveDeepLink(type, path, data));
      // _handleRoute(
      //     context,
      //     FeedsDeepLink(
      //       type,
      //     ));
    }
  }

  static void _handleRoute(BuildContext context, DeepLinkBase deepLinkBase) {
    deepLinkBase.navigateToPage(context);
  }
}

abstract class DeepLinkBase {
  final String? type;

  DeepLinkBase(
    this.type,
  );

  bool get isNotificationType;

  void navigateToPage(BuildContext context);
}

class LiveDeepLink implements DeepLinkBase {
  @override
  final String? type, path;
  final Map<String, dynamic>? data;

  LiveDeepLink(
    this.type,
    this.path,
    this.data,
  );

  @override
  bool get isNotificationType => type!.contains('live_video');

  @override
  void navigateToPage(BuildContext context) async {
    if (isNotificationType) {
      navigate(
          context, LiveStream(isBroadcaster: false, channel: data?["channel"]),
          useRootNavigator: true);
    }
  }
}

class FeedsDeepLink implements DeepLinkBase {
  @override
  final String type;

  final int? id;

  FeedsDeepLink(this.type, this.id);

  @override
  bool get isNotificationType => type.contains('feed');

  @override
  void navigateToPage(BuildContext context) async {
    navigate(
        context,
        FeedDetailsScreen(
          feedId: id!,
        ));
  }
}

class ProfileDeepLink implements DeepLinkBase {
  @override
  final String type;

  final int? id;

  ProfileDeepLink(this.type, this.id);

  @override
  bool get isNotificationType => type.contains('feed');

  @override
  void navigateToPage(BuildContext context) async {
    if (injector.get<CacheCubit>().cachedUser!.id == id) {
      Navigator.of(context).pushNamed(profilePath);
    } else {
      navigate(
          context,
          ViewProfileScreen(
            userId: id!,
          ));
    }
  }
}

void navigate(
  BuildContext context,
  dynamic destination, {
  Object? arguments,
  bool? useRootNavigator = false,
}) {
  if (destination is String) {
    Navigator.pushNamed(context, destination, arguments: arguments);
  } else {
    Navigator.of(context, rootNavigator: useRootNavigator!).push(
      MaterialPageRoute(
        builder: (context) => (destination as Widget),
      ),
    );
  }
}
