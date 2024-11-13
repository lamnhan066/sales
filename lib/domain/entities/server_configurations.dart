import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Cấu hình cho Postgres
class ServerConfigurations with EquatableMixin {

  /// Cấu hình cho Postgres
  const ServerConfigurations({
    this.host = '',
    this.database = '',
    this.username = '',
    this.password = '',
  });

  /// Map -> PostgresConfigurations
  factory ServerConfigurations.fromMap(Map<String, dynamic> map) {
    return ServerConfigurations(
      host: map['host'] as String,
      database: map['database'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  /// JSON -> PostgresConfigurations
  factory ServerConfigurations.fromJson(String source) => ServerConfigurations.fromMap(
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
  ServerConfigurations copyWith({
    String? host,
    String? database,
    String? username,
    String? password,
  }) {
    return ServerConfigurations(
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
