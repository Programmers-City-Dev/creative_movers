part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
}

class AddFeedEvent extends FeedEvent {
  final String type;
  final String? pageId;
  final String content;
  final List<String> media;

  const AddFeedEvent(
      {required this.type,
      this.pageId,
      required this.content,
      required this.media});

  @override
  List<Object?> get props => [type, pageId, content, media];
}

class GetFeedEvent extends FeedEvent {
  const GetFeedEvent();

  @override
  List<Object?> get props => [];
}

class FetchFeedItemEvent extends FeedEvent {
  final int feedId;

  const FetchFeedItemEvent(this.feedId);

  @override
  List<Object?> get props => [feedId];
}

class CommentEvent extends FeedEvent {
  final String feedId;
  final String comment;

  const CommentEvent({required this.feedId, required this.comment});

  @override
  List<Object?> get props => [];
}

class LikeEvent extends FeedEvent {
  final String feeId;
  const LikeEvent({required this.feeId});

  @override
  List<Object?> get props => [feeId];
}
