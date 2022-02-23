import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/feed_response.dart';
import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FeedRepository {
  final HttpHelper httpHelper;

  FeedRepository(this.httpHelper);

  Future<State> adFeed({
    required String type,
     String? page_id,
    required String content,
    required List<String> media,
  }) async {
    var formData = FormData.fromMap({
      "type" :type,
      "page_id" :page_id,
      "content" :content,
    });
    log("IMAGES: $media");
    for (var file in media) {
      formData.files.addAll([
        MapEntry("media", await MultipartFile.fromFile(file)),
      ]);
    }
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint, body:formData),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> getFeeds() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.fetch_feed_endpoint),
      successResponse: (data) {
        return State<FeedsResponse?>.success(
            data != null ? FeedsResponse.fromJson(data) : null);
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

  Future<State> postLike() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> getLike() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> postComments() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> getComments() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> getReplies() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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

  Future<State> replyComment() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
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
