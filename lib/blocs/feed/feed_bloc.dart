import 'dart:async';
import 'dart:developer';

import 'package:creative_movers/data/remote/model/feed_response.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/like_response.dart';
import 'package:creative_movers/data/remote/model/post_comments_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;

  FeedBloc(this.feedRepository) : super(FeedInitial()) {
    on<AddFeedEvent>(_mapAddFeedEventToState);
    on<DeleteFeedEvent>(_mapDeleteFeedEventToState);
    on<GetFeedEvent>(_mapGetFeedEventToState);
    on<CommentEvent>(_mapCommentEventToState);
    on<LikeEvent>(_mapLikeEventToState);
    on<FetchFeedItemEvent>(_mapFetchFeedItemEventToState);
    on<EditFeedEvent>(_mapEditFeedEventToState);
    on<ReportFeed>(_mapReportFeedEventToState);
  }

  Future<FutureOr<void>> _mapDeleteFeedEventToState(
      DeleteFeedEvent event, Emitter<FeedState> emit) async {
    try {
      emit(DeleteFeedLoadingState());
      var response = await feedRepository.deletePost(feedId: event.feedId);
      if (response is SuccessState) {
        emit(DeleteFeedSuccessState(message: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(DeleteFeedFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(DeleteFeedFaliureState(error: "Ooops Something went wrong."));
    }
  }

  Future<FutureOr<void>> _mapEditFeedEventToState(
      EditFeedEvent event, Emitter<FeedState> emit) async {
    emit(EditFeedLoadingState());
    try {
      var response = await feedRepository.editFeed(
        feed_id: event.feed_id,
        page_id: event.pageId,
        content: event.content,
        media: event.media,
      );
      if (response is SuccessState) {
        emit(EditFeedSuccessState(feedResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        log(serverErrorModel.data.toString());

        emit(EditFeedFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      log(e.toString());
      emit(EditFeedFaliureState(error: "Ooops Something went wrong. $e ."));
    }
  }

  Future<FutureOr<void>> _mapAddFeedEventToState(
      AddFeedEvent event, Emitter<FeedState> emit) async {
    emit(AddFeedLoadingState());
    try {
      var response = await feedRepository.adFeed(
          type: event.type,
          pageId: event.pageId,
          content: event.content,
          media: event.media);
      if (response is SuccessState) {
        emit(AddFeedSuccessState(feedResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(AddFeedFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      log(e.toString());
      emit(AddFeedFaliureState(error: "Oops! Something went wrong. $e."));
    }
  }

  Future<FutureOr<void>> _mapGetFeedEventToState(
      FeedEvent event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      var response = await feedRepository.getFeeds();
      if (response is SuccessState) {
        emit(FeedSuccessState(feedResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        log(serverErrorModel.data.toString());
        emit(FeedFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(const FeedFaliureState(error: "Oops! Something went wrong."));
    }
  }

  Future<FutureOr<void>> _mapCommentEventToState(
      CommentEvent event, Emitter<FeedState> emit) async {
    try {
      emit(CommentsLoadingState());
      var response = await feedRepository.postComments(
          comment: event.comment, feed_id: event.feedId);
      if (response is SuccessState) {
        emit(CommentsSuccessState(postCommentsResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(CommentsFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(const CommentsFaliureState(error: "Oops! Something went wrong."));
    }
  }

  Future<FutureOr<void>> _mapLikeEventToState(
      LikeEvent event, Emitter<FeedState> emit) async {
    try {
      emit(LikeLoadingState());
      var response = await feedRepository.postLike(feed_id: event.feeId);
      if (response is SuccessState) {
        emit(LikeSuccessState(likeResponse: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(LikeFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(const LikeFaliureState(error: "Oops! Something went wrong."));
    }
  }

  FutureOr<void> _mapFetchFeedItemEventToState(
      FetchFeedItemEvent event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      var response = await feedRepository.getFeedItem(event.feedId);
      if (response is SuccessState) {
        Feed feed = response.value;
        emit(FeedItemLoadedState(feed: feed));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(FeedFaliureState(error: serverErrorModel.errorMessage));
      }
    } catch (e) {
      emit(const FeedFaliureState(error: "Oops! Something went wrong."));
    }
  }

  FutureOr<void> _mapReportFeedEventToState(
      ReportFeed event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      var response = await feedRepository.reportFeed(
          type: event.type, reason: event.reason, dataId: event.dataId);
      if (response is SuccessState) {
        emit(FeedReported(message: response.value));
      }
      if (response is ErrorState) {
        ServerErrorModel serverErrorModel = response.value;
        emit(FeedFailure(errorModel: serverErrorModel));
      }
    } catch (e) {
      emit(const FeedFailure(
          errorModel: ServerErrorModel(
              statusCode: 400, errorMessage: "Oops! Something went wrong.")));
    }
  }
}

//
// Future<FutureOr<void>> _mapLikeEventToState(
//     AddFeedEvent event, Emitter<FeedState> emit) async {
//   try {
//     emit(FeedLoadingState());
//     var response = await feedRepository.adFeed(
//         type: event.type,
//         page_id: event.pageId!,
//         content: event.content,
//         media: event.media);
//     if (response is SuccessState) {
//       emit(FeedSuccessState(feedResponse: response.value));
//     }
//     if (response is ErrorState) {
//       ServerErrorModel serverErrorModel = response.value;
//       emit(FeedFaliureState(error: serverErrorModel.errorMessage));
//     }
//   } catch (e) {
//     emit(FeedFaliureState(error: "Ooops Something went wrong."));
//
//   }
// }
//
// Future<FutureOr<void>> _mapAddCommentEventToState(
//     AddFeedEvent event, Emitter<FeedState> emit) async {
//   try {
//     emit(FeedLoadingState());
//     var response = await feedRepository.adFeed(
//         type: event.type,
//         page_id: event.pageId!,
//         content: event.content,
//         media: event.media);
//     if (response is SuccessState) {
//       emit(FeedSuccessState(feedResponse: response.value));
//     }
//     if (response is ErrorState) {
//       ServerErrorModel serverErrorModel = response.value;
//       emit(FeedFaliureState(error: serverErrorModel.errorMessage));
//     }
//   } catch (e) {
//     emit(FeedFaliureState(error: "Ooops Something went wrong."));
//
//   }
// }
//
// Future<FutureOr<void>> _mapGetCommentsEventToState(
//     AddFeedEvent event, Emitter<FeedState> emit) async {
//   try {
//     emit(FeedLoadingState());
//     var response = await feedRepository.adFeed(
//         type: event.type,
//         page_id: event.pageId!,
//         content: event.content,
//         media: event.media);
//     if (response is SuccessState) {
//       emit(FeedSuccessState(feedResponse: response.value));
//     }
//     if (response is ErrorState) {
//       ServerErrorModel serverErrorModel = response.value;
//       emit(FeedFaliureState(error: serverErrorModel.errorMessage));
//     }
//   } catch (e) {
//     emit(FeedFaliureState(error: "Ooops Something went wrong."));
//
//   }
// }
// Future<FutureOr<void>> _mapGetLikesEventToState(
//     AddFeedEvent event, Emitter<FeedState> emit) async {
//   try {
//     emit(FeedLoadingState());
//     var response = await feedRepository.adFeed(
//         type: event.type,
//         page_id: event.pageId!,
//         content: event.content,
//         media: event.media);
//     if (response is SuccessState) {
//       emit(FeedSuccessState(feedResponse: response.value));
//     }
//     if (response is ErrorState) {
//       ServerErrorModel serverErrorModel = response.value;
//       emit(FeedFaliureState(error: serverErrorModel.errorMessage));
//     }
//   } catch (e) {
//     emit(FeedFaliureState(error: "Ooops Something went wrong."));
//
//   }
// }
