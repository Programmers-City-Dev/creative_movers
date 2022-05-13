import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  final HttpHelper httpClient;

  ChatRepository(this.httpClient);

  //Retrieve Agora token for live broadcasting Request
  Future<State> generateToken(
      {String? uid, required String channelName}) async {
    return SimplifyApiConsuming.makeRequest(
      () =>
          httpClient.post("https://agora-token-gen.herokuapp.com/token", body: {
        "appId": "ab9a79c1cfc7491a92c574140c234529",
        "appCertificate": "0ff36beda29f43c79c47a38530fdd107",
        "channelName": channelName,
        "uid": uid ?? "22048695876",
        "role": "subscriber"
      }),
      successResponse: (data) {
        return State<String?>.success(data != null ? data["token"] : null);
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
              errorMessage: "Oops! something went wrong",
              data: null),
        );
      },
    );
  }
}
