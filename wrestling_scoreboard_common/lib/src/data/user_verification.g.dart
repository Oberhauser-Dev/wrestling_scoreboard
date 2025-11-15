// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserVerification _$UserVerificationFromJson(Map<String, dynamic> json) => _UserVerification(
  username: json['username'] as String,
  verificationCode: json['verificationCode'] as String,
  method: $enumDecode(_$VerificationMethodEnumMap, json['method']),
);

Map<String, dynamic> _$UserVerificationToJson(_UserVerification instance) => <String, dynamic>{
  'username': instance.username,
  'verificationCode': instance.verificationCode,
  'method': _$VerificationMethodEnumMap[instance.method]!,
};

const _$VerificationMethodEnumMap = {VerificationMethod.email: 'email', VerificationMethod.sms: 'sms'};
