part of 'conects_bloc.dart';

abstract class ConnectsEvent extends Equatable {
  const ConnectsEvent();
}

class AddConnectsEvent extends ConnectsEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
class GetConnectsEvent extends ConnectsEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
class GetPendingRequestEvent extends ConnectsEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
class SearchEvent extends ConnectsEvent {

  final String? role;
  final String? searchValue;
  @override
  List<Object?> get props => throw UnimplementedError();

  const SearchEvent(this.role, this.searchValue);
}
class RequestReactEvent extends ConnectsEvent {

  final String? connectionId;
  final String? action;

  @override
  List<Object?> get props => throw UnimplementedError();

  const RequestReactEvent(this.connectionId, this.action);
}
class SendRequestEvent extends ConnectsEvent {

  final String? userId;

  @override
  List<Object?> get props => [userId];

  const SendRequestEvent(this.userId);
}

class FollowEvent extends ConnectsEvent {
  final String userId;

  const FollowEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetSuggestedConnectsEvent extends ConnectsEvent {
  @override
  List<Object?> get props => [];
}