import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:creative_movers/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = AuthRepository(HttpHelper());

  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_mapRegisterEventToState);
    on<LoginEvent>(_mapLoginEventToState);
  }

  FutureOr<void> _mapRegisterEventToState(
      RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(RegistrationLoadingState());
      var state = await authRepository.register(
          email: event.email,
          password: event.password,
          username: event.username);
      if (state is SuccessState) {
        emit(RegistrationSuccessState(response: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(RegistrationFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(RegistrationFailureState(error: "Oops! Something went wrong."));
    }
  }

  FutureOr<void> _mapLoginEventToState(LoginEvent event, Emitter<AuthState> emit) async{
    try {
      emit(LoginLoadingState());
      var state = await authRepository.login(
          email: event.email,
          password: event.password);
      if (state is SuccessState) {
        emit(LoginSuccessState(response: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(LoginFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(LoginFailureState(error: "Oops! Something went wrong."));
    }
  }
}
