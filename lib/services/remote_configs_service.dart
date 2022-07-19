import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigsService {
  RemoteConfigsService._();

  /// [RemoteConfigsService] factory constructor.
  static Future<RemoteConfigsService> create() async {
    final RemoteConfigsService remoteConfigsService = RemoteConfigsService._();
    await remoteConfigsService._init();
    return remoteConfigsService;
  }

  _init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  Future<void> retrieveSecrets() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.fetchAndActivate();
      // final Map<String, String> secrets = {
      //   'stripe_publishable_key':
      //       remoteConfig.getString('stripe_publishable_key'),
      //   'stripe_secret_key': remoteConfig.getString('stripe_secret_key'),
      //   'one_signal_key': remoteConfig.getString('one_signal_key'),
      // };

      // return secrets;
    } catch (e) {
      log("Firebase remote exception: $e");
    }
  }
}
