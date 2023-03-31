import 'package:flutter/material.dart';

class PageNotifications extends StatefulWidget {
  const PageNotifications({Key? key}) : super(key: key);

  @override
  _PageNotificationsState createState() => _PageNotificationsState();
}

class _PageNotificationsState extends State<PageNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: 4,
                // itemBuilder: (context, index) => NotificationItem(),
                itemBuilder: (context, index) => Container(),
              ))
        ],
      ),
    );
  }
}
