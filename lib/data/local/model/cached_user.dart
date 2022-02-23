import 'dart:convert';

import 'package:equatable/equatable.dart';

class CacheUser extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const CacheUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [id, firstName, lastName];

  CacheUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
  }) {
    return CacheUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory CacheUser.fromMap(Map<String, dynamic> map) {
    return CacheUser(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CacheUser.fromJson(String source) => CacheUser.fromMap(json.decode(source));

  @override
  String toString() => 'CachedUser(id: $id, firstName: $firstName, lastName: $lastName)';
}
