import 'dart:developer';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/payment_history_data.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/subscription_response.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class PaymentRepository {
  final HttpHelper httpClient;

  PaymentRepository(this.httpClient);

  // Register Request
  Future<State> createPaymentIntent(Map body) async {
    log("SECRETE:${FirebaseRemoteConfig.instance.getString('stripe_secret_key')}");
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.stripeIntent,
          body: body,
          options: Options(headers: {
            "Authorization":
                'Bearer ${FirebaseRemoteConfig.instance.getString('stripe_secret_key')}',
            "Content-Type": "application/x-www-form-urlencoded"
          })),
      successResponse: (data) {
        return State<Map<String, dynamic>>.success(data != null ? data : null);
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

  Future<State> fetchActiveSubscription() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.activeSubscription),
      successResponse: (data) {
        return State<SubscriptionResponse?>.success(
            SubscriptionResponse.fromMap(data));
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
        debugPrint('DIO SERVER FROM FETCH SUBSCRIPTION');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> fetchPaymentHistory() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.paymentHistory),
      successResponse: (data) {
        return State<PaymentHistoryResponse?>.success(
            PaymentHistoryResponse.fromMap(data));
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

   Future<State> startFreeTrial() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.startFreeTrial),
      successResponse: (data) {
        return State<String?>.success(
            "Free trial activation successful");
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
