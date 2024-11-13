abstract class Credentials {

  Credentials({required this.username, required this.password, required this.entropy});
  final String username;
  final String password;
  final String entropy;
}
