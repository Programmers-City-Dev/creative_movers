import 'dart:convert';
import 'dart:ffi';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/add_feed_response.dart';
import 'package:creative_movers/models/feedsResponse.dart';
import 'package:creative_movers/models/media.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
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
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.add_feed_endpoint, body:FormData.fromMap({
        "type" :type,
        "page_id" :page_id,
        "content" :content,
        "media" : media.map((e) => MultipartFile.fromFileSync(e) ),
      })),
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
