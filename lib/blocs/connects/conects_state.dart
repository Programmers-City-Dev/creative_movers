part of 'conects_bloc.dart';

abstract class ConnectsState extends Equatable {
  const ConnectsState();
}

class ConectsInitial extends ConnectsState {
  @override
  List<Object> get props => [];
}
class ConnectsLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}
class ConnectsSuccesState extends ConnectsState {
  FetchConnectionResponse getConnectsResponse;
  @override
  List<Object> get props => [getConnectsResponse];

  ConnectsSuccesState({required this.getConnectsResponse});
}
class ConnectsFailureState extends ConnectsState {
  String error;

  ConnectsFailureState({required this.error});

  @override
  List<Object> get props => [ error];
}


class SearchLoadingState extends ConnectsState {
  @override
  List<Object> get props => [];
}
class SearchSuccesState extends ConnectsState {
  FetchConnectionResponse getConnectsResponse;
  @override
  List<Object> get props => [getConnectsResponse];

  SearchSuccesState({required this.getConnectsResponse});
}
class SearchFailureState extends ConnectsState {
  String error;

  SearchFailureState({required this.error});

  @override
  List<Object> get props => [ error];
}
