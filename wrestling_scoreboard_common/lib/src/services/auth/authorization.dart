import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'authorization.freezed.dart';

part 'authorization.g.dart';

abstract class AuthService {
  Map<String, String> get header;
}

@freezed
abstract class BasicAuthService with _$BasicAuthService implements AuthService {
  const BasicAuthService._();

  const factory BasicAuthService({
    required String username,
    required String password,
  }) = _BasicAuthService;

  factory BasicAuthService.fromJson(Map<String, Object?> json) => _$BasicAuthServiceFromJson(json);

  @override
  Map<String, String> get header {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    return {'authorization': basicAuth};
  }

  factory BasicAuthService.fromHeader(String authHeader) {
    final parts = authHeader.split(' ');
    if (parts.length != 2 || parts[0] != 'Basic') {
      throw Exception('Auth header is not valid');
    }
    final String decoded = utf8.decode(base64.decode(parts[1]));
    final credentials = decoded.split(':');
    return BasicAuthService(username: credentials[0], password: credentials[1]);
  }
}

@freezed
abstract class BearerAuthService with _$BearerAuthService implements AuthService {
  const BearerAuthService._();

  const factory BearerAuthService({
    required String token,
  }) = _BearerAuthService;

  factory BearerAuthService.fromJson(Map<String, Object?> json) => _$BearerAuthServiceFromJson(json);

  @override
  Map<String, String> get header {
    String bearer = 'Bearer $token';
    return {'authorization': bearer};
  }

  factory BearerAuthService.fromHeader(String authHeader) {
    final parts = authHeader.split(' ');
    if (parts.length != 2 || parts[0] != 'Bearer') {
      throw Exception('Auth header is not valid');
    }

    return BearerAuthService(token: parts[1]);
  }
}

class HttpException implements Exception {
  String message;
  Response? response;

  HttpException(this.message, {this.response});

  @override
  String toString() {
    return '$message\n${response?.reasonPhrase ?? response?.statusCode ?? ''}';
  }
}
