import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/data/remote/model/create_page_response.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/get_page_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/suggested_page_response.dart';
import 'package:creative_movers/data/remote/repository/buisness_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';

part 'buisness_event.dart';

part 'buisness_state.dart';

class BuisnessBloc extends Bloc<BuisnessEvent, BuisnessState> {
  final BuisnessRepository buisnessRepository = BuisnessRepository(HttpHelper());

  BuisnessBloc() : super(BuisnessInitial()) {
    on<BuisnessEvent>((event, emit) {});
    on<BuisnessProfileEvent>(_mapBuisnessProfileEvent);
    on<CreatePageEvent>(_mapCreatePageEvent);
    on<EditPageEvent>(_mapEditPageEvent);
    on<PageSuggestionsEvent>(_mapPageSuggestionEvent);
    on<PageFeedsEvent>(_mapPageFeedsEvent);
    on<FollowPageEvent>(_mapFollowPageEvent);
    on<LikePageEvent>(_mapLikePageEvent);
    on<GetPageEvent>(_mapGetPageEvent);

  }

  void _mapBuisnessProfileEvent(
      BuisnessEvent event, Emitter<BuisnessState> emitter) async {
    emit(BuisnessLoadingState());
    try {
      var state = await buisnessRepository.getBuisnessPage();
      if (state is SuccessState) {
        emit(BuisnessSuccesState(buisnessProfile: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(BuisnessFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(BuisnessFailureState(error: 'Oops Something went wrong'));
    }
  }

  void _mapPageSuggestionEvent(
      PageSuggestionsEvent event, Emitter<BuisnessState> emitter) async {
    emit(PageSuggestionsLoadingState());
    try {
      var state = await buisnessRepository.getPageSuggestions();
      if (state is SuccessState) {
        emit(PageSuggestionsSuccesState(buisnessProfile: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(PageSuggestionsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(PageSuggestionsFailureState(error: 'Oops Something went wrong'));
    }
  }

  void _mapGetPageEvent(
      GetPageEvent event, Emitter<BuisnessState> emitter) async {
    emit(GetPageLoadingState());
    try {
      var state = await buisnessRepository.getPage(event.page_id);
      if (state is SuccessState) {
        emit(GetPageSuccesState(getPageResponse: state.value,));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(GetPageFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(GetPageFailureState(error: 'Oops Something went wrong'));
    }
  }

  void _mapCreatePageEvent(
      CreatePageEvent event, Emitter<BuisnessState> emitter) async {
    emit( CreatePageLoadingState());
    try {
      var state = await buisnessRepository.create_page(
        stage: event.stage,
        category: event.category,
        description: event.description,
        name: event.name,
        photo: event.photo,
        est_capital: event.est_capital,
        contact: event.contact,
        website: event.website,
      );
      if (state is SuccessState) {
        emit( CreatePageSuccesState(createPageResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit( CreatePageFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit( CreatePageFailureState(error: 'Oops Something went wrong'));

    }
  }

  void _mapEditPageEvent(
      EditPageEvent event, Emitter<BuisnessState> emitter) async {
    emit( EditPageLoadingState());
    try {
      var state = await buisnessRepository.edit_page(
        stage: event.stage,
        category: event.category,
        description: event.description,
        name: event.name,
        photo: event.photo,
        est_capital: event.est_capital,
        contact: event.contact,
        website: event.website,
        page_id: event.page_id
      );
      if (state is SuccessState) {
        emit( EditPageSuccesState(buisnessProfile: state.value,));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit( EditPageFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(EditPageFailureState(error: 'Oops Something went wrong'));
      // TODO
    }
  }

  void _mapPageFeedsEvent(
      PageFeedsEvent event, Emitter<BuisnessState> emitter) async {
    emit(PageFeedsLoadingState());
    try {
      var state = await buisnessRepository.getPageFeeds(event.page_id);
      if (state is SuccessState) {
        emit(PageFeedsSuccesState(feedsResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(PageFeedsFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(PageFeedsFailureState(error: 'Oops Something went wrong'));
    }
  }
  void _mapFollowPageEvent(
      FollowPageEvent event, Emitter<BuisnessState> emitter) async {
    emit(FollowPageLoadingState());
    try {
      var state = await buisnessRepository.followPage(event.page_id);
      if (state is SuccessState) {
        emit(FollowPageSuccesState(message: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(FollowPageFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(FollowPageFailureState(error: 'Oops Something went wrong'));
    }
  }

  void _mapLikePageEvent(
      LikePageEvent event, Emitter<BuisnessState> emitter) async {
    emit(LikePageLoadingState());
    try {
      var state = await buisnessRepository.likePage(event.page_id);
      if (state is SuccessState) {
        emit(LikePageSuccesState(message: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(LikePageFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(LikePageFailureState(error: 'Oops Something went wrong'));
    }
  }
}
