part of 'buisness_bloc.dart';

abstract class BuisnessEvent extends Equatable {
  const BuisnessEvent();
}

class BuisnessProfileEvent extends BuisnessEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreatePageEvent extends BuisnessEvent {
  final String? website;
  final String? contact;
  final String? name;
  final String? stage;
  final List<String>? category;
  final String? est_capital;
  final String? description;

  const CreatePageEvent({this.website,
    this.contact,
    this.name,
    this.stage,
    this.category,
    this.est_capital,
    this.description,
    this.photo});

  final String? photo;

  // final String? max_range;
  // final String? min_range;
  @override
  // TODO: implement props
  List<Object?> get props =>
      [
        photo,
        stage,
        category,
        name,
        description,
        est_capital,
        website,
        contact
      ];
}

class EditPageEvent extends BuisnessEvent {
  final String? website;
  final String? contact;
  final String? name;
  final String? page_id;
  final String? stage;
  final List<String>? category;
  final String? est_capital;
  final String? description;

  const EditPageEvent({this.page_id, this.website,
    this.contact,
    this.name,
    this.stage,
    this.category,
    this.est_capital,
    this.description,
    this.photo});

  final String? photo;

  // final String? max_range;
  // final String? min_range;
  @override
  // TODO: implement props
  List<Object?> get props =>
      [
        photo,
        stage,
        category,
        name,
        description,
        est_capital,
        website,
        contact
      ];
}

class PageSuggestionsEvent extends BuisnessEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PageFeedsEvent extends BuisnessEvent {
  String page_id;

  PageFeedsEvent(this.page_id);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GetPageEvent extends BuisnessEvent {
  String page_id;

  GetPageEvent(this.page_id);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FollowPageEvent extends BuisnessEvent {
  String page_id;

  FollowPageEvent(this.page_id);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

// class
