import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_common/common.dart';

Future<Map<String, String>> getAuthHeaders(String apiUrl) async {
  final defaultHeaders = {'Content-Type': 'application/json'};

  Future<String> signIn(BasicAuthService authService) async {
    final uri = Uri.parse('$apiUrl/auth/sign_in');
    final response = await http.post(uri, headers: {...authService.header, ...defaultHeaders});
    return response.body;
  }

  final token = await signIn(BasicAuthService(username: 'admin', password: 'admin'));

  return {'Content-Type': 'application/json', ...BearerAuthService(token: token).header};
}
