import 'dart:async';
import 'dart:core';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:creative_movers/models/account_type_response.dart';
import 'package:creative_movers/models/addconnection_response.dart';
import 'package:creative_movers/models/biodata_response.dart';
import 'package:creative_movers/models/logout_response.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:creative_movers/repository/remote/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

  FutureOr<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoginLoadingState());
      var state = await authRepository.login(
          email: event.email, password: event.password);
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
      var state = await authRepository.post_biodata(
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
          est_capital: event.est_capital,
          max_range: event.max_range,
          min_range: event.min_range,
          name: event.name,
          photo: event.photo,
          stage: event.stage,
          user_id: event.user_id);
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
      // TODO
    }
  }

  FutureOr<void> _mapCategoriesEventToState(
      CategoriesEvent event, Emitter<AuthState> emit) async{

    emit(CategoryLoadingState());
    try {
    var state = await authRepository.fetch_categories();
    if (state is SuccessState) {
    emit (CategorySuccessState(categoriesReponse: state.value));
    } else if (state is ErrorState) {
    ServerErrorModel errorModel = state.value;
    emit(CategoryFaliureState(error: errorModel.errorMessage));
    }
    } catch (e) {

    emit(CategoryFaliureState(error: 'Oops Something went wrong'));
    // TODO
    }
    }



}
