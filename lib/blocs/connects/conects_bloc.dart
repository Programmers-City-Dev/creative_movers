import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/data/remote/model/react_response.dart';
import 'package:creative_movers/data/remote/model/search_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/connects_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';

part 'conects_event.dart';

part 'conects_state.dart';

class ConnectsBloc extends Bloc<ConnectsEvent, ConnectsState> {
  final ConnectsRepository connectsRepository =
      ConnectsRepository(HttpHelper());

  ConnectsBloc() : super(ConnectsInitial()) {
    on<ConnectsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetConnectsEvent>(_mapGetConnectsEventToState);
    on<SearchEvent>(_mapSearchEventToState);
    on<GetPendingRequestEvent>(_mapGetPendingRequestEventToState);
    on<RequestReactEvent>(_mapRequestReactEventToState);
    on<SendRequestEvent>(_mapSendRequestEventToState);
    on<FollowEvent>(_mapFollowEventToState);
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

  FutureOr<void> _mapGetPendingRequestEventToState(
      GetPendingRequestEvent event, Emitter<ConnectsState> emit) async {
    emit(PendingRequestLoadingState());
    try {
      var state = await connectsRepository.getPendingRequest();
      if (state is SuccessState) {
        emit(PendingRequestSuccesState(getConnectsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(PendingRequestFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(PendingRequestFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }


  FutureOr<void> _mapSearchEventToState(
      SearchEvent event, Emitter<ConnectsState> emit) async {
    emit(SearchLoadingState());
    try {
      var state = await connectsRepository.search(searchValue: event.searchValue,role: event.role);
      if (state is SuccessState) {
        emit(SearchSuccesState(searchResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(SearchFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(SearchFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }

  FutureOr<void> _mapRequestReactEventToState(
      RequestReactEvent event, Emitter<ConnectsState> emit) async {
    emit(RequestReactLoadingState());
    try {
      var state = await connectsRepository.react(connection_id: event.connection_id,action: event.action);
      if (state is SuccessState) {
        emit(RequestReactSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(RequestReactFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(RequestReactFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }


  FutureOr<void> _mapSendRequestEventToState(
      SendRequestEvent event, Emitter<ConnectsState> emit) async {
    emit(SendRequestLoadingState());
    try {
      var state = await connectsRepository.send_request(user_id: event.user_id,);
      if (state is SuccessState) {
        emit(SendRequestSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(SendRequestFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(SendRequestFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }


  FutureOr<void> _mapFollowEventToState(
      FollowEvent event, Emitter<ConnectsState> emit) async {
    emit(FollowLoadingState());
    try {
      var state = await connectsRepository.follow_request(user_id: event.user_id,);
      if (state is SuccessState) {
        emit(FollowSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(FollowFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(FollowFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }
}
