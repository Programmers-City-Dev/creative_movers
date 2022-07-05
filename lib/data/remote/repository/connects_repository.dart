import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/data/remote/model/react_response.dart';
import 'package:creative_movers/data/remote/model/search_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:flutter/foundation.dart';

class ConnectsRepository {
  final HttpHelper httpHelper;

  ConnectsRepository(this.httpHelper);

  Future<State> getConnects() async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
        Endpoints.fetchConnectionsEndpoint,
      ),
      successResponse: (data) {
        return State<FetchConnectionResponse?>.success(
            data != null ? FetchConnectionResponse.fromJson(data) : null);
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


  Future<State> getPendingRequest() async {
    return await SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(
        Endpoints.pendingRequestEndpoint,
      ),
      successResponse: (data) {
        return State<FetchConnectionResponse?>.success(
            data != null ? FetchConnectionResponse.fromJson(data) : null);
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


  Future<State> search({String? role, String? searchValue}) async {

    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
        Endpoints.searchEndpoint,
        body:{
          "role" :role,
          "search_value":searchValue
        }
      ),
      successResponse: (data) {
        return State<SearchResponse?>.success(
            data != null ? SearchResponse.fromJson(data) : null);
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

  Future<State> react({String? connection_id, String? action}) async {

    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
        Endpoints.requestReactEndpoint,
        body:{
          "connection_id" :connection_id,
          "action":action
        }
      ),
      successResponse: (data) {
        return State<ReactResponse?>.success(
            data != null ? ReactResponse.fromJson(data) : null);
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


  Future<State> send_request({String? user_id, }) async {

    return await SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(
          Endpoints.sendRequestEndpoint,
          body:{
            "user_id" :user_id,

          }
      ),
      successResponse: (data) {
        return State<ReactResponse?>.success(
            data != null ? ReactResponse.fromJson(data) : null);
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


  Future<State> follow_request({String? user_id, }) async {

    return await SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(
          Endpoints.followEndpoint,
          body:{
            "user_id" :user_id,

          }
      ),
      successResponse: (data) {
        return State<ReactResponse?>.success(
           null);
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
