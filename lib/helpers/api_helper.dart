import 'dart:io';

import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:dio/dio.dart';

class ApiConstants {
  ApiConstants._();

  static const BASE_URL = "https://creativemovers.app/";
}

class SimplifyApiConsuming {
  SimplifyApiConsuming._();

  ///A more simplified method for making endpoint request call
  ///@param [requestFunction] a function passed, this function is the api call to execute
  ///@param [isStatusCode] a bool flag to indicate whether to equate response success with statusCode or with success string in response data
  ///@Param [statusCodeSuccess] an [int] status code to validate success of the request, if [isStatusCode] == true
  ///@Param [successResponse] a [Function] to execute if request is successful, must have a return statement
  /// Returns [Future<ResponseModel>]
  ///
  ///
  static Future<State> makeRequest(
      Future<Response<dynamic>> Function() requestFunction,
      {bool isStatusCode = true,
      int statusCodeSuccess = 200,
      required State Function(dynamic data) successResponse,
      State Function(Response data)? errorResponse,
      State Function(Response data)? dioErrorResponse,
      Function(int)? statusCode}) async {
    try {
      return await _makeRequest(requestFunction, isStatusCode,
          statusCodeSuccess, successResponse, errorResponse!);
    } on SocketException {
      return State<ServerErrorModel>.error(
        ServerErrorModel(
            statusCode: 400,
            errorMessage: "Something went wrong "
                "please check your internet connection and try again",
            data: null),
      );
    } on DioError catch (e) {
      print("dio error request is:  ${e.response?.requestOptions.queryParameters}");
      if (dioErrorResponse != null) {
        return dioErrorResponse(e.response!);
      } else {
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: e.response!.statusCode ?? 400,
              errorMessage: "Something went wrong please try again",
              data: null),
        );
      }
    } catch (error, stack) {
      print('error --------------------- ${error.toString()}');
      print('stack --------------------- ${stack.toString()}');

      return State<ServerErrorModel>.error(
        ServerErrorModel(
            statusCode: 400, errorMessage: error.toString(), data: null),
      );
    }
  }




  static Future<State> _makeRequest(
      Future<Response> requestFunction(),
      bool isStatusCode,
      int statusCodeSuccess,
      State successResponse(dynamic data),
      State errorResponse(Response data)) async {
    var response = await requestFunction();


    if (isStatusCode) {
      return _handleResponseBasedOnStatusCode(
          response, statusCodeSuccess, successResponse, errorResponse);
    } else {
      return _handleResponseBasedOnDataReturned(
          response, successResponse, errorResponse);
    }
  }





  static State _handleResponseBasedOnStatusCode(
      Response response,
      int statusCodeSuccess,
      State successResponse(dynamic data),
      State errorResponse(Response data)) {
    if (response.statusCode == statusCodeSuccess) {
      return successResponse(response.data);
    } else {
      return errorResponse(response);
    }
  }

  static State _handleResponseBasedOnDataReturned(Response response,
      State successResponse(dynamic data), State errorResponse(Response data)) {
    if (response.data['status'] == 'success') {
      return successResponse(response.data);
    }
    return errorResponse(response);
  }

}
