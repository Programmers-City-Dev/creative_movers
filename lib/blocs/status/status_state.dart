part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  const StatusState();
}

class StatusInitial extends StatusState {
  @override
  List<Object> get props => [];
}

class AddStatusLoadingState extends StatusState {
  @override
  List<Object> get props => [];
}

class AddStatusSuccessState extends StatusState {
  UploadStatusResponse uploadStatusResponse;

  AddStatusSuccessState({required this.uploadStatusResponse});

  @override
  List<Object> get props => [uploadStatusResponse];
}

class AddStatusFaliureState extends StatusState {
  String error;

  AddStatusFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}

//Get Feeds States
class StatusLoadingState extends StatusState {
  @override
  List<Object> get props => [];
}

class StatusSuccessState extends StatusState {
  ViewStatusResponse viewStatusResponse;

  StatusSuccessState({required this.viewStatusResponse});

  @override
  List<Object> get props => [viewStatusResponse];
}

class StatusFaliureState extends StatusState {
  String error;

  StatusFaliureState({required this.error});

  @override
  List<Object> get props => [error];
}
