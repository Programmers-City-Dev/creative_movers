import 'package:equatable/equatable.dart';

class EthnicityModel extends Equatable {
  final String title;
  final List<String> values;

  const EthnicityModel({required this.title, required this.values});

  @override
  List<Object> get props => [title];
}
