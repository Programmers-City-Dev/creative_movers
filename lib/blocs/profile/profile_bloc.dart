import 'dart:async';
import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/update_profile_response.dart';
import 'package:creative_movers/data/remote/repository/profile_repository.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/remote/model/FaqsResponse.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String username = '';
  String firstname = '';

  final ProfileRepository profileRepository;
  ValueNotifier<String?> selectedCountryNotifier = ValueNotifier(null);
  ValueNotifier<String?> selectedStateNotifier = ValueNotifier(null);

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<GetUsernameEvent>(_mapGetUsernameToState);
    on<FetchUserProfileEvent>(_mapFetchUserProfileEventToEvent);
    on<UpdateProfilePhotoEvent>(_mapUpdateProfilePhotoEventToEvent);
    on<UpdateProfileEvent>(_mapUpdateProfileEventToState);
    on<UpdateLocalUserProfileEvent>((event, emit) {
      emit(ProfileLoadedState(user: event.user));
    });

    on<GetFaqsEvent>(_mapGetFaqsEventToState);
    on<DeleteAccount>(_mapDeleteAccountEventToState);
    on<BlockAccount>(_mapBlockAccountEventToState);
  }

  FutureOr<void> _mapGetUsernameToState(
      GetUsernameEvent event, Emitter<ProfileState> emit) async {
    var s = await StorageHelper.getString(StorageKeys.username);
    username = s!;
    var firstName = await StorageHelper.getString(StorageKeys.firstname);
    firstname = firstName!;
    emit(UsernameFetchedState(username));
  }

  FutureOr<void> _mapFetchUserProfileEventToEvent(
      FetchUserProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      var state = await profileRepository.fetchUserProfile(event.userId);
      if (state is SuccessState) {
        User user = state.value;
        if (event.userId == null) {
          injector.get<CacheCubit>().updateCachedUserData(user.toCachedUser());
        }
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

  FutureOr<void> _mapUpdateProfileEventToState(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileUpdateLoading());
      var state = await profileRepository.updateProfile(
          email: event.email,
          phone: event.phone,
          gender: event.gender,
          dateOfBirth: event.dateOfBirth,
          ethnicity: event.ethnicity,
          imagePath: event.imagePath,
          country: event.country,
          state: event.state,
          firstNAme: event.firstName,
          lastName: event.lastName);
      if (state is SuccessState) {
        UpdateProfileResponse response = state.value;
        emit(ProfileUpdateLoadedState(updateProfileResponse: response));
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

  FutureOr<void> _mapGetFaqsEventToState(
      GetFaqsEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(GetFaqsLoadingState());
      var state = await profileRepository.getFaqs();
      if (state is SuccessState) {
        emit(GetFaqsSuccessState(state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(GetFaqsFailureState(errorModel.errorMessage));
      }
    } catch (e) {
      emit(GetFaqsFailureState(e.toString()));
    }
  }

  FutureOr<void> _mapDeleteAccountEventToState(
      DeleteAccount event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      var state =
          await profileRepository.deleteAccount(event.reason, event.password);
      if (state is SuccessState) {
        emit(AccountDeleted(message: state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileErrorState(errorModel.errorMessage));
        log(errorModel.errorMessage);
      }
    } catch (e,stack) {
      emit(const ProfileErrorState("An error occurred, please try again"));
      log(e.toString());
      log(stack.toString());

    }
  }

  FutureOr<void> _mapBlockAccountEventToState(
      BlockAccount event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      var state = await profileRepository.blockAccount(event.userId);
      if (state is SuccessState) {
        emit(AccountBlocked(message: state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileErrorState(errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ProfileErrorState("An error occurred, please try again"));
    }
  }
}
