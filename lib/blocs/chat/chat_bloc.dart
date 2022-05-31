import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creative_movers/data/remote/model/live_chat_message.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<LiveChatMessage>>? _liveChannelMessageStream;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<GenerateAgoraToken>(_onGenerateAgoraToken);
    on<FetchLiveChannelMessages>(_mapFetchLiveChannelMessagesToState);
    on<SendLiveChannelMessage>(_mapSendLiveChannelMessageToState);
    on<LiveChatMessagesFetchedEvent>(
      (event, emit) =>
          emit(LiveChannelMessagesFetched(messages: event.messages)),
    );
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
      // if (!isClosed) {
        add(LiveChatMessagesFetchedEvent(messages: messages));
      // }
    });
  }

  @override
  Future<void> close() {
    _liveChannelMessageStream?.cancel();
    return super.close();
  }

  FutureOr<void> _mapSendLiveChannelMessageToState(
      SendLiveChannelMessage event, Emitter<ChatState> emit) async {
    emit(ChatMessageLoading());
    var state = await chatRepository.sendChannelMessage(
        event.channelName, event.message);
    if (state is SuccessState) {
      emit(LiveChannelMessagesent(reference: state.value));
    } else if (state is ErrorState) {
      emit(ChatError(errorModel: state.value));
    }
  }
}
