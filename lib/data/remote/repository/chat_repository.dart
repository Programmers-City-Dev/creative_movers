import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_movers/data/remote/model/chat_message.dart';
import 'package:creative_movers/data/remote/model/live_chat_message.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  final HttpHelper httpClient;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRepository(this.httpClient);

  //Retrieve Agora token for live broadcasting Request
  Future<State> generateToken(
      {String? uid, required String channelName}) async {
    return SimplifyApiConsuming.makeRequest(
      () =>
          httpClient.post("https://agora-token-gen.herokuapp.com/token", body: {
        "appId": "d914468e34e446acb3892494cf004eab",
        "appCertificate": "49b03f4b574b4f1bb403b76d138bedf4",
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

  Future<State> sendChannelMessage(
      String channelName, LiveChatMessage message) async {
    try {
      var documentReference = _firestore
          .collection("messaging")
          .doc("live")
          .collection(channelName)
          .doc();
      await _firestore
          .collection("messaging")
          .doc("live")
          .collection(channelName)
          .add(message.copyWith(id: documentReference.id).toMap());

      return State.success(documentReference);
    } on FirebaseException catch (fe) {
      return State.error(
          ServerErrorModel(statusCode: 401, errorMessage: fe.message!));
    }
  }

  Stream<List<LiveChatMessage>> channelMessages(String channelName) {
    return _firestore
        .collection("messaging")
        .doc("live")
        .collection(channelName)
        .orderBy(
          "timestamp",
        )
        .snapshots()
        .map((snapshots) => snapshots.docs.map((e) {
              return LiveChatMessage.fromMap(e.data());
            }).toList());
  }
}
