import 'package:creative_movers/screens/main/notification/widgets/notification_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textColor),
        backgroundColor: Colors.white,
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        )],
        title: Text(
          'Notifications',
          style: TextStyle(color: AppColors.textColor),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: 4,
              itemBuilder: (context, index) => NotificationItem(),
            ))
          ],
        ),
      ),
    );
  }
}
