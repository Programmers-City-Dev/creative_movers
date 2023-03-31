import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavInitial()) {
    on<SwitchNavEvent>(_mapSwitchNavEventToState);
    on<OpenHomeTabEvent>(_mapOpenHomeTabEventToState);
    on<OpenBizTabEvent>(_mapOpenBizTabEventToState);
    on<OpenConnectsTabEvent>(_mapOpenConnectsTabEventToState);
    on<OpenChatsTabEvent>(_mapOpenChatsTabEventToState);
    on<OpenProfileTabEvent>(_mapOpenProfileTabEventToState);
  }

  // int currentTabIndex = 0;

  FutureOr<void> _mapSwitchNavEventToState(
      SwitchNavEvent event, Emitter<NavState> emit) {
    // currentTabIndex = event.index;
    emit(NavItemSelected(event.index));
  }

  FutureOr<void> _mapOpenHomeTabEventToState(event, Emitter<NavState> emit) {
    emit(OpenHomeTabState());
  }

  FutureOr<void> _mapOpenBizTabEventToState(event, Emitter<NavState> emit) {
    emit(OpenBizTabState());
  }

  FutureOr<void> _mapOpenConnectsTabEventToState(
      event, Emitter<NavState> emit) {
    emit(OpenConnectsTabState());
  }

  FutureOr<void> _mapOpenChatsTabEventToState(event, Emitter<NavState> emit) {
    emit(OpenChatsTabState());
  }

  FutureOr<void> _mapOpenProfileTabEventToState(event, Emitter<NavState> emit) {
    emit(OpenProfileTabState());
  }
}
