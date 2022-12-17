import 'package:equatable/equatable.dart';

class ServerErrorModel extends Equatable {
  final int statusCode;
  final String errorMessage;
  final dynamic data;

  const ServerErrorModel(
      {required this.statusCode, required this.errorMessage, this.data});

  @override
  List<Object> get props => [errorMessage];

  @override
  bool get stringify => true;
}
