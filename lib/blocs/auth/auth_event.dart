part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable{}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegisterEvent({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];

}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];

}

