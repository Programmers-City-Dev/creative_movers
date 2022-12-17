part of 'nav_bloc.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object> get props => [];
}

class SwitchNavEvent extends NavEvent {
  final int index;

  const SwitchNavEvent(this.index);

  @override
  List<Object> get props => [index];
}

class OpenHomeTabEvent extends NavEvent {
  @override
  List<Object> get props => [];
}

class OpenBizTabEvent extends NavEvent {
  @override
  List<Object> get props => [];
}

class OpenConnectsTabEvent extends NavEvent {
  @override
  List<Object> get props => [];
}

class OpenChatsTabEvent extends NavEvent {
  @override
  List<Object> get props => [];
}

class OpenProfileTabEvent extends NavEvent {
  @override
  List<Object> get props => [];
}
