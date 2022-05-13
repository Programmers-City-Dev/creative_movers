part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class AgoraTokenGotten extends ChatState {
  final String token;

  const AgoraTokenGotten({required this.token});

  @override
  List<Object> get props => [token];
}

class AgoraTokenFailed extends ChatState {
  final String error;
  const AgoraTokenFailed({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
