import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Cấu hình cho Postgres
class PostgresConfigurations with EquatableMixin {

  /// Cấu hình cho Postgres
  PostgresConfigurations({
    required this.host,
    required this.database,
    required this.username,
    required this.password,
  });

  /// Map -> PostgresConfigurations
  factory PostgresConfigurations.fromMap(Map<String, dynamic> map) {
    return PostgresConfigurations(
      host: map['host'] as String,
      database: map['database'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  /// JSON -> PostgresConfigurations
  factory PostgresConfigurations.fromJson(String source) => PostgresConfigurations.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
  /// Host.
  final String host;

  /// Database.
  final String database;

  /// Username.
  final String username;

  /// Password.
  final String password;

  /// Sao chép.
  PostgresConfigurations copyWith({
    String? host,
    String? database,
    String? username,
    String? password,
  }) {
    return PostgresConfigurations(
      host: host ?? this.host,
      database: database ?? this.database,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  /// Order -> Map
  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'database': database,
      'username': username,
      'password': password,
    };
  }

  /// Order -> Map
  String toJson() => json.encode(toMap());

  @override
  List<Object> get props => [host, database, username, password];
}
