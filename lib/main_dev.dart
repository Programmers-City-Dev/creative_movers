import 'package:creative_movers/app_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initializeAndRunInstance(
      appName: "Creative Movers Dev", flavor: Flavor.dev);
}
