import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/get_connects_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:creative_movers/repository/remote/connects_repository.dart';
import 'package:equatable/equatable.dart';

part 'conects_event.dart';

part 'conects_state.dart';

class ConnectsBloc extends Bloc<ConnectsEvent, ConnectsState> {
  final ConnectsRepository connectsRepository =
      ConnectsRepository(HttpHelper());

  ConnectsBloc() : super(ConectsInitial()) {
    on<ConnectsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetConnectsEvent>(_mapGetConnectsEventToState);
    on<SearchEvent>(_mapSearchEventToState);
  }

  FutureOr<void> _mapGetConnectsEventToState(
      GetConnectsEvent event, Emitter<ConnectsState> emit) async {
    emit(ConnectsLoadingState());
    try {
      var state = await connectsRepository.getConnects();
      if (state is SuccessState) {
        emit(ConnectsSuccesState(getConnectsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConnectsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(ConnectsFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }

  FutureOr<void> _mapSearchEventToState(
      SearchEvent event, Emitter<ConnectsState> emit) async {
    emit(SearchLoadingState());
    try {
      var state = await connectsRepository.search();
      if (state is SuccessState) {
        emit(SearchSuccesState(getConnectsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(SearchFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(SearchFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }
}
