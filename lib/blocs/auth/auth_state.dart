part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable{}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegistrationLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegistrationSuccessState extends AuthState {
  final AuthResponse response;

  RegistrationSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class RegistrationFailureState extends AuthState {
  final String error;

  RegistrationFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

// Login states
class LoginSuccessState extends AuthState {
  final AuthResponse response;

  LoginSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoginFailureState extends AuthState {
  final String error;

  LoginFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}