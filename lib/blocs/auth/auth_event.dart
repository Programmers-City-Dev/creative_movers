part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegisterEvent(
      {required this.username, required this.email, required this.password});

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

class BioDataEvent extends AuthEvent {
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String biodata;
  String? image;

  @override
  // TODO: implement props
  List<Object?> get props => [firstname, lastname, phoneNumber, biodata, image];

  BioDataEvent(
      {required this.firstname,
      required this.lastname,
      required this.phoneNumber,
      required this.biodata,
      this.image});
}

//_____Account Type Event____

class AccountTypeEvent extends AuthEvent {
  final String? role;
  final String? user_id;
  final String? name;
  final String? stage;
  final String? category;
  final String? est_capital;
  final String? description;
  final String? photo;
  final String? max_range;
  final String? min_range;

  @override
  // TODO: implement props
  List<Object?> get props => [
        role,
        user_id,
        name,
        stage,
        category,
        est_capital,
        description,
        photo,
        max_range,
        min_range
      ];

  AccountTypeEvent({
    this.role,
    this.user_id,
    this.name,
    this.stage,
    this.category,
    this.est_capital,
    this.description,
    this.photo,
    this.max_range,
    this.min_range,
  });
}

class AddConnectionsEvent extends AuthEvent {
  final String? user_id;
  final List<Connect> connection;

  @override
  // TODO: implement props
  List<Object?> get props => [user_id, connection];

  AddConnectionsEvent({this.user_id, required this.connection});
}

class LogoutEvent extends AuthEvent{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
