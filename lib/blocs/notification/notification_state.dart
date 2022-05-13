part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class UserNotificationsLoadingState extends NotificationState {}

class UserNotificationsLoadedState extends NotificationState {
  final List<Notification> notifications;

  const UserNotificationsLoadedState({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class UserNotificationsLoadFailedState extends NotificationState {
  final String error;

  const UserNotificationsLoadFailedState({required this.error});

  @override
  List<Object> get props => [error];
}
