part of 'conects_bloc.dart';

abstract class ConnectsEvent extends Equatable {
  const ConnectsEvent();
}

class AddConnectsEvent extends ConnectsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class GetConnectsEvent extends ConnectsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class GetPendingRequestEvent extends ConnectsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class SearchEvent extends ConnectsEvent {

  final String? role;
  final String? searchValue;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  SearchEvent(this.role, this.searchValue);
}
class RequestReactEvent extends ConnectsEvent {

  final String? connection_id;
  final String? action;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  RequestReactEvent(this.connection_id, this.action);
}