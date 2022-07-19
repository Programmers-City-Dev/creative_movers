import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel =
      const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description:
              'This channel is used for important notifications.', // description
          importance: Importance.high,
          playSound: true);

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PushNotificationService._();

  static Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }

    if (!kIsWeb) {
      // channel = const AndroidNotificationChannel(
      //     'high_importance_channel', // id
      //     'High Importance Notifications', // title
      //     description:
      //         'This channel is used for important notifications.', // description
      //     importance: Importance.high,
      //     playSound: true);

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    FirebaseMessaging.onBackgroundMessage(_showBackgroundNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // log('A new onMessageOpenedApp event was published!: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // log('A new onMessageOpenedApp event was published!: ${message.notification!.body}');
      log("Live Video: ${message.data}", name: "Notification");

      // Map<String, dynamic> data = message.data;
      // String type = data['type'];
      // if (type == "live_video") {
      //   log("Live Video: ${type}", name: "Notification");
      // }

      DeepLinkData? payloadNotif = _decodeNotificationData(message);
      if (payloadNotif != null) {
        log("Live Video: ${message.data["type"]}", name: "Notification");
        injector<DeepLinkCubit>().saveRecentNotification(payloadNotif);
        // DeeplinkAnalyticEvents()
        //     .appOpenedFromPushNotification(type: payloadNotification.type??'');
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // log('A new getInitialMessage event was published!: ${message.data}');
        DeepLinkData? payloadNotification = _decodeNotificationData(message);
        // FlutterToast.showToast(msg: '$payloadNotification');
        if (payloadNotification != null) {
          injector<DeepLinkCubit>().saveRecentNotification(payloadNotification);
          // DeeplinkAnalyticEvents()
          //     .appOpenedFromPushNotification(type: payloadNotification.type??'');
        }
      }
    });
  }

  static Future<String?> getDeviceToken() async {
    return await _fcm.getToken();
  }

  static DeepLinkData? _decodeNotificationData(RemoteMessage notification) {
    try {
      if (notification.data.isNotEmpty) {
        final Map<String, dynamic> map = notification.data;
        return DeepLinkData.fromMap(map);
      } else {
        // final Map<String, dynamic> map =
        // jsonDecode(notification.rawPayload!['custom'].toString());
        // return DeepLinkData.fromMap(map['a']);
      }
    } catch (e) {
      debugPrint('not error ' + e.toString());
    }

    return null;
  }
}

Future<void> _showBackgroundNotification(RemoteMessage message) async {
  log('A new BackgroundNotification event was published!: ${message.data}');
// RemoteNotification? notification = message.notification;
// AndroidNotification? android = message.notification?.android;
// if (notification != null && android != null && !kIsWeb) {
//   flutterLocalNotificationsPlugin.show(
//     notification.hashCode,
//     notification.title,
//     notification.body,
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         // TODO add a proper drawable resource to android, for now using
//         //      one that already exists in example app.
//         icon: 'launch_background',
//       ),
//     ),
//   );
// }

//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   debugPrint('Handling a background message ${message.messageId}');
//   PushNotificationService.showBackgroundNotification(message);
}
