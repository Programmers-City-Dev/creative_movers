import 'dart:convert';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/data/remote/model/create_page_response.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/get_page_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/suggested_page_response.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class BuisnessRepository {
  final HttpHelper httpHelper;

  BuisnessRepository(this.httpHelper);

  Future<State> getBuisnessPage() {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.businessPageEndpoint),
      successResponse: (data) {
        return State<BuisnessProfile?>.success(
            data != null ? BuisnessProfile.fromJson(data) : null);
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

  Future<State> create_page({ String? website,
  String? contact,
   String? name,
   String? stage,
   List<String>? category,
   String? est_capital,
   String? description,
     String? photo,
  }) async {
    var formData = FormData.fromMap({
      "name": name,
      "stage": stage,
      "category": jsonEncode(category),
      "est_capital": est_capital,
      "description": description,
      if(photo != null)"photo": [
        await MultipartFile.fromFile(photo, filename: basename(photo)),
      ],
      // "photo": photo,
      // "max_range": max_range,
      // "min_range": min_range,
    });
    return SimplifyApiConsuming.makeRequest(
          () async =>
          httpHelper.post(Endpoints.createPageEndpoint, body: formData),
      successResponse: (data) {
        return State<CreatePageResponse?>.success(
            data != null ? CreatePageResponse.fromJson(data) : null);
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


  Future<State> edit_page({ String? website,
    String? contact,
    String? name,
    String? stage,
    String? page_id,
    List<String>? category,
    String? est_capital,
    String? description,
    String? photo,
  }) async {
    var formData = FormData.fromMap({

      "name": name,
      "stage": stage,
      "category": jsonEncode(category),
      "est_capital": est_capital,
      "page_id":page_id,
      "description": description,
      if(photo != null)"photo": [
        await MultipartFile.fromFile(photo, filename: basename(photo)),
      ],
      // "photo": photo,
      // "max_range": max_range,
      // "min_range": min_range,
    });
    return SimplifyApiConsuming.makeRequest(
          () async =>
          httpHelper.post(Endpoints.editPageEndpoint, body: formData),
      successResponse: (data) {
        return State<CreatePageResponse?>.success(
            data != null ? CreatePageResponse.fromJson(data) : null);
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


  Future<State> getPageFeeds(String pageId) {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.pageFeedsEndpoint,body: {
            "page_id":pageId
          }),
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

  Future<State> followPage(String pageId) {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.followPageEndpoint,body: {
            "page_id":pageId
          }),
      successResponse: (data) {
        return State<String?>.success(
            data != null ? data['message'] : null);
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
  Future<State> likePage(String pageId) {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.likePageEndpoint,body: {
        "page_id":pageId
      }),
      successResponse: (data) {
        return State<String?>.success(
            data != null ? data['message'] : null);
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

  Future<State> getPageSuggestions() {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.pageSuggestionEndpoint),
      successResponse: (data) {
        return State<SuggestedPageResponse?>.success(
            data != null ? SuggestedPageResponse.fromJson(data) : null);
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

  Future<State> getPage(String id) {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.getPageEndpoint,body: {"page_id":id}),
      successResponse: (data) {
        return State<GetPageResponse?>.success(
            data != null ? GetPageResponse.fromJson(data) : null);
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
