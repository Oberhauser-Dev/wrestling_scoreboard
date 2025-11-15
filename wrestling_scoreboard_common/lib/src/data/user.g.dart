// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  username: json['username'] as String,
  password: json['password'] as String?,
  person: json['person'] == null ? null : Person.fromJson(json['person'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  privilege: $enumDecodeNullable(_$UserPrivilegeEnumMap, json['privilege']) ?? UserPrivilege.none,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'isEmailVerified': instance.isEmailVerified,
  'username': instance.username,
  'password': instance.password,
  'person': instance.person?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'privilege': _$UserPrivilegeEnumMap[instance.privilege]!,
};

const _$UserPrivilegeEnumMap = {
  UserPrivilege.none: 'none',
  UserPrivilege.read: 'read',
  UserPrivilege.write: 'write',
  UserPrivilege.admin: 'admin',
};

_SecuredUser _$SecuredUserFromJson(Map<String, dynamic> json) => _SecuredUser(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  emailVerificationCode: json['emailVerificationCode'] as String?,
  emailVerificationCodeExpirationDate:
      json['emailVerificationCodeExpirationDate'] == null
          ? null
          : DateTime.parse(json['emailVerificationCodeExpirationDate'] as String),
  username: json['username'] as String,
  passwordHash: (json['passwordHash'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
  salt: json['salt'] as String?,
  person: json['person'] == null ? null : Person.fromJson(json['person'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  privilege: $enumDecodeNullable(_$UserPrivilegeEnumMap, json['privilege']) ?? UserPrivilege.none,
);

Map<String, dynamic> _$SecuredUserToJson(_SecuredUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'isEmailVerified': instance.isEmailVerified,
  'emailVerificationCode': instance.emailVerificationCode,
  'emailVerificationCodeExpirationDate': instance.emailVerificationCodeExpirationDate?.toIso8601String(),
  'username': instance.username,
  'passwordHash': instance.passwordHash,
  'salt': instance.salt,
  'person': instance.person?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'privilege': _$UserPrivilegeEnumMap[instance.privilege]!,
};
