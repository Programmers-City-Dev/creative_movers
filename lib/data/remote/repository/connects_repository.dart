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
        Endpoints.fetch_connections_endpoint,
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
        Endpoints.pending_request_endpoint,
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
        Endpoints.search_endpoint,
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
        Endpoints.request_react_endpoint,
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
}
