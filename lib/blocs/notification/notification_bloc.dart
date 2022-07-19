import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/remote/model/notifications_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/notifications_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationsRepository repo = NotificationsRepository(HttpHelper());

  List<Notification> notifications = [];

  NotificationBloc() : super(NotificationInitial()) {
    on<FetchUserNotificationsEvent>(_mapFetchUserNotificationsEventToState);
  }

  FutureOr<void> _mapFetchUserNotificationsEventToState(
      FetchUserNotificationsEvent event,
      Emitter<NotificationState> emit) async {
    try {
      emit(UserNotificationsLoadingState());
      var state = await repo.fetchUsrNotifications();
      if (state is SuccessState) {
        List<Notification> notificationItems = state.value;
        notifications = notificationItems;
        emit(UserNotificationsLoadedState(notifications: notificationItems));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(UserNotificationsLoadFailedState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const UserNotificationsLoadFailedState(
          error:
              "Oops! we are unable to load notifications, please try again."));
    }
  }
}
