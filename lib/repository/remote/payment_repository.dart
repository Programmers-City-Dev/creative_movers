import 'dart:convert';
import 'dart:developer';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/account_type_response.dart';
import 'package:creative_movers/models/account_type_response.dart';
import 'package:creative_movers/models/account_type_response.dart';
import 'package:creative_movers/models/addconnection_response.dart';
import 'package:creative_movers/models/biodata_response.dart';
import 'package:creative_movers/models/logout_response.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class PaymentRepository {
  final HttpHelper httpClient;

  PaymentRepository(this.httpClient);

  // Register Request
  Future<State> createPaymentIntent(Map body) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.stripe_intent,
          body: body,
      options: Options(
          headers: {
            "Authorization": 'Bearer ${ApiConstants.STRIPE_SECRETE_KEY}',
            "Content-Type" : "application/x-www-form-urlencoded"
          }
      )),
      successResponse: (data) {
        return State<Map<String, dynamic>>.success(
            data != null ? data : null);
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
