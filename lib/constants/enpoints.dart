import 'package:creative_movers/helpers/api_helper.dart';

class Endpoints {
  static const login_endpoint = '${ApiConstants.BASE_URL}api/login';

  static const register_endpoint = '${ApiConstants.BASE_URL}api/register';
  static const biodata_endpoint = '${ApiConstants.BASE_URL}api/user/biodata';
  static const categories_endpoint = '${ApiConstants.BASE_URL}api/user/fetch_category';
  static const acount_type_endpoint = '${ApiConstants.BASE_URL}api/user/account-type';
  static const add_connection_endpoint = '${ApiConstants.BASE_URL}api/user/choose-connection';
  static const logout_endpoint = '${ApiConstants.BASE_URL}api/user/logout';
  static const add_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/add-feed';
  static const fetch_connections_endpoint = '${ApiConstants.BASE_URL}api/connections/fetch-all';
  static const search_endpoint = '${ApiConstants.BASE_URL}api/connections/search';
  static const String stripe_intent = "https://api.stripe.com/v1/payment_intents";

  // static const add_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/add-feed';
}
