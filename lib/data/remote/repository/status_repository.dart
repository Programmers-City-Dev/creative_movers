import 'dart:developer';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/upload_status_response.dart';
import 'package:creative_movers/data/remote/model/view_status_response.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class StatusRepository {
  final HttpHelper httpHelper;

  StatusRepository(this.httpHelper);
  Future<State> uploadStatus({
    required String? text,
    String? bg_color,
    String? font_name,
    List<String>? media,
  }) async {
    var formData = FormData.fromMap({
      "text": text,
      "bg_color": bg_color,
      "font_name": font_name,
    });
    log("IMAGES: $media");
    if (media != null) {
      for (var file in media) {
        formData.files.addAll([
          MapEntry("file", await MultipartFile.fromFile(file)),
        ]);
      }
    }

    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.uploadStatusEndpoint, body: formData),
      successResponse: (data) {
        return State<UploadStatusResponse?>.success(
            data != null ? UploadStatusResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: response.data['message']),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER:$response');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getStatus() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.get(Endpoints.getStatusEndpoint),
      successResponse: (data) {
        return State<ViewStatusResponse?>.success(
            data != null ? ViewStatusResponse.fromJson(data) : null);
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
        debugPrint('DIO SERVER: ${response.data['message']}');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: "Unable to fetch status updates",
              data: null),
        );
      },
    );
  }
}
