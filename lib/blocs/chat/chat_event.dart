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
  final String message;
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

class SendChatMessage extends ChatEvent {
  final ChatMessageRequest message;
  final List<File> files;

  const SendChatMessage({required this.message, this.files = const []});

  @override
  List<Object> get props => [message, files];
}

class FetchConversationsEvent extends ChatEvent {}

class FetchConversationsMessagesEvent extends ChatEvent {
  final int conversationId;

  const FetchConversationsMessagesEvent({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

class FetchOnlineUsersEvent extends ChatEvent {}

class ListenToChatEvent extends ChatEvent {
  final int conversationId;
  final String channelName;

  const ListenToChatEvent(this.conversationId, this.channelName);

  @override
  List<Object> get props => [conversationId, channelName];
}

class ListenToLiveChatEvent extends ChatEvent {
  final String channelName;

  const ListenToLiveChatEvent(this.channelName);

  @override
  List<Object> get props => [channelName];
}

class ConversationMessagesFetchedEvent extends ChatEvent {
  final int id;
  final String channel;
  final List<Message> messages;

  const ConversationMessagesFetchedEvent(
      {required this.id, required this.channel, required this.messages});

  @override
  List<Object> get props => [id, channel, messages];
}

class UpdateUserStatusEvent extends ChatEvent {
  final String status;

  const UpdateUserStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class SendInviteEvent extends ChatEvent {
  final String inviteType;
  final String channelName;

  const SendInviteEvent({required this.inviteType, required this.channelName});

  @override
  List<Object> get props => [inviteType, channelName];
}
