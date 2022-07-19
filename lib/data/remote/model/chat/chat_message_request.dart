class ChatMessageRequest {
  ChatMessageRequest({
    required this.userId,
    this.conversationId,
    required this.message,
  });

  int userId;
  int? conversationId;
  String message;

  ChatMessageRequest copyWith({
    int? userId,
    int? conversationId,
    String? message,
  }) =>
      ChatMessageRequest(
        userId: userId ?? this.userId,
        conversationId: conversationId ?? this.conversationId,
        message: message ?? this.message,
      );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "conversation_id": conversationId,
    "message": message,
  };
}
