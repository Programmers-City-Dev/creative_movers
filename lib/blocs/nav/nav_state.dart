part of 'nav_bloc.dart';

abstract class NavState extends Equatable {
  const NavState();

  @override
  List<Object> get props => [];
}

class NavInitial extends NavState {}

class NavItemSelected extends NavState {
  final int selectedIndex;

  const NavItemSelected(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class OpenHomeTabState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OpenBizTabState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OpenConnectsTabState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OpenChatsTabState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OpenProfileTabState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LogoutAppState extends NavState {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
