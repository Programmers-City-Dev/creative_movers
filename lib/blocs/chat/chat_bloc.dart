import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/data/remote/model/chat/chat_message_request.dart';
import 'package:creative_movers/data/remote/model/chat/chat_message_response.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/data/remote/model/chat/conversation_messages_response.dart';
import 'package:creative_movers/data/remote/model/chat/live_chat_message.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/services/puhser_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_client/pusher_client.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<LiveChatMessage>>? _liveChannelMessageStream;

  ValueNotifier<List<Message>> chatMessagesNotifier = ValueNotifier([]);
  ValueNotifier<List<LiveChatMessage>> liveChatMessagesNotifier =
      ValueNotifier([]);

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<GenerateAgoraToken>(_onGenerateAgoraToken);
    on<FetchLiveChannelMessages>(_mapFetchLiveChannelMessagesToState);
    on<SendLiveChannelMessage>(_mapSendLiveChannelMessageToState);
    on<SendChatMessage>(_mapSendChatMessageEventToState);
    on<FetchConversationsEvent>(_mapFetchConversationsEventToState);
    on<FetchOnlineUsersEvent>(_mapFetchOnlineUsersEventToState);
    on<UpdateUserStatusEvent>(_mapUpdateUserStatusEventToState);
    on<SendInviteEvent>(_mapSendInviteEventToState);
    on<FetchConversationsMessagesEvent>(
        _mapFetchConversationsMessagesEventToEvent);
    on<LiveChatMessagesFetchedEvent>(
      (event, emit) =>
          emit(LiveChannelMessagesFetched(messages: event.messages)),
    );

    // Listen to chat messages
    on<ListenToChatEvent>(_mapListenToChatEventsToState);
    on<ListenToLiveChatEvent>(_mapListenToLiveChatEventsToState);
    on<ConversationMessagesFetchedEvent>((event, emit) => emit(
        ConversationMessagesFetched(
            id: event.id,
            channel: event.channel,
            messages: chatMessagesNotifier.value)));
  }

  FutureOr<void> _onGenerateAgoraToken(
      GenerateAgoraToken event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    try {
      final tokenState = await chatRepository.generateToken(
          uid: event.uid, channelName: event.channelName);
      if (tokenState is SuccessState) {
        emit(AgoraTokenGotten(token: tokenState.value));
      } else if (tokenState is ErrorState) {
        ServerErrorModel errorModel = tokenState.value;
        emit(AgoraTokenFailed(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(AgoraTokenFailed(error: "Unable to get token: $e"));
    }
  }

  FutureOr<void> _mapFetchLiveChannelMessagesToState(
      FetchLiveChannelMessages event, Emitter<ChatState> emit) async {
    _liveChannelMessageStream =
        chatRepository.channelMessages(event.channelName).listen((messages) {
      if (!isClosed) {
        add(LiveChatMessagesFetchedEvent(messages: messages));
      }
    });
  }

  @override
  Future<void> close() {
    _liveChannelMessageStream?.cancel();
    return super.close();
  }

  FutureOr<void> _mapSendLiveChannelMessageToState(
      SendLiveChannelMessage event, Emitter<ChatState> emit) async {
    try {
      emit(ChatMessageLoading());
      var state = await chatRepository.sendChannelMessage(
          event.channelName, event.message);
      if (state is SuccessState) {
        emit(LiveChannelMessagesent(reference: state.value));
      } else if (state is ErrorState) {
        emit(ChatError(errorModel: state.value));
      }
    } catch (e) {
      log("SEND LIVE CHAT ERROR: $e");
      ServerErrorModel errorModel = const ServerErrorModel(
          statusCode: 404, errorMessage: "Unable to send message!");
      emit(ChatError(errorModel: errorModel));
    }
  }

  FutureOr<void> _mapSendChatMessageEventToState(
      SendChatMessage event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    try {
      final state = await chatRepository.sendChatMessage(
          message: event.message,
          files: [if (event.files.isNotEmpty) event.files.first]);
      if (state is SuccessState) {
        ChatMessageResponse messageSent = state.value;
        injector.get<ChatBloc>().add(FetchConversationsEvent());
        emit(ChatMessageSent(chatMessageResponse: messageSent));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ChatError(errorModel: errorModel));
      }
    } catch (e) {
      log("CHAT ERROR: $e");
      ServerErrorModel errorModel = const ServerErrorModel(
          statusCode: 404, errorMessage: "Unable to send message!");
      emit(ChatError(errorModel: errorModel));
    }
  }

  FutureOr<void> _mapFetchConversationsEventToState(
      FetchConversationsEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    try {
      final state = await chatRepository.fetchChatConversations();
      if (state is SuccessState) {
        List<Conversation> conversations = state.value;
        emit(ConversationsFetched(conversations: conversations));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ChatError(errorModel: errorModel));
      }
    } catch (e) {
      ServerErrorModel errorModel = const ServerErrorModel(
          statusCode: 404, errorMessage: "Unable to fetch conversations!");
      emit(ChatError(errorModel: errorModel));
    }
  }

  FutureOr<void> _mapFetchConversationsMessagesEventToEvent(
      FetchConversationsMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    try {
      final state = await chatRepository.fetchChatConversationMessages(event.conversationId);

      if (state is SuccessState) {
        ConversationMessagesResponse response = state.value;
        chatMessagesNotifier.value = response.conversationData.messages;
        emit(ConversationMessagesFetched(
            id: response.conversationData.id,
            channel: response.conversationData.channel,
            messages: chatMessagesNotifier.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ChatError(errorModel: errorModel));
      }
    } catch (e) {
      ServerErrorModel errorModel = const ServerErrorModel(
          statusCode: 404,
          errorMessage: "Unable to fetch messages for this conversation!");
      emit(ChatError(errorModel: errorModel));
    }
  }

  FutureOr<void> _mapListenToChatEventsToState(
      ListenToChatEvent event, Emitter<ChatState> emit) async {
    try {
      int userId = injector.get<CacheCubit>().cachedUser!.id;
      var pusherService = await PusherService.getInstance;
      PusherClient? pusher = await pusherService.getClient;
      if (pusher != null) {
        log("CHANNEL: message-${event.channelName}");
        Channel channel = pusher.subscribe('message-${event.channelName}');
        channel.bind("chat_message_push", (PusherEvent? pusherEvent) {
          log("PUSHER EVENT: ${pusherEvent!.data}");
          if (pusherEvent.data != null) {
            var message =
                ChatData.fromMap(jsonDecode(pusherEvent.data!)["chat_data"])
                    .message;
            if (message.userId != userId.toString()) {
              chatMessagesNotifier.value =
                  List<Message>.from(chatMessagesNotifier.value..add(message));
            }
            // chatMessagesNotifier.notifyListeners();
            // add(ConversationMessagesFetchedEvent(
            //     id: event.conversationId,
            //     channel: event.channelName,
            //     messages: coreChatMessages));
            log("EVENT MESSAGE: ${message.toMap()}");
          }
        });
      }
    } catch (e) {
      log("Message Event Error: $e");
    }
  }

  void pushMessage(Message message) {
    chatMessagesNotifier.value =
        List<Message>.from(chatMessagesNotifier.value..add(message));
  }

  void resetChatMessage(Message message, int messageId) {
    int index = chatMessagesNotifier.value
        .indexWhere((element) => element.id == messageId);
    List<Message> messages = chatMessagesNotifier.value;
    messages[index] = message..shouldLoad = false;
    // messages.removeAt(index);
    chatMessagesNotifier.value = List<Message>.from(messages);
  }

  FutureOr<void> _mapFetchOnlineUsersEventToState(
      FetchOnlineUsersEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    try {
      var state = await chatRepository.fetchOnlineUsers;
      if (state is SuccessState) {
        List<ConversationUser> users = state.value;
        emit(OnlineUsersFetched(users));
      } else if (state is ErrorState) {
        emit(ChatError(errorModel: state.value));
      }
    } catch (e) {
      ServerErrorModel errorModel = const ServerErrorModel(
          statusCode: 404, errorMessage: "Oops! an error occurred, try again!");
      emit(ChatError(errorModel: errorModel));
    }
  }

  FutureOr<void> _mapUpdateUserStatusEventToState(
      UpdateUserStatusEvent event, Emitter<ChatState> emit) async {
    try {
      var state = await chatRepository.updateUserStatus(event.status);
      if (state is SuccessState) {
        log("${state.value}");
      } else if (state is ErrorState) {
        log("Error updating user status: ${state.value}");
      }
    } catch (e) {
      log("Error updating user status: $e");
    }
  }

  FutureOr<void> _mapSendInviteEventToState(
      SendInviteEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatMessageLoading());
      var state =
          await chatRepository.sendInvite(event.inviteType, event.channelName);
      if (state is SuccessState) {
        log("${state.value}");
        emit(InviteSent(message: state.value));
      } else if (state is ErrorState) {
        log("Error sending invite: ${state.value}");
        emit(ChatError(errorModel: state.value));
      }
    } catch (e) {
      log("Error sending invite: $e");
      emit(const ChatError(
          errorModel: ServerErrorModel(
              statusCode: 404,
              errorMessage: "Oops! an error occurred, try again!")));
    }
  }

  FutureOr<void> _mapListenToLiveChatEventsToState(
      ListenToLiveChatEvent event, Emitter<ChatState> emit) async {
    try {
      var pusherService = await PusherService.getInstance;
      PusherClient? pusher = await pusherService.getClient;
      if (pusher != null) {
        log("CHANNEL: live-${event.channelName}");
        Channel channel = pusher.subscribe('live-${event.channelName}');
        channel.bind("live_chat_message", (PusherEvent? pusherEvent) {
          log("PUSHER EVENT: ${pusherEvent!.data}");
          if (pusherEvent.data != null) {
            var message =
                LiveChatMessage.fromMap(jsonDecode(pusherEvent.data!));
            liveChatMessagesNotifier.value = List<LiveChatMessage>.from(
                liveChatMessagesNotifier.value..add(message));
            log("EVENT MESSAGE: ${message.toMap()}");
          }
        });
      }
    } catch (e) {
      log("Message Event Error: $e");
    }
  }
}
