import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  User({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  User copyWith({
    String? username,
    String? password,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [username, password];
}
