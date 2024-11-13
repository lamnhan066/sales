import 'dart:convert';

import 'package:sales/core/utils/entropy_generator.dart';
import 'package:sales/domain/entities/credentials.dart';

class LoginCredentials implements Credentials {

  /// Thông tin đăng nhập.
  ///
  /// Khi tạo mới [LoginCredentials] thì entropy sẽ được tự động tạo nếu nó bị
  /// bỏ trống.
  LoginCredentials({
    required this.username,
    required this.password,
    String? entropy,
    this.rememberMe = false,
  }) : entropy = entropy ?? EntropyGenerator.generateEntropy();

  factory LoginCredentials.fromMap(Map<String, dynamic> map) {
    return LoginCredentials(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      entropy: map['entropy'] ?? '',
      rememberMe: map['rememberMe'] ?? false,
    );
  }

  factory LoginCredentials.fromJson(String source) => LoginCredentials.fromMap(json.decode(source));
  @override
  final String username;
  @override
  final String password;
  @override
  final String entropy;
  final bool rememberMe;

  LoginCredentials copyWith({
    String? username,
    String? password,
    String? entropy,
    bool? rememberMe,
  }) {
    return LoginCredentials(
      username: username ?? this.username,
      password: password ?? this.password,
      entropy: entropy ?? this.entropy,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'entropy': entropy,
      'rememberMe': rememberMe,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'LoginCredentials(username: $username, password: $password, entropy: $entropy, rememberMe: $rememberMe)';
  }
}
