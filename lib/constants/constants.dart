import 'package:creative_movers/app_config.dart';

class Constants {
  static late Map<String, dynamic> _config;

  Constants._();

  static void setEnvironmentVariables(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        _config = _Config.devConstants;
        break;
      case Flavor.prod:
        _config = _Config.prodConstants;
        break;
      case Flavor.staging:
        _config = _Config.stagingConstants;
        break;
    }
  }

  static String get baseUrl {
    return _config[_Config.baseUrl];
  }

  static String get pusherApiKey {
    return _config[_Config.pusherApiKey];
  }

  static String get pusherSecrete {
    return _config[_Config.pusherSecreteKey];
  }

  static String get pusherId {
    return _config[_Config.pusherID];
  }

  static Flavor get getFlavor {
    return _config[_Config.flavor];
  }

  static const placeHolderImage =
      "https://media.istockphoto.com/id/1264040074/vector/placeholder-rgb-color-icon.jpg?s=612x612&w=0&k=20&c=0ZFUNL28htu-zHRF9evishuNKYQAZVrfK0-TZNjnX3U=";

  static const userCredentials = 'login_user_credentials';
  static const themeKey = "nitrade_theme_key";
  static const firstTimeUserKey = "first_time_user_key";
  static const agoraAppId = "30d7ce9ee6844b3c9736b3ef38ab4d48";
  static const agoraAppCert = "5d8f3dfba7f84903a9dde8f4e6c09230";
}

/// Allows this class to be only visible to this file
///
class _Config {
  static const baseUrl = "BASE_URL";
  static const buildGradient = "BUILD_GRADIENT";
  static const sentryDSN = "SENTRY_DSN";
  static const sentryEnv = "SENTRY_ENV";
  static const pusherApiKey = "PUSHER_API_KEY";
  static const pusherSecreteKey = "PUSHER_SECRETE_KEY";
  static const pusherID = "PUSHER_ID";
  static const flavor = "ENV";

  static Map<String, dynamic> stagingConstants = {
    baseUrl: "https://staging.creativemovers.app/",
    buildGradient: "staging",
    sentryDSN: '',
    sentryEnv: 'dev',
    pusherApiKey: '2989b98e4e4f5137d8f9',
    pusherSecreteKey: 'b287008664ae2bdd50d2',
    pusherID: '1507674',
    flavor: Flavor.staging
  };
  static Map<String, dynamic> devConstants = {
    baseUrl: "https://dev.creativemovers.app/",
    buildGradient: "dev",
    sentryDSN: '',
    sentryEnv: 'dev',
    pusherApiKey: '7290b6d128bdadf6255e',
    pusherSecreteKey: 'a094cb4172d4652cb1b6',
    pusherID: '1507673',
    flavor: Flavor.dev
  };

  static Map<String, dynamic> prodConstants = {
    baseUrl: "https://creativemovers.app/",
    buildGradient: "production",
    sentryDSN: '',
    sentryEnv: 'production',
    pusherApiKey: '855494dc8ebe7e70cc8d',
    pusherSecreteKey: '3bbc3aace1ddbf1d23d2',
    pusherID: '1507675',
    flavor: Flavor.prod
  };
}
