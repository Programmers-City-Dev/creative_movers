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

class SendLiveChannelMessage extends ChatEvent {
  final LiveChatMessage message;
  final String channelName;
  const SendLiveChannelMessage({
    required this.message,
    required this.channelName,
  });
  @override
  List<Object> get props => [message, channelName];
}

class FetchLiveChannelMessages extends ChatEvent {
  final String channelName;
  const FetchLiveChannelMessages({
    required this.channelName,
  });
  @override
  List<Object> get props => [channelName];
}

class LiveChatMessagesFetchedEvent extends ChatEvent {
  final List<LiveChatMessage> messages;
  const LiveChatMessagesFetchedEvent({
    required this.messages,
  });
  @override
  List<Object> get props => [messages];
}
