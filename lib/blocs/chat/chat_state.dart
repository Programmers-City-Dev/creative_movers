part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatMessageLoading extends ChatState {}

class ChatError extends ChatState {
  final ServerErrorModel errorModel;

  const ChatError({
    required this.errorModel,
  });

  @override
  List<Object> get props => [errorModel];
}

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

class LiveChannelMessagesent extends ChatState {
  final DocumentReference reference;

  const LiveChannelMessagesent({
    required this.reference,
  });

  @override
  List<Object> get props => [reference];
}

class LiveChannelMessagesFetched extends ChatState {
  final List<LiveChatMessage> messages;

  const LiveChannelMessagesFetched({
    required this.messages,
  });

  @override
  List<Object> get props => [messages];
}

class ChatMessageSent extends ChatState {
  final ChatMessageResponse chatMessageResponse;

  const ChatMessageSent({required this.chatMessageResponse});

  @override
  List<Object> get props => [chatMessageResponse];
}

class ConversationsFetched extends ChatState {
  final List<Conversation> conversations;

  const ConversationsFetched({required this.conversations});

  @override
  List<Object> get props => [conversations];
}

class ConversationMessagesFetched extends ChatState {
  final int id;
  final String channel;
  final List<Message> messages;

  const ConversationMessagesFetched(
      {required this.id, required this.channel, required this.messages});

  @override
  List<Object> get props => [id, channel, messages];
}

class OnlineUsersFetched extends ChatState {
  final List<ConversationUser> users;

  const OnlineUsersFetched(this.users);

  @override
  List<Object> get props => [users];
}

class InviteSent extends ChatState {
  final String message;

  const InviteSent({required this.message});

  @override
  List<Object> get props => [message];
}
