import 'package:creative_movers/helpers/api_helper.dart';

class Endpoints {
  static const login_endpoint = '${ApiConstants.BASE_URL}api/login';

  static const register_endpoint = '${ApiConstants.BASE_URL}api/register';
  static const biodata_endpoint = '${ApiConstants.BASE_URL}api/user/biodata';
  static const categories_endpoint =
      '${ApiConstants.BASE_URL}api/user/fetch_category';
  static const acount_type_endpoint =
      '${ApiConstants.BASE_URL}api/user/account-type';
  static const add_connection_endpoint =
      '${ApiConstants.BASE_URL}api/user/choose-connection';
  static const logout_endpoint = '${ApiConstants.BASE_URL}api/user/logout';
  static const reset_password_endpoint =
      '${ApiConstants.BASE_URL}api/reset-password';
  static const forgot_password_endpoint =
      '${ApiConstants.BASE_URL}api/forgot-password';
  static const confirm_token_endpoint =
      '${ApiConstants.BASE_URL}api/confirm-token';

  static const add_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/add-feed';
  static const fetch_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/fetch';
  static const delete_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/delete';
  static const comment_endpoint = '${ApiConstants.BASE_URL}api/feed/comment';
  static const like_endpoint = '${ApiConstants.BASE_URL}api/feed/like';
  static const buisness_page_endpoint =
      '${ApiConstants.BASE_URL}api/user/fetch-business-page';
  static const upload_status_endpoint =
      '${ApiConstants.BASE_URL}api/user/upload-status';
  static const get_status_endpoint =
      '${ApiConstants.BASE_URL}api/user/get-status';

  static const fetch_connections_endpoint =
      '${ApiConstants.BASE_URL}api/connections/fetch-all';
  static const search_endpoint = '${ApiConstants.BASE_URL}api/user/search';
  static const pending_request_endpoint =
      '${ApiConstants.BASE_URL}api/connections/fetch-all-pending';
  static const request_react_endpoint =
      '${ApiConstants.BASE_URL}api/connections/react';
  static const String stripe_intent =
      "https://api.stripe.com/v1/payment_intents";

  static const String myProfileEndpoint =
      '${ApiConstants.BASE_URL}api/user/my-profile';
  static const String userProfileEndpoint =
      '${ApiConstants.BASE_URL}api/user/user-profile';

  static const profilePhotoEndpoint =
      '${ApiConstants.BASE_URL}api/user/update-profile-image';
  static const profileCoverImageEndpoint =
      '${ApiConstants.BASE_URL}api/user/update-cover-image';

  // static const pending_request_endpoint = '${ApiConstants.BASE_URL}api/connections/fetch-all-pending';
  // static const request_react_endpoint = '${ApiConstants.BASE_URL}api/connections/react';
  static const send_request_endpoint =
      '${ApiConstants.BASE_URL}api/connections/connect';
  static const follow_endpoint =
      '${ApiConstants.BASE_URL}api/connections/follow';

  // ------------------ PAGE ------------------
  static const create_page_endpoint =
      '${ApiConstants.BASE_URL}api/user/create-page';
  static const edit_page_endpoint =
      '${ApiConstants.BASE_URL}api/user/update-page';
  static const page_suggestion_endpoint =
      '${ApiConstants.BASE_URL}api/user/fetch-sugeested-business-page';
  static const page_feeds_endpoint =
      '${ApiConstants.BASE_URL}api/feed/page/fetch';
  static const follow_page_endpoint =
      '${ApiConstants.BASE_URL}api/user/create-page';
  static const get_page_endpoint =
      '${ApiConstants.BASE_URL}api/user/fetch-business-page-details';

  static String activeSubscription =
      '${ApiConstants.BASE_URL}api/payment/subscription';

  static String paymentHistory = '${ApiConstants.BASE_URL}api/payment/history';
// static const String stripe_intent = "https://api.stripe.com/v1/payment_intents";

// static const add_feed_endpoint = '${ApiConstants.BASE_URL}api/feed/add-feed';
}
