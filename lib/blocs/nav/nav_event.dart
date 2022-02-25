part of 'nav_bloc.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object> get props => [];
}
class SwitchNavEvent extends NavEvent{
  final int index;

  const SwitchNavEvent(this.index);

  @override
  List<Object> get props => [index];
}