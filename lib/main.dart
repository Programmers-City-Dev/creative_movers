import 'package:creative_movers/di/injector.dart' as di;
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/services/push_notification_service.dart';
import 'package:creative_movers/services/remote_configs_service.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'helpers/app_utils.dart';

final GlobalKey<NavigatorState> mainNavKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  PushNotificationService.showBackgroundNotification(message);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  PushNotificationService.initialise();

  var remoteConfigsService = await RemoteConfigsService.create();
  remoteConfigsService.retrieveSecrets();
  await di.setup();
  Stripe.publishableKey = FirebaseRemoteConfig.instance.getString("stripe_publishable_key");
  var firstScreen = await AppUtils.getFirstScreen(); 
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));
  runApp(MyApp(firstScreen));
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;

  const MyApp(this.firstScreen, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creative Movers',
      navigatorKey: mainNavKey,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('fr', ''),
        Locale('hi', ''),
        Locale('ja', ''),
        Locale('pt', ''),
        Locale('ru', ''),
      ],
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: firstScreen,
    );
  }
}


//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the main page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return const Scaffold(body: OnboardingScreen());
//   }
// }
