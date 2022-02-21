import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/get_connects_response.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
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

  Future<State> search() async {
    return await SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(
        Endpoints.search_endpoint,
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
}
