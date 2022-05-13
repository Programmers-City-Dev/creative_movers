import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<GenerateAgoraToken>(_onGenerateAgoraToken);
  }

  FutureOr<void> _onGenerateAgoraToken(
      GenerateAgoraToken event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
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
}
