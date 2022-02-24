import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavInitial()) {
    on<SwitchNavEvent>(_mapSwitchNavEventToState);
  }

  int currentTabIndex = 0;

  FutureOr<void> _mapSwitchNavEventToState(SwitchNavEvent event, Emitter<NavState> emit) {
    currentTabIndex = event.index;
    emit(BuyerNavItemSelected(event.index));
  }
}
