import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:creative_movers/data/remote/model/account_type_response.dart';
import 'package:creative_movers/data/remote/model/addconnection_response.dart';
import 'package:creative_movers/data/remote/model/biodata_response.dart';
import 'package:creative_movers/data/remote/model/categories.dart';
import 'package:creative_movers/data/remote/model/confirm_token_response.dart';
import 'package:creative_movers/data/remote/model/forgot_password_response.dart';
import 'package:creative_movers/data/remote/model/logout_response.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/reset_password_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/repository/auth_repository.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/services/push_notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = AuthRepository(HttpHelper());

  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_mapRegisterEventToState);
    on<LoginEvent>(_mapLoginEventToState);
    on<BioDataEvent>(_mapBioDataEventToState);
    on<AccountTypeEvent>(_mapAccountTypeEventToState);
    on<AddConnectionsEvent>(_mapAddConnectionsEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
    on<CategoriesEvent>(_mapCategoriesEventToState);
    on<ForgotPasswordEvent>(_mapForgotPasswordEventToState);
    on<ResetPasswordEvent>(_mapResetPasswordEventToState);
    on<ConfirmTokenEvent>(_mapConfirmTokenEventToState);
  }

  FutureOr<void> _mapRegisterEventToState(
      RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(RegistrationLoadingState());
      var deviceToken = await PushNotificationService.getDeviceToken();
      var platform = Platform.isAndroid ? "android" : "ios";
      var state = await authRepository.register(
          email: event.email,
          password: event.password,
          username: event.username,
          deviceToken: deviceToken,
          platform: platform);
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

  FutureOr<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoginLoadingState());
      var deviceToken = await PushNotificationService.getDeviceToken();
      var platform = Platform.isAndroid ? "android" : "ios";
      var state = await authRepository.login(
          email: event.email,
          password: event.password,
          deviceToken: deviceToken,
          platform: platform);
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

  FutureOr<void> _mapBioDataEventToState(
      BioDataEvent event, Emitter<AuthState> emit) async {
    emit(BioDataLoadingState());
    try {
      var state = await authRepository.postBiodata(
          firstname: event.firstname,
          lastname: event.lastname,
          phoneNumber: event.phoneNumber,
          biodata: event.biodata,
          image: event.image);
      if (state is SuccessState) {
        emit(BioDataSuccesState(
          bioDataResponse: state.value,
        ));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(BioDataFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(BioDataFailureState(error: "Oops! Something went wrong. "));
    }
  }

  Future<FutureOr<void>> _mapAccountTypeEventToState(
      AccountTypeEvent event, Emitter<AuthState> emit) async {
    emit(AccounTypeLoadingState());
    try {
      var state = await authRepository.post_account_type(
          role: event.role,
          category: event.category,
          description: event.description,
          est_capital: event.estCapital,
          max_range: event.max_range,
          min_range: event.min_range,
          name: event.name,
          photo: event.photo,
          stage: event.stage,
          user_id: event.userId);
      if (state is SuccessState) {
        emit(AccountTypeSuccesState(
          accountTypeResponse: state.value,
        ));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(AccountTypeFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(AccountTypeFailureState(error: "Oops! Something went wrong."));
    }
  }

  FutureOr<void> _mapAddConnectionsEventToState(
      AddConnectionsEvent event, Emitter<AuthState> emit) async {
    emit(AddConnectionLoadingState());
    try {
      var state = await authRepository.add_connections(
          user_id: event.user_id, connections: event.connection);
      if (state is SuccessState) {
        emit(AddConnectionSuccesState(
          addConnectionResponse: state.value,
        ));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(AddConnectionFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(AddConnectionFailureState(error: "Oops! Something went wrong."));
    }
  }

  FutureOr<void> _mapLogoutEventToState(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoadingState());
    try {
      var state = await authRepository.logout();
      if (state is SuccessState) {
        emit(LogoutSuccessState(logoutResponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(LogoutFaliureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(LogoutFaliureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapCategoriesEventToState(
      CategoriesEvent event, Emitter<AuthState> emit) async {
    emit(CategoryLoadingState());
    try {
      var state = await authRepository.fetch_categories();
      if (state is SuccessState) {
        emit(CategorySuccessState(categoriesReponse: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(CategoryFaliureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(CategoryFaliureState(error: 'Oops Something went wrong'));
    }
  }

  Future<FutureOr<void>> _mapForgotPasswordEventToState(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoadingState());
    try {
      var state = await authRepository.forgot_password(event.email);
      if (state is SuccessState) {
        emit(ForgotPasswordSuccessState(response: state.value));
      }
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ForgotPasswordFailureState(error: errorModel.data));
      }
    } catch (e) {
      emit(ForgotPasswordFailureState(error: 'Oops Something went wrong '));
    }
  }

  FutureOr<void> _mapResetPasswordEventToState(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResetPasswordLoadingState());
    try {
      var state = await authRepository.reset_password(
          email: event.email,
          password: event.password,
          password_confirmation: event.password_confirmation);
      if (state is SuccessState) {
        emit(ResetPasswordSuccessState(response: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ResetPasswordFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(ResetPasswordFailureState(error: 'Oops Something went wrong'));
    }
  }

  FutureOr<void> _mapConfirmTokenEventToState(
      ConfirmTokenEvent event, Emitter<AuthState> emit) async {
    emit(ConfirmTokenLoadingState());
    try {
      var state = await authRepository.confirm_token(event.token);
      if (state is SuccessState) {
        emit(ConfirmTokenSuccessState(response: state.value));
      } else if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(ConfirmTokenFailureState(error: errorModel.errorMessage));
      }
    } catch (e) {
      emit(ConfirmTokenFailureState(error: 'Oops Something went wrong'));
    }
  }
}
