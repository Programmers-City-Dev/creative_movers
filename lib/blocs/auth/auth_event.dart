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
  final String? userId;
  final String? name;
  final String? stage;
  final List<String>? category;
  final String? estCapital;
  final String? description;
  final String? photo;
  final String? max_range;
  final String? min_range;

  @override
  // TODO: implement props
  List<Object?> get props => [
        role,
        userId,
        name,
        stage,
        category,
        estCapital,
        description,
        photo,
        max_range,
        min_range
      ];

  AccountTypeEvent({
    this.role,
    this.userId,
    this.name,
    this.stage,
    this.category,
    this.estCapital,
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
  List<Object?> get props => [user_id, connection];

  AddConnectionsEvent({this.user_id, required this.connection});
}

class CategoriesEvent extends AuthEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

class ConfirmTokenEvent extends AuthEvent {
  final String token;

  ConfirmTokenEvent({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String password_confirmation;
  final String email;

  ResetPasswordEvent({
    required this.password_confirmation,
    required this.password,
    required this.email,
  });

  @override
  List<Object?> get props => [password_confirmation, password];
}
