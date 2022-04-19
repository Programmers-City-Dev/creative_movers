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

class ProfilePhotoUpdatedState extends ProfileState {
  final String photo;
  final bool isProfilePhoto;

  const ProfilePhotoUpdatedState(this.photo, this.isProfilePhoto);

  @override
  List<Object> get props => [photo, isProfilePhoto];
}


class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateLoadedState extends ProfileState {
  final User user;

  const ProfileUpdateLoadedState({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileUpdateErrorState extends ProfileState {
  final String error;

  const ProfileUpdateErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UsernameFetchedState extends ProfileState {
  final String username;

  const UsernameFetchedState(this.username);

  @override
  List<Object> get props => [username];
}




// class ProfilePhotoUpdatedState extends ProfileState {
//   final String photo;
//   final bool isProfilePhoto;
//
//   const ProfilePhotoUpdatedState(this.photo, this.isProfilePhoto);
//
//   @override
//   List<Object> get props => [photo, isProfilePhoto];
// }