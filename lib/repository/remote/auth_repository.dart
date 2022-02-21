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
import 'package:creative_movers/models/categories.dart';
import 'package:creative_movers/models/feed_response.dart';
import 'package:creative_movers/models/logout_response.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class AuthRepository {
  final HttpHelper httpClient;

  AuthRepository(this.httpClient);

  // Register Request
  Future<State> register(
      {required String email,
      required String password,
      required String username}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.register_endpoint, body: {
        "email": email,
        "password": password,
        "username": username,
      }),
      successResponse: (data) {
        return State<AuthResponse?>.success(
            data != null ? AuthResponse.fromMap(data) : null);
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

  //Login Request
  Future<State> login({required String email, required String password}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.login_endpoint, body: {
        "email": email,
        "password": password,
      }),
      successResponse: (data) {
        return State<AuthResponse?>.success(
            data != null ? AuthResponse.fromMap(data) : null);
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

  //Post Bio Data Request
  Future<State> post_biodata(
      {required String firstname,
      required String lastname,
      required String phoneNumber,
      required String biodata,
         String? image
      }) async {

    var formData = FormData.fromMap({
      "firstname": firstname,
      "lastname": lastname,
      "phone": phoneNumber,
      "biodata": biodata,
      if(image != null)"image":[
      await MultipartFile.fromFile(image, filename:basename(image)),
      ]
    });
    log("IMAGE DATA:${image}");
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.biodata_endpoint, body: formData),
      successResponse: (data) {
        return State<BioDataResponse?>.success(
            data != null ? BioDataResponse.fromJson(data) : null);
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


  //Account Type Request
  Future<State> post_account_type(
      { String? role,
        String? user_id,
        String? name,
        String? stage,
        List<String>? category,
        String? est_capital,
        String? description,
        String? photo,
        String? max_range,
        String? min_range,

      }) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.acount_type_endpoint, body: {
        "role": role,
        "user_id": user_id,
        "name": name,
        "stage": stage,
        "category": jsonEncode(category),
        "est_capital": est_capital,
        "description": description,
        "photo": photo,
        "max_range": max_range,
        "min_range": min_range,
      }),
      successResponse: (data) {
        return State<AccountTypeResponse?>.success(
            data != null ? AccountTypeResponse.fromJson(data) : null);
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
              data: response.data),
        );
      },

    );
  }


  //Add Connections Request
  Future<State> add_connections(
      {required String? user_id,
      required List<Connect> connections,

      }) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.add_connection_endpoint, body: {
        "user_id": user_id,
        "connection": jsonEncode(connections),

      }),
      successResponse: (data) {
        return State<AddConnectionResponse?>.success(
            data != null ? AddConnectionResponse.fromJson(data) : null);
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

  Future<State> logout() async {
    return SimplifyApiConsuming.makeRequest(
          () => httpClient.post(Endpoints.logout_endpoint),
      successResponse: (data) {
        return State<LogoutResponse?>.success(
            data != null ? LogoutResponse.fromJson(data) : null);
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

  Future<State> fetch_categories() async {
    return SimplifyApiConsuming.makeRequest(
          () => httpClient.post(Endpoints.categories_endpoint),
      successResponse: (data) {
        return State<CategoriesResponse?>.success(
            data != null ? CategoriesResponse.fromJson(data) : null);
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
