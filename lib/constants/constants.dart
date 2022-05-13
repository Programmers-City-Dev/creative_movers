import 'package:creative_movers/app_config.dart';

class Constants {
  static late Map<String, dynamic> _config;

  Constants._();

  static void setEnvironmentVariables(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        _config = _Config.debugConstants;
        break;
      case Flavor.prod:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get baseUrl {
    return _config[_Config.baseUrl];
  }

  static get getFlavor {
    return _config[_Config.flavor];
  }

  static const userCredentials = 'login_user_credentials';
  static const themeKey = "nitrade_theme_key";
  static const firstTimeUserKey = "first_time_user_key";
  static const agoraAppId = "ab9a79c1cfc7491a92c574140c234529";
}

/// Allows this class to be only visible to this file*/
///
class _Config {
  static const baseUrl = "BASE_URL";
  static const buildGradient = "BUILD_GRADIENT";
  static const sentryDSN = "SENTRY_DSN";
  static const sentryEnv = "SENTRY_ENV";
  static const flavor = "ENV";

  static Map<String, dynamic> debugConstants = {
    baseUrl: "https://creativemovers.app/",
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
