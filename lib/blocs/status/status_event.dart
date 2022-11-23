part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

}

class UploadStatusEvent extends StatusEvent {
  String? text;
  String? bg_color;
  String? font_name;
  List<String>? media;


  UploadStatusEvent({ this.text, this.bg_color,  this.font_name,  this.media});

  @override
  List<Object?> get props => [text,bg_color,font_name,media];
}



class GetStatusEvent extends StatusEvent {



  const GetStatusEvent();

  @override
  List<Object?> get props => [];
}
