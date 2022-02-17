import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String username = '';
  String firstname = '';

  ProfileBloc() : super(ProfileInitial()) {
    on<GetUsernameEvent>(_mapGetUsernameToState);
  }

  FutureOr<void> _mapGetUsernameToState(
      GetUsernameEvent event, Emitter<ProfileState> emit) async {
    var s = await StorageHelper.getString(StorageKeys.username);
    username = s!;
    var firstName = await StorageHelper.getString(StorageKeys.firstname);
    firstname = firstName!;
    emit(UsernameFetchedState(username));
  }
}
