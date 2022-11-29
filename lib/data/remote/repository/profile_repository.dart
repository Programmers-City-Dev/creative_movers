import 'dart:convert';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/FaqsResponse.dart';
import 'package:creative_movers/data/remote/model/account_type_response.dart';
import 'package:creative_movers/data/remote/model/addconnection_response.dart';
import 'package:creative_movers/data/remote/model/biodata_response.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/update_profile_response.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class ProfileRepository {
  final HttpHelper httpClient;

  ProfileRepository(this.httpClient);

  // Register Request
  Future<State> register(
      {required String email,
      required String password,
      required String username}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.registerEndpoint, body: {
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
      () => httpClient.post(Endpoints.loginEndpoint, body: {
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
      String? image}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.bioDataEndpoint, body: {
        "firstname": firstname,
        "lastname": lastname,
        "phone": phoneNumber,
        "biodata": biodata,
        "image": image,
      }),
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
  Future<State> post_account_type({
    String? role,
    String? user_id,
    String? name,
    String? stage,
    String? category,
    String? est_capital,
    String? description,
    String? photo,
    String? max_range,
    String? min_range,
  }) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.accountTypeEndpoint, body: {
        "role": role,
        "user_id": user_id,
        "name": name,
        "stage": stage,
        "category": category,
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
  Future<State> add_connections({
    required String? user_id,
    required List<Connect> connections,
  }) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.addConnectionEndpoint, body: {
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

  Future<State> fetchUserProfile(int? userId) async {
    String url = userId == null
        ? Endpoints.myProfileEndpoint
        : Endpoints.userProfileEndpoint;
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url,
          body: userId != null
              ? {
                  'user_id': userId,
                }
              : null),
      successResponse: (data) {
        return State<User?>.success(
            data != null ? User.fromMap(data["user"]) : null);
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

  Future<State> updateProfilePhoto(
    String imagePath,
    bool isProfilePhoto,
  ) async {
    String url = isProfilePhoto
        ? Endpoints.profilePhotoEndpoint
        : Endpoints.profileCoverImageEndpoint;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imagePath,
          filename: basename(imagePath)),
    });
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url, body: formData),
      successResponse: (data) {
        return State<String?>.success(data != null ? data["photo_path"] : null);
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

  Future<State> updateProfile(
      {String? imagePath,
      bool? isProfilePhoto,
      String? phone,
      String? email,
      String? gender,
      DateTime? dateOfBirth,
      String? ethnicity,
      String? country,
      String? state,
      String? firstNAme,
      String? lastName}) async {
    String url = Endpoints.updateProfileEndpoint;
    FormData formData = FormData.fromMap({
      // "image": await MultipartFile.fromFile(imagePath!,
      //     filename: basename(imagePath!)) ,
      "phone": phone,
      "email": email,
      "gender": gender,
      "dob": dateOfBirth,
      "ethnicity": ethnicity,
      "country": country,
      "state": state,
      "firstname": firstNAme,
      "lastname": lastName,
    });
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(url, body: formData),
      successResponse: (data) {
        return State<UpdateProfileResponse?>.success(
            UpdateProfileResponse.fromJson(data));
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

  Future<State> getFaqs() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(
        Endpoints.getFaqs,
      ),
      successResponse: (data) {
        return State<FaqsResponse?>.success(
            data != null ? FaqsResponse.fromJson(data) : null);
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
