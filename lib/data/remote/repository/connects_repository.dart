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

  Future<State> getConnects(String? userId) async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
       userId == null ?  Endpoints.fetchConnectionsEndpoint :Endpoints.fetchUserConnectionsEndpoint,
        body: {'user_id':userId}
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
      () => httpHelper.post(Endpoints.searchEndpoint,
          body: {"role": role, "search_value": searchValue}),
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

  Future<State> searchConnects({String? user_id, String? searchValue}) async {
    return await SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.searchConnectsEndpoint,
          body: {"user_id": user_id, "search_value": searchValue}),
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

  Future<State> react({String? connectionId, String? action}) async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.requestReactEndpoint,
          body: {"connection_id": connectionId, "action": action}),
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

  Future<State> sendRequest({
    String? userId,
  }) async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.sendRequestEndpoint, body: {
        "user_id": userId,
      }),
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

  Future<State> followRequest({
    String? userId,
  }) async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.followEndpoint, body: {
        "user_id": userId,
      }),
      successResponse: (data) {
        return State<ReactResponse?>.success(null);
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

  Future<State> getSuggestedConnects() async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
        Endpoints.suggestedConnects,
      ),
      successResponse: (data) {
        return State<List<SearchResult>?>.success(data != null
            ? List<SearchResult>.from(
                data["suggested"].map((e) => SearchResult.fromJson(e)))
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
