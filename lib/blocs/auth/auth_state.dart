part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

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

//Bio-Data State
class BioDataLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class BioDataSuccesState extends AuthState {
  final BioDataResponse bioDataResponse;

  BioDataSuccesState({required this.bioDataResponse});

  @override
  // TODO: implement props
  List<Object?> get props => [bioDataResponse];
}

class BioDataFailureState extends AuthState {
  final String error;

  BioDataFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

//Account Type State
class AccounTypeLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AccountTypeSuccesState extends AuthState {
  final AccountTypeResponse accountTypeResponse;

  AccountTypeSuccesState({required this.accountTypeResponse});

  @override
  // TODO: implement props
  List<Object?> get props => [accountTypeResponse];
}

class AccountTypeFailureState extends AuthState {
  final String error;

  AccountTypeFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

//AddConnections  State
class AddConnectionLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddConnectionSuccesState extends AuthState {
  final AddConnectionResponse addConnectionResponse;

  AddConnectionSuccesState({required this.addConnectionResponse});

  @override
  // TODO: implement props
  List<Object?> get props => [addConnectionResponse];
}

class AddConnectionFailureState extends AuthState {
  final String error;

  AddConnectionFailureState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

//Logout
class LogoutLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LogoutSuccessState extends AuthState {
  final LogoutResponse logoutResponse;

  LogoutSuccessState({required this.logoutResponse});

  @override
  // TODO: implement props
  List<Object?> get props => [logoutResponse];
}

class LogoutFaliureState extends AuthState {
  String error;

  @override
  // TODO: implement props
  List<Object?> get props => [error];

  LogoutFaliureState({required this.error});
}

//Logout
class CategoryLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CategorySuccessState extends AuthState {
  final CategoriesResponse categoriesReponse;

  CategorySuccessState({required this.categoriesReponse});

  @override
  // TODO: implement props
  List<Object?> get props => [categoriesReponse];
}

class CategoryFaliureState extends AuthState {
  String error;

  @override
  // TODO: implement props
  List<Object?> get props => [error];

  CategoryFaliureState({required this.error});
}
