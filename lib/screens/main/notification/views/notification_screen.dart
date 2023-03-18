import 'package:creative_movers/blocs/notification/notification_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/notification/widgets/notification_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationBloc _notificationBloc = injector.get<NotificationBloc>();

  @override
  void initState() {
    super.initState();
    _notificationBloc.add(FetchUserNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      appBar: AppBar(
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        backgroundColor: AppColors.white,
        actions: [
          BlocConsumer<NotificationBloc, NotificationState>(
            bloc: _notificationBloc,
            listener: (context, state) {
              if (state is NotificationRefreshing) {
                AppUtils.showLoaderDialog(context);
              }
              if (state is UserNotificationsRefreshed) {
                Navigator.pop(context);
              }
              if (state is UserNotificationsRefreshError) {
                Navigator.pop(context);
                AppUtils.showCustomToast(state.error, Colors.red, Colors.white);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<int>(
                  onSelected: (val) {
                    if (val == 1) {
                      _notificationBloc
                          .add(const MarkAllNotificationAsReadEvent());
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      padding: const EdgeInsets.all(10),
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.check),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Mark all as read'),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                        padding: const EdgeInsets.all(10),
                        value: 2,
                        child: SizedBox(
                          width: 100,
                          child: Row(
                            children: const [
                              Icon(Icons.sort),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Filter'),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          )
        ],
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.textColor),
        ),
      ),
      body: BlocProvider.value(
        value: _notificationBloc,
        child: BlocConsumer<NotificationBloc, NotificationState>(
          // bloc: _notificationBloc,
          listener: (context, state) {},
          buildWhen: (previous, current) =>
              current is UserNotificationsLoadFailedState ||
              current is NotificationLoading ||
              current is UserNotificationsLoadedState,
          builder: (context, state) {
            var notifications = context.watch<NotificationBloc>().notifications;
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is UserNotificationsLoadFailedState) {
              return AppPromptWidget(
                message: state.error,
                canTryAgain: true,
                title: "Error",
                onTap: () {
                  _notificationBloc.add(FetchUserNotificationsEvent());
                },
              );
            }
            // if (state is UserNotificationsLoadedState) {
            //   return RefreshIndicator(
            //     onRefresh: () async {
            //       _notificationBloc.add(FetchUserNotificationsEvent());
            //     },
            //     child: ListView.builder(
            //       itemCount: state.notifications.length,
            //       itemBuilder: (context, index) => NotificationItem(
            //           notificationData: state.notifications[index]),
            //     ),
            //   );
            // }
            return notifications.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _notificationBloc.add(FetchUserNotificationsEvent());
                    },
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) => NotificationItem(
                          notificationData: notifications[index]),
                    ),
                  )
                : const AppPromptWidget(
                    message: "No notifications",
                    canTryAgain: false,
                  );
          },
        ),
      ),
    );
  }
}
