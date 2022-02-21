part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();
}

class FeedInitial extends FeedState {
  @override
  List<Object> get props => [];
}
class FeedLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}
class FeedSuccessState extends FeedState {
  FeedResponse feedResponse;

  FeedSuccessState({required this.feedResponse});

  @override
  List<Object> get props => [feedResponse];
}
class FeedFaliureState extends FeedState {
  String error;

  FeedFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}
