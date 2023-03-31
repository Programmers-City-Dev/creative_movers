part of 'buisness_bloc.dart';

abstract class BuisnessState extends Equatable {
  const BuisnessState();
}

class BuisnessInitial extends BuisnessState {
  @override
  List<Object> get props => [];
}


class BuisnessLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class BuisnessSuccesState extends BuisnessState{
  BuisnessProfile buisnessProfile;
  BuisnessSuccesState({required this.buisnessProfile});

  @override
  // TODO: implement props
  List<Object?> get props =>[buisnessProfile];


}
class BuisnessFailureState extends BuisnessState{
  String error;

  BuisnessFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}

class CreatePageLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class CreatePageSuccesState extends BuisnessState{
  CreatePageResponse createPageResponse;
  CreatePageSuccesState({required this.createPageResponse});

  @override
  // TODO: implement props
  List<Object?> get props =>[createPageResponse];


}
class CreatePageFailureState extends BuisnessState{
  String error;

  CreatePageFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}



class EditPageLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class EditPageSuccesState extends BuisnessState{
  CreatePageResponse buisnessProfile;
  EditPageSuccesState({required this.buisnessProfile});

  @override
  // TODO: implement props
  List<Object?> get props =>[buisnessProfile];


}
class EditPageFailureState extends BuisnessState{
  String error;

  EditPageFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}



class PageSuggestionsLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class  PageSuggestionsSuccesState extends BuisnessState{
  SuggestedPageResponse buisnessProfile;
  PageSuggestionsSuccesState({required this.buisnessProfile});

  @override
  // TODO: implement props
  List<Object?> get props =>[buisnessProfile];


}
class PageSuggestionsFailureState extends BuisnessState{
  String error;

  PageSuggestionsFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}



class PageFeedsLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class PageFeedsSuccesState extends BuisnessState{
  FeedsResponse feedsResponse;
  PageFeedsSuccesState({required this.feedsResponse});

  @override
  // TODO: implement props
  List<Object?> get props =>[feedsResponse];


}
class PageFeedsFailureState extends BuisnessState{
  String error;

  PageFeedsFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}


class FollowPageLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class FollowPageSuccesState extends BuisnessState{
  final String message;
  const FollowPageSuccesState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props =>[message];


}
class FollowPageFailureState extends BuisnessState{
  String error;

  FollowPageFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}


class LikePageLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class LikePageSuccesState extends BuisnessState{
  final String message;
  const LikePageSuccesState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props =>[message];


}
class LikePageFailureState extends BuisnessState{
  String error;

  LikePageFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}


class GetPageLoadingState extends BuisnessState{
  @override
  // TODO: implement props
  List<Object?> get props => [];


}
class GetPageSuccesState extends BuisnessState{
  GetPageResponse getPageResponse;
  GetPageSuccesState({required this.getPageResponse});

  @override
  // TODO: implement props
  List<Object?> get props =>[getPageResponse];


}
class GetPageFailureState extends BuisnessState{
  String error;

  GetPageFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props =>[];


}
