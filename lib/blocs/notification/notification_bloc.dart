import 'dart:async';

import 'package:creative_movers/data/remote/model/notifications_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/notifications_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationsRepository repo = NotificationsRepository(HttpHelper());

  List<Notification> notifications = [];

  NotificationBloc() : super(NotificationInitial()) {
    on<FetchUserNotificationsEvent>(_mapFetchUserNotificationsEventToState);
    on<MarkNotificationAsReadEvent>(_mapMarkNotificationAsReadEventToState);
    on<MarkAllNotificationAsReadEvent>(
        _mapMarkAllNotificationAsReadEventToState);
  }

  FutureOr<void> _mapFetchUserNotificationsEventToState(
      FetchUserNotificationsEvent event,
      Emitter<NotificationState> emit) async {
    try {
      emit(NotificationLoading());
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

  FutureOr<void> _mapMarkNotificationAsReadEventToState(
      MarkNotificationAsReadEvent event,
      Emitter<NotificationState> emit) async {
    try {
      var state = await repo.markNoticationAsRead(event.notificationId);
      if (state is SuccessState) {
        notifications
            .where((element) => element.id == event.notificationId)
            .first
            .readAt = DateTime.now();
        emit(NotificationInitial());
        emit(UserNotificationsLoadedState(
            notifications: List.from(notifications)));
      } else if (state is ErrorState) {
        // ServerErrorModel errorModel = state.value;
        // emit(UserNotificationsLoadFailedState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const UserNotificationsLoadFailedState(
          error: "An error occured occurred, please try again."));
    }
  }

  FutureOr<void> _mapMarkAllNotificationAsReadEventToState(
      MarkAllNotificationAsReadEvent event,
      Emitter<NotificationState> emit) async {
    try {
      emit(NotificationRefreshing());
      var state = await repo.markAllNoticationAsRead();
      if (state is SuccessState) {
        for (var element in notifications) {
          element.readAt = DateTime.now();
        }
        notifications = List.from(notifications);
        emit(UserNotificationsRefreshed());
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(UserNotificationsRefreshError(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(const UserNotificationsRefreshError(
          error: "An error occured occurred, please try again."));
    }
  }
}
