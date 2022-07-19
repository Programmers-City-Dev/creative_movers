import 'package:creative_movers/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> mainNavKey = GlobalKey<NavigatorState>();

class CreativeMoversApp extends StatelessWidget {
  final AppConfig appConfig;
  final Widget defaultScreen;

  const CreativeMoversApp(
      {Key? key, required this.appConfig, required this.defaultScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appConfig.appName,
      debugShowCheckedModeBanner: appConfig.flavor != Flavor.prod,
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
          fontFamily: "Poppins",
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          )),
      home: defaultScreen,
    );
  }
}
