import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/routes.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:creative_movers/screens/main/feed/views/feed_detail_screen.dart';
import 'package:creative_movers/screens/main/live/views/live_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeeplinkNavigator {
  // this handles navigation to various routes depending on notification type
// before being taken to specific detail pages according to id
  static void handleAllRouting(
      BuildContext context, String? type, int? id, Map<String, dynamic>? data,
      {String? path, bool fromInApp = false}) async {
    if (type == null) return;
    // await RemoteConfigUtil.isConfigReady;
    await Future.delayed(const Duration(milliseconds: 500));
    if (fromInApp) {
      injector<DeepLinkCubit>()
          .saveRecentNotification(DeepLinkData(type: type, id: id, path: path));
    } else {
      _handleRoute(context, LiveDeepLink(type, path, data));
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
  final String type;

  FeedsDeepLink(this.type);

  @override
  bool get isNotificationType => type.contains('mood_diary');

  @override
  void navigateToPage(BuildContext context) async {
    if (isNotificationType) {
      navigate(
          context,
          const FeedDetailsScreen(
            feedId: 1,
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
