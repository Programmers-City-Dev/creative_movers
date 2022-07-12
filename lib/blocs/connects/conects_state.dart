part of 'conects_bloc.dart';

abstract class ConnectsState extends Equatable {
  const ConnectsState();
}

class ConnectsInitial extends ConnectsState {
  @override
  List<Object> get props => [];
}

class ConnectsLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class ConnectsSuccesState extends ConnectsState {
  final FetchConnectionResponse connectsResponse;

  @override
  List<Object> get props => [connectsResponse];

  const ConnectsSuccesState({required this.connectsResponse});
}

class SuggestedConnectsSuccessState extends ConnectsState {
  final List<SearchResult> connections;

  const SuggestedConnectsSuccessState({required this.connections});

  @override
  List<Object> get props => [connections];
}

class ConnectsFailureState extends ConnectsState {
  final String error;

  const ConnectsFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Search Request States
class SearchLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class SearchSuccesState extends ConnectsState {
  SearchResponse searchResponse;

  @override
  List<Object> get props => [searchResponse];

  SearchSuccesState({required this.searchResponse});
}

class SearchFailureState extends ConnectsState {
  String error;

  SearchFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Pending Request States
class PendingRequestLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class PendingRequestSuccesState extends ConnectsState {
  FetchConnectionResponse getConnectsResponse;

  @override
  List<Object> get props => [getConnectsResponse];

  PendingRequestSuccesState({required this.getConnectsResponse});
}

class PendingRequestFailureState extends ConnectsState {
  String error;

  PendingRequestFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Request Reaction States
class RequestReactLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class RequestReactSuccesState extends ConnectsState {
  ReactResponse reactResponse;

  @override
  List<Object> get props => [reactResponse];

  RequestReactSuccesState({required this.reactResponse});
}

class RequestReactFailureState extends ConnectsState {
  String error;

  RequestReactFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Request Reaction States
class SendRequestLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class SendRequestSuccesState extends ConnectsState {
  ReactResponse reactResponse;

  @override
  List<Object> get props => [reactResponse];

  SendRequestSuccesState({required this.reactResponse});
}

class SendRequestFailureState extends ConnectsState {
  String error;

  SendRequestFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Follow States
class FollowLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}

class FollowSuccesState extends ConnectsState {
  ReactResponse reactResponse;

  @override
  List<Object> get props => [reactResponse];

  FollowSuccesState({required this.reactResponse});
}

class FollowFailureState extends ConnectsState {
  String error;

  FollowFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
