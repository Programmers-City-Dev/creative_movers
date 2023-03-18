import 'dart:developer';

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

  Future<State> markNoticationAsRead(String notificationId) {
    String url = Endpoints.updateNotifcation;
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url, body: {
        'notification_id': notificationId,
      }),
      successResponse: (data) {
        return State<bool?>.success(data['success'] ?? false);
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

  Future<State> markAllNoticationAsRead() {
    String url = Endpoints.updateAllNotifcation;
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url),
      successResponse: (data) {
        return State<bool?>.success(data['status'] ?? false);
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
        log('DIO SERVER: $response');
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
