part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationRefreshing extends NotificationState{}



class UserNotificationsLoadedState extends NotificationState {
  final List<Notification> notifications;

  const UserNotificationsLoadedState({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class UserNotificationsRefreshed extends NotificationState{}

class UserNotificationsLoadFailedState extends NotificationState {
  final String error;

  const UserNotificationsLoadFailedState({required this.error});

  @override
  List<Object> get props => [error];
}

class UserNotificationsRefreshError extends NotificationState {
  final String error;

  const UserNotificationsRefreshError({required this.error});

  @override
  List<Object> get props => [error];
}

class NotificationReadState extends NotificationState {
  final String notificationId;

  const NotificationReadState({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}
