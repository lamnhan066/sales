import 'dart:convert';

class PostgresSettings {
  final String host;
  final String database;
  final String username;
  final String password;

  PostgresSettings({
    required this.host,
    required this.database,
    required this.username,
    required this.password,
  });

  PostgresSettings copyWith({
    String? host,
    String? database,
    String? username,
    String? password,
  }) {
    return PostgresSettings(
      host: host ?? this.host,
      database: database ?? this.database,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'database': database,
      'username': username,
      'password': password,
    };
  }

  factory PostgresSettings.fromMap(Map<String, dynamic> map) {
    return PostgresSettings(
      host: map['host'] ?? '',
      database: map['database'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostgresSettings.fromJson(String source) =>
      PostgresSettings.fromMap(json.decode(source));
}
