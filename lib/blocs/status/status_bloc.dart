import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/upload_status_response.dart';
import 'package:creative_movers/data/remote/model/view_status_response.dart';
import 'package:creative_movers/data/remote/repository/status_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository statusRepository = StatusRepository(HttpHelper());

  StatusBloc() : super(StatusInitial()) {
    on<StatusEvent>((event, emit) {});
    on<UploadStatusEvent>(_mapUploadStatusEventToState);
    on<GetStatusEvent>(_mapGetStatusEventToState);
  }
  Future<FutureOr<void>> _mapUploadStatusEventToState(
      UploadStatusEvent event, Emitter<StatusState> emit) async {
    emit(AddStatusLoadingState());
    try {
      var response = await statusRepository.uploadStatus(
          text: event.text,
          bg_color: event.bg_color,
          font_name: event.font_name,
          media: event.media);
      if (response is SuccessState) {
        emit(AddStatusSuccessState(uploadStatusResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(AddStatusFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      log(e.toString());
      emit(AddStatusFaliureState(error: "Ooops Something went wrong. $e."));
      // TODO
    }
  }

  Future<FutureOr<void>> _mapGetStatusEventToState(
      GetStatusEvent event, Emitter<StatusState> emit) async {
    try {
      emit(StatusLoadingState());
      var response = await statusRepository.getStatus();
      if (response is SuccessState) {
        emit(StatusSuccessState(viewStatusResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(StatusFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(StatusFaliureState(error: "Ooops Something went wrong."));
      // TODO
    }
  }
}
