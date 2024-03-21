import 'dart:convert';

abstract class AuthService {}

class BasicAuthService extends AuthService {
  final String username;
  final String password;

  BasicAuthService({required this.username, required this.password});

  Map<String, String> get header {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    return {'authorization': basicAuth};
  }
}
