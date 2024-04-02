import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization.freezed.dart';

part 'authorization.g.dart';

abstract class AuthService {}

@freezed
class BasicAuthService with _$BasicAuthService implements AuthService {
  const BasicAuthService._();

  const factory BasicAuthService({
    required String username,
    required String password,
  }) = _BasicAuthService;

  factory BasicAuthService.fromJson(Map<String, Object?> json) => _$BasicAuthServiceFromJson(json);

  Map<String, String> get header {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    return {'authorization': basicAuth};
  }
}
