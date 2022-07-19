import 'dart:async';
import 'dart:developer';

import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:creative_movers/screens/utils/deeplink/deep_link_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_prompt_item.dart';

class DeepLinkListener extends StatelessWidget {
  final Widget child;
  final bool Function() actWhen;
  final GlobalKey<NavigatorState> navigatorKey;

  const DeepLinkListener(
      {Key? key,
      required this.child,
      required this.actWhen,
      required this.navigatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: injector<DeepLinkCubit>(),
      child: BlocConsumer<DeepLinkCubit, DeepLinkData?>(
          listener: (context, state) {
            log("ACT WHEN: $actWhen", name: "Act When");
            if (actWhen()) {
              DeeplinkNavigator.handleAllRouting(
                navigatorKey.currentContext ?? context,
                state?.type,
                state?.id,
                state?.data,
                path: state?.path,
              );
            }
          },
          builder: (_, state) => _child()),
    );
  }

  Widget _child() => Stack(
        children: [
          child,
          Positioned.fill(
              child: SafeArea(
            child: NotificationPromptList(
              actWhen: actWhen,
              navigatorKey: navigatorKey,
            ),
          ))
        ],
      );
}

class NotificationPromptList extends StatefulWidget {
  final bool Function() actWhen;
  final GlobalKey<NavigatorState>? navigatorKey;

  const NotificationPromptList(
      {Key? key, required this.actWhen, this.navigatorKey})
      : super(key: key);

  @override
  State<NotificationPromptList> createState() => _NotificationPromptListState();
}

class _NotificationPromptListState extends State<NotificationPromptList> {
  final DeepLinkCubit deepLinkCubit = injector<DeepLinkCubit>();
  final StreamController<DeepLinkData> _notificationStreamController =
      StreamController.broadcast();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      deepLinkCubit.inAppNotifier.addListener(() {
        if (widget.actWhen()) {
          final value = deepLinkCubit.inAppNotifier.value;
          if (value != null) {
            _notificationStreamController.add(value);
            deepLinkCubit.inAppNotifier.value = null;
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _notificationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ListView(
        shrinkWrap: true,
        children: [
          _recursiveNotificationDisplay(),
        ],
      ),
    );
  }

  Widget _recursiveNotificationDisplay() {
    return FutureBuilder(
        future: _notificationStreamController.stream.first,
        builder: (_, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _recursiveNotificationDisplay(),
              NotificationPromptItem(
                notification: snapshot.data as DeepLinkData,
                onTap: () {
                  final notification = snapshot.data as DeepLinkData;
                  DeeplinkNavigator.handleAllRouting(
                      widget.navigatorKey!.currentContext ?? context,
                      notification.type,
                      notification.id,
                      notification.data,
                      path: notification.message,
                      fromInApp: true);
                },
                onDone: () {
                  // final notification = snapshot.data as DeepLinkData;
                },
              ),
            ],
          );
        });
  }
}
