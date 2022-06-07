import 'package:camera/camera.dart';
import 'package:creative_movers/app.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/services/puhser_service.dart';
import 'package:creative_movers/services/push_notification_service.dart';
import 'package:creative_movers/services/remote_configs_service.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:creative_movers/di/injector.dart' as di;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  PushNotificationService.showBackgroundNotification(message);
}

  List<CameraDescription> cameras=[];
enum Flavor { dev, prod }

class AppConfig {
  final String appName;
  final Flavor flavor;



  AppConfig._({required this.appName, required this.flavor});

  AppConfig.initializeAndRunInstance(
      {required this.appName, required this.flavor}) {
    AppConfig._(appName: appName, flavor: flavor);
    _init();
  }

  Future<void> _init() async {
    if (flavor == Flavor.dev) {
      Constants.setEnvironmentVariables(Flavor.dev);
    } else {
      Constants.setEnvironmentVariables(Flavor.prod);
    }
    _setup();
  }

  Future<void> _setup() async {
    await Firebase.initializeApp();
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    cameras = await availableCameras();
    await PushNotificationService.initialise();
    var pusherService = await PusherService.getInstance;
    await pusherService.initialize();

    var remoteConfigsService = await RemoteConfigsService.create();
    await remoteConfigsService.retrieveSecrets();
    await di.setup();
    var stripeKey =
        FirebaseRemoteConfig.instance.getString("stripe_publishable_key");
    // Stripe.publishableKey = stripeKey;
    var firstScreen = await AppUtils.getFirstScreen();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));
    runApp(CreativeMoversApp(
      defaultScreen: firstScreen,
      appConfig: this,
    ));
  }
}
