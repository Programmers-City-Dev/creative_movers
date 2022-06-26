import 'package:creative_movers/helpers/api_helper.dart';

import 'constants.dart';

class Endpoints {
  static String loginEndpoint = '${Constants.baseUrl}api/login';

  static String registerEndpoint = '${Constants.baseUrl}api/register';
  static String bioDataEndpoint = '${Constants.baseUrl}api/user/biodata';
  static String categoriesEndpoint =
      '${Constants.baseUrl}api/user/fetch_category';
  static String accountTypeEndpoint =
      '${Constants.baseUrl}api/user/account-type';
  static String addConnectionEndpoint =
      '${Constants.baseUrl}api/user/choose-connection';
  static String logoutEndpoint = '${Constants.baseUrl}api/user/logout';
  static String resetPasswordEndpoint =
      '${Constants.baseUrl}api/reset-password';
  static String forgotPasswordEndpoint =
      '${Constants.baseUrl}api/forgot-password';
  static String confirmTokenEndpoint = '${Constants.baseUrl}api/confirm-token';

  static String addFeedEndpoint = '${Constants.baseUrl}api/feed/add-feed';
  static String fetchFeedEndpoint = '${Constants.baseUrl}api/feed/fetch';
  static String deleteFeedEndpoint = '${Constants.baseUrl}api/feed/delete';
  static String commentEndpoint = '${Constants.baseUrl}api/feed/comment';
  static String likeEndpoint = '${Constants.baseUrl}api/feed/like';
  static String businessPageEndpoint =
      '${Constants.baseUrl}api/user/fetch-business-page';
  static String uploadStatusEndpoint =
      '${Constants.baseUrl}api/user/upload-status';
  static String getStatusEndpoint = '${Constants.baseUrl}api/user/get-status';

  static String editFeedEndpoint = '${Constants.baseUrl}api/feed/update-feed';

  static String fetchConnectionsEndpoint =
      '${Constants.baseUrl}api/connections/fetch-all';
  static String searchEndpoint = '${Constants.baseUrl}api/user/search';
  static String pendingRequestEndpoint =
      '${Constants.baseUrl}api/connections/fetch-all-pending';
  static String requestReactEndpoint =
      '${Constants.baseUrl}api/connections/react';
  static String stripeIntent = "https://api.stripe.com/v1/payment_intents";

  static String myProfileEndpoint = '${Constants.baseUrl}api/user/my-profile';
  static String userProfileEndpoint =
      '${Constants.baseUrl}api/user/user-profile';

  static String profilePhotoEndpoint =
      '${Constants.baseUrl}api/user/update-profile-image';
  static String profileCoverImageEndpoint =
      '${Constants.baseUrl}api/user/update-cover-image';
  static String updateProfileEndpoint =
      '${Constants.baseUrl}api/user/update-profile';

  // static const pending_request_endpoint = '${Constants.baseUrl}api/connections/fetch-all-pending';
  // static const request_react_endpoint = '${Constants.baseUrl}api/connections/react';
  static String sendRequestEndpoint =
      '${Constants.baseUrl}api/connections/connect';
  static String followEndpoint = '${Constants.baseUrl}api/connections/follow';

  // ------------------ PAGE ------------------
  static String createPageEndpoint = '${Constants.baseUrl}api/user/create-page';
  static String editPageEndpoint = '${Constants.baseUrl}api/user/update-page';
  static String pageSuggestionEndpoint =
      '${Constants.baseUrl}api/user/fetch-sugeested-business-page';
  static String pageFeedsEndpoint = '${Constants.baseUrl}api/feed/page/fetch';
  static String followPageEndpoint = '${Constants.baseUrl}api/user/create-page';
  static String getPageEndpoint =
      '${Constants.baseUrl}api/user/fetch-business-page-details';

  static String activeSubscription =
      '${Constants.baseUrl}api/payment/subscription';

  static String paymentHistory = '${Constants.baseUrl}api/payment/history';

  static String userNotification =
      '${Constants.baseUrl}api/notifications/fetch';

  static String feedItem = '${Constants.baseUrl}api/feed/fetch_detail';

  static String startFreeTrial = '${Constants.baseUrl}api/payment/free_trial';

// static const String stripe_intent = "https://api.stripe.com/v1/payment_intents";

// static const add_feed_endpoint = '${Constants.baseUrl}api/feed/add-feed';

  // ------------------ CHAT ------------------
  static String fetchConversationMessages =
      '${Constants.baseUrl}api/chats/fetch_conversation_messages';
  static String chatConversations =
      '${Constants.baseUrl}api/chats/fetch_conversations';
  static String sendChatMessage = '${Constants.baseUrl}api/chats/send_message';
  static String notifyLiveVideo =
      '${Constants.baseUrl}api/connections/notify/live-video';
}
