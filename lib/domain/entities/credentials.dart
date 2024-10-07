abstract class Credentials {
  final String username;
  final String password;
  final String entropy;

  Credentials({required this.username, required this.password, required this.entropy});
}
