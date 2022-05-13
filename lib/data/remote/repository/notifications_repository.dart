import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/notifications_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:flutter/foundation.dart';

class NotificationsRepository {
  final HttpHelper httpClient;

  NotificationsRepository(this.httpClient);

  Future<State> fetchUsrNotifications() async {
    String url = Endpoints.userNotification;
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url),
      successResponse: (data) {
        return State<List<Notification>?>.success(data != null
            ? NotificationsResponse.fromMap(data).notifications
            : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }
}
