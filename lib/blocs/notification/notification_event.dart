part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchUserNotificationsEvent extends NotificationEvent {}


class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}


class MarkAllNotificationAsReadEvent extends NotificationEvent {

  const MarkAllNotificationAsReadEvent();

  @override
  List<Object> get props => [];
}
