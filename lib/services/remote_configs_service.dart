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

  Future<Map> retrieveSecrets() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    final Map<String, String> secrets = {
      'b2bin_password': remoteConfig.getString('b2bin_password'),
      'b2bin_login': remoteConfig.getString('b2bin_login'),
      'one_signal_app_id': remoteConfig.getString('one_signal_app_id'),
    };

    return secrets;
  }
}
