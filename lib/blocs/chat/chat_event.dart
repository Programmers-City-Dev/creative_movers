part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GenerateAgoraToken extends ChatEvent {
  final String? uid;
  final String channelName;

  const GenerateAgoraToken({this.uid, required this.channelName});

  @override
  List<Object> get props => [channelName];
}
