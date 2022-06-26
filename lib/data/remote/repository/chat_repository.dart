import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/chat/chat_message_request.dart';
import 'package:creative_movers/data/remote/model/chat/chat_message_response.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/data/remote/model/chat/conversation_messages_response.dart';
import 'package:creative_movers/data/remote/model/chat/conversations_response.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:flutter/foundation.dart';

import '../model/chat/live_chat_message.dart';

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

  //Retrieve all chat conversations to be displayed on the chat tab
  Future<State> fetchChatConversations() async {
    return SimplifyApiConsuming.makeRequest(
          () => httpClient.post(Endpoints.chatConversations),
      successResponse: (data) {
        return State<List<Conversation>?>.success(data != null
            ? ConversationsResponse.fromMap(data).conversations
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
        debugPrint('DIO SERVER FROM FETCH');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: "Oops! something went wrong",
              data: null),
        );
      },
    );
  }

  // Send chat message on the main chat screen
  Future<State> sendChatMessage(
      {required List<File> files, required ChatMessageRequest message}) async {
    log("CONVO ID: ${message.toMap()}");
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.sendChatMessage, body: message.toMap()),
      successResponse: (data) {
        return State<ChatMessageResponse?>.success(
            data != null ? ChatMessageResponse.fromMap(data) : null);
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
        debugPrint('DIO SERVER FROM SEND MESSAGE: ${response.data}');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: "Oops! something went wrong",
              data: null),
        );
      },
    );
  }

  // Fetch messages for a particular conversation
  Future<State> fetchChatConversationMessages(int conversationId) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.fetchConversationMessages,
          body: {"conversation_id": conversationId}),
      successResponse: (data) {
        return State<ConversationMessagesResponse?>.success(
            data != null ? ConversationMessagesResponse.fromMap(data) : null);
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
              errorMessage:
                  "Oops! unable to fetch conversation messages, try again",
              data: null),
        );
      },
    );
  }

  // Fetch online users
  Future<State> get fetchOnlineUsers async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.onlineUsers),
      successResponse: (data) {
        return State<List<ConversationUser>?>.success(data != null
            ? List<ConversationUser>.from(
                data["online_users"].map((x) => ConversationUser.fromMap(x)))
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
              errorMessage: "Oops! unable to fetch online users, try again",
              data: null),
        );
      },
    );
  }

  // Send chat message on the main chat screen
  Future<State> broadcastLiveVideo(
      {String? notifyFor = "all", required String message}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.notifyLiveVideo,
          body: {"notify_for": notifyFor, "notify_message": message}),
      successResponse: (data) {
        return State<String?>.success(data != null ? "Success" : null);
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
        debugPrint('DIO SERVER FROM SEND MESSAGE: ${response.data}');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage:
                  "Oops! something went wrong notifying for live video",
              data: null),
        );
      },
    );
  }

  Future<State> updateUserStatus(String status) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpClient.post(Endpoints.userStatus, body: {"status": status}),
      successResponse: (data) {
        return State<String?>.success(data != null ? data["message"] : null);
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
        debugPrint('DIO SERVER FROM SEND MESSAGE: ${response.data}');
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
