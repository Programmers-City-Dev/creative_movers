import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
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
        emit(ProfileLoadedState(user: state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ProfileErrorState(errorModel.errorMessage));
      }
    } catch (e) {
      emit(const ProfileErrorState(
          "Oops! Something went wrong, please try agin"));
    }
  }
}
