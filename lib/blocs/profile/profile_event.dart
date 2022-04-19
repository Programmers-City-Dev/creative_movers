part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUsernameEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class FetchUserProfileEvent extends ProfileEvent {
  final int? userId;

  const FetchUserProfileEvent([this.userId]);

  @override
  List<Object> get props => [];
}

class UpdateProfilePhotoEvent extends ProfileEvent {
  final String imagePath;
  final bool? isProfilePhoto;

  const UpdateProfilePhotoEvent(this.imagePath, {this.isProfilePhoto = false});

  @override
  List<Object> get props => [imagePath, isProfilePhoto!];
}

class UpdateProfileEvent extends ProfileEvent {
  final String? imagePath;
  final bool? isProfilePhoto;
  final String? phone;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final String? ethnicity;
  final String? country;
  final String? state;

  UpdateProfileEvent(
      {this.imagePath,
      this.isProfilePhoto,
      this.phone,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.ethnicity,
      this.country,
      this.state});

  @override
  List<Object> get props => [

      ];
}
