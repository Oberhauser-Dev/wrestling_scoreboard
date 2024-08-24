// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BasicAuthServiceImpl _$$BasicAuthServiceImplFromJson(Map<String, dynamic> json) => _$BasicAuthServiceImpl(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$BasicAuthServiceImplToJson(_$BasicAuthServiceImpl instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

_$BearerAuthServiceImpl _$$BearerAuthServiceImplFromJson(Map<String, dynamic> json) => _$BearerAuthServiceImpl(
      token: json['token'] as String,
    );

Map<String, dynamic> _$$BearerAuthServiceImplToJson(_$BearerAuthServiceImpl instance) => <String, dynamic>{
      'token': instance.token,
    };
