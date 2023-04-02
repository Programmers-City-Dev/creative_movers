import 'dart:async';

import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/data/remote/model/react_response.dart';
import 'package:creative_movers/data/remote/model/search_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/connects_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conects_event.dart';
part 'conects_state.dart';

class ConnectsBloc extends Bloc<ConnectsEvent, ConnectsState> {
  final ConnectsRepository connectsRepository =
      ConnectsRepository(HttpHelper());

  ConnectsBloc() : super(ConnectsInitial()) {
    on<GetConnectsEvent>(_mapGetConnectsEventToState);
    on<SearchEvent>(_mapSearchEventToState);
    on<SearchConnectsEvent>(_mapSearchConnectsEventToState);
    on<GetPendingRequestEvent>(_mapGetPendingRequestEventToState);
    on<GetSuggestedConnectsEvent>(_mapGetSuggestedConnectsEventToState);
    on<RequestReactEvent>(_mapRequestReactEventToState);
    on<ConnectToUserEvent>(_mapSendRequestEventToState);
    on<FollowEvent>(_mapFollowEventToState);
  }

  FutureOr<void> _mapGetConnectsEventToState(
      GetConnectsEvent event, Emitter<ConnectsState> emit) async {
    emit(ConnectsLoadingState());
    try {
      var state = await connectsRepository.getConnects(event.user_id);
      if (state is SuccessState) {
        emit(ConnectsSuccesState(connectsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConnectsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ConnectsFailureState(error: 'Oops Something went wrong'));
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
    }
  }

  FutureOr<void> _mapSearchEventToState(
      SearchEvent event, Emitter<ConnectsState> emit) async {
    emit(SearchLoadingState());
    try {
      var state = await connectsRepository.search(
          searchValue: event.searchValue, role: event.role);
      if (state is SuccessState) {
        emit(SearchSuccesState(searchResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(SearchFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(SearchFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapSearchConnectsEventToState(
      SearchConnectsEvent event, Emitter<ConnectsState> emit) async {
    emit(ConnectsLoadingState());
    try {
      var state = await connectsRepository.searchConnects(
          searchValue: event.searchValue, userId: event.user_id);
      if (state is SuccessState) {
        emit(ConnectsSuccesState(connectsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConnectsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ConnectsFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapRequestReactEventToState(
      RequestReactEvent event, Emitter<ConnectsState> emit) async {
    emit(RequestReactLoadingState());
    try {
      var state = await connectsRepository.react(
          connectionId: event.connectionId, action: event.action);
      if (state is SuccessState) {
        emit(RequestReactSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(RequestReactFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(RequestReactFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapSendRequestEventToState(
      ConnectToUserEvent event, Emitter<ConnectsState> emit) async {
    emit(ConnectToUserLoadingState());
    try {
      var state = await connectsRepository.sendRequest(
        userId: event.userId,
      );
      if (state is SuccessState) {
        emit(ConnectToUserSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConnectToUserFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(ConnectToUserFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapFollowEventToState(
      FollowEvent event, Emitter<ConnectsState> emit) async {
    emit(FollowLoadingState());
    try {
      var state = await connectsRepository.followRequest(
        userId: event.userId,
      );
      if (state is SuccessState) {
        emit(FollowSuccesState(reactResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(FollowFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(FollowFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapGetSuggestedConnectsEventToState(
      GetSuggestedConnectsEvent event, Emitter<ConnectsState> emit) async {
    emit(ConnectsLoadingState());
    try {
      var state = await connectsRepository.getSuggestedConnects();
      if (state is SuccessState) {
        emit(SuggestedConnectsSuccessState(connections: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConnectsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ConnectsFailureState(error: 'Oops Something went wrong'));
    }
  }
}
