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
        backgroundColor: AppColors.white,
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child:  PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context) =>
            <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  padding: const EdgeInsets.all(10),
                  value: 'Mark all as read',
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.check),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Mark all as read'),
                      ],
                    ),
                  )),
              PopupMenuItem<String>(
                  padding: EdgeInsets.all(10),
                  value: 'Filter',
                  child: Container(
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
        )],
        title: const Text(
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
