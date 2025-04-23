// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BasicAuthService _$BasicAuthServiceFromJson(Map<String, dynamic> json) =>
    _BasicAuthService(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$BasicAuthServiceToJson(_BasicAuthService instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

_BearerAuthService _$BearerAuthServiceFromJson(Map<String, dynamic> json) =>
    _BearerAuthService(
      token: json['token'] as String,
    );

Map<String, dynamic> _$BearerAuthServiceToJson(_BearerAuthService instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
