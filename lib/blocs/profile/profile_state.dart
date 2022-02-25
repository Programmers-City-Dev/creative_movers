part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User user;

  const ProfileLoadedState({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String error;

  const ProfileErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UsernameFetchedState extends ProfileState {
  final String username;

  const UsernameFetchedState(this.username);

  @override
  List<Object> get props => [username];
}
