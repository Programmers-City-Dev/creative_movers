part of 'nav_bloc.dart';

abstract class NavState extends Equatable {
  const NavState();
  
  @override
  List<Object> get props => [];
}

class NavInitial extends NavState {}

class BuyerNavItemSelected extends NavState {
  final int selectedIndex;

  const BuyerNavItemSelected(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
