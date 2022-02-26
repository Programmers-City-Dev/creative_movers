part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
}

class AddFeedEvent extends FeedEvent {
  String type;
  String? pageId;
  String content;
  List<String> media;


  AddFeedEvent({required this.type, this.pageId, required this.content, required this.media});

  @override
  List<Object?> get props => [type,pageId,content,media];
}

class GetFeedEvent extends FeedEvent {



  GetFeedEvent();

  @override
  List<Object?> get props => [];
}
class CommentEvent extends FeedEvent {
 final String feed_id;
 final String comment;

  CommentEvent({required this.feed_id, required this.comment});

  @override
  List<Object?> get props => [];
}
class LikeEvent extends FeedEvent {
 final String feed_id;
 LikeEvent({required this.feed_id});

  @override
  List<Object?> get props => [];
}
