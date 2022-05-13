part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();
}

class FeedInitial extends FeedState {
  @override
  List<Object> get props => [];

  
}

class AddFeedLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}

class AddFeedSuccessState extends FeedState {
  final AddFeedResponse feedResponse;

  const AddFeedSuccessState({required this.feedResponse});

  @override
  List<Object> get props => [feedResponse];
}

class AddFeedFaliureState extends FeedState {
  final String error;

  const AddFeedFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Get Feeds States
class FeedLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}
class FeedSuccessState extends FeedState {
  final FeedsResponse feedResponse;

  const FeedSuccessState({required this.feedResponse});

  @override
  List<Object> get props => [feedResponse];
}
class FeedFaliureState extends FeedState {
  final String error;

  const FeedFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}

class FeedItemLoadedState extends FeedState {
  final Feed feed;

  const FeedItemLoadedState({required this.feed});

  @override
  List<Object> get props => [feed];
}


//CommentStates
class CommentsLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}
class CommentsSuccessState extends FeedState {
  final PostCommentResponse postCommentsResponse;

  const CommentsSuccessState({required this.postCommentsResponse});

  @override
  List<Object> get props => [postCommentsResponse];
}
class CommentsFaliureState extends FeedState {
  final String error;

  const CommentsFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}

//LikesStates
class LikeLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}
class LikeSuccessState extends FeedState {
  final LikeResponse likeResponse;

  const LikeSuccessState({required this.likeResponse});

  @override
  List<Object> get props => [likeResponse];
}
class LikeFaliureState extends FeedState {
  final String error;

  const LikeFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}
