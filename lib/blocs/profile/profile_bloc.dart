import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/update_profile_response.dart';
import 'package:creative_movers/data/remote/repository/profile_repository.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String username = '';
  String firstname = '';

  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<GetUsernameEvent>(_mapGetUsernameToState);
    on<FetchUserProfileEvent>(_mapFetchUserProfileEventToEvent);
    on<UpdateProfilePhotoEvent>(_mapUpdateProfilePhotoEventToEvent);
    on<UpdateProfileEvent>(_mapUpdateProfileEventToState);
  }

  FutureOr<void> _mapGetUsernameToState(GetUsernameEvent event,
      Emitter<ProfileState> emit) async {
    var s = await StorageHelper.getString(StorageKeys.username);
    username = s!;
    var firstName = await StorageHelper.getString(StorageKeys.firstname);
    firstname = firstName!;
    emit(UsernameFetchedState(username));
  }

  FutureOr<void> _mapFetchUserProfileEventToEvent(FetchUserProfileEvent event,
      Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      var state = await profileRepository.fetchUserProfile(event.userId);
      if (state is SuccessState) {
        emit(ProfileLoadedState(user: state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileErrorState(errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ProfileErrorState(
          "Oops! Something went wrong, please try again"));
    }
  }

  FutureOr<void> _mapUpdateProfilePhotoEventToEvent(
      UpdateProfilePhotoEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      var state = await profileRepository.updateProfilePhoto(
          event.imagePath, event.isProfilePhoto!);
      if (state is SuccessState) {
        emit(ProfilePhotoUpdatedState(state.value, event.isProfilePhoto!));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileErrorState(errorModel.errorMessage));
      }
    } catch (e) {
      log("EXCEPTION: $e");
      emit(const ProfileErrorState(
          "Oops! Something went wrong, please try again"));
    }
  }


  FutureOr<void> _mapUpdateProfileEventToState(UpdateProfileEvent event,
      Emitter<ProfileState> emit) async {
    try {
      emit(ProfileUpdateLoading());
      var state = await profileRepository.updateProfile(
          email: event.email,
          phone: event.phone,
          gender: event.gender,
          dateOfBirth: event.dateOfBirth,
          ethnicity: event.ethnicity,
          imagePath
          :event.imagePath,
          country: event.country);
      if (state is SuccessState) {
        emit(ProfileUpdateLoadedState(updateProfileResponse: state.value));
        log(state.value.toString());
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileUpdateErrorState(errorModel.errorMessage));
      }
    } catch (e) {
      log("EXCEPTION: $e");
      emit(const ProfileUpdateErrorState(
          "Oops! Something went wrong, please try again"));
    }
  }
}
