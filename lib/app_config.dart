import 'package:camera/camera.dart';
import 'package:creative_movers/app.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/di/injector.dart' as di;
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/services/file_downloader_service.dart';
import 'package:creative_movers/services/puhser_service.dart';
import 'package:creative_movers/services/push_notification_service.dart';
import 'package:creative_movers/services/remote_configs_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

List<CameraDescription> cameras = [];

enum Flavor { dev, staging, prod }

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
    } else if (flavor == Flavor.staging) {
      Constants.setEnvironmentVariables(Flavor.staging);
    } else {
      Constants.setEnvironmentVariables(Flavor.prod);
    }
    _setup();
  }

  Future<void> _setup() async {
    await Firebase.initializeApp();
    cameras = await availableCameras();
    await PushNotificationService.initialise();
    await FileDownloaderService.init();
    var pusherService = await PusherService.getInstance;
    await pusherService.initialize();

    var remoteConfigsService = await RemoteConfigsService.create();
    await remoteConfigsService.retrieveSecrets();
    await di.setup();
    var stripeKey =
        FirebaseRemoteConfig.instance.getString("stripe_publishable_key");
    Stripe.publishableKey = stripeKey;
    var firstScreen = await AppUtils.getFirstScreen();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    runApp(CreativeMoversApp(
      defaultScreen: firstScreen,
      appConfig: this,
    ));
  }
}
