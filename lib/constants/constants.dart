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

  static get getFlavor {
    return _config[_Config.flavor];
  }

  // Pusher
  static const pusherApiKey = "7290b6d128bdadf6255e";
  static const pusherCluster = "eu";
  static const pusherSecrete = "a094cb4172d4652cb1b6";
  static const pusherId = "1507673";

  static const userCredentials = 'login_user_credentials';
  static const themeKey = "nitrade_theme_key";
  static const firstTimeUserKey = "first_time_user_key";
  static const agoraAppId = "30d7ce9ee6844b3c9736b3ef38ab4d48";
}

/// Allows this class to be only visible to this file
///
class _Config {
  static const baseUrl = "BASE_URL";
  static const buildGradient = "BUILD_GRADIENT";
  static const sentryDSN = "SENTRY_DSN";
  static const sentryEnv = "SENTRY_ENV";
  static const flavor = "ENV";

  static Map<String, dynamic> stagingConstants = {
    baseUrl: "https://staging.creativemovers.app/",
    buildGradient: "staging",
    sentryDSN: '',
    sentryEnv: 'dev',
    flavor: Flavor.staging
  };
  static Map<String, dynamic> devConstants = {
    baseUrl: "https://dev.creativemovers.app/",
    buildGradient: "dev",
    sentryDSN: '',
    sentryEnv: 'dev',
    flavor: Flavor.dev
  };

  static Map<String, dynamic> prodConstants = {
    baseUrl: "https://creativemovers.app/",
    buildGradient: "production",
    sentryDSN: '',
    sentryEnv: 'production',
    flavor: Flavor.prod
  };
}
