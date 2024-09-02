import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'user.freezed.dart';
part 'user.g.dart';

abstract class AbstractUser implements DataObject {
  String? get email;

  String get username;

  Person? get person;
}

@freezed
class User with _$User implements AbstractUser {
  const User._();

  const factory User({
    int? id,
    String? email,
    required String username,
    String? password,
    Person? person,
    required DateTime createdAt,
    @Default(UserPrivilege.none) UserPrivilege privilege,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  static Future<User> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final personId = e['personId'] as int?;
    final privilege = e['privilege'] as String;
    return User(
      id: e['id'] as int?,
      email: e['email'] as String?,
      username: e['username'] as String,
      password: e['password'] as String?,
      person: personId == null ? null : await getSingle<Person>(personId),
      createdAt: e['created_at'] as DateTime,
      privilege: UserPrivilege.values.byName(privilege),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (person != null) 'person_id': person!.id!,
      if (email != null) 'email': email!,
      'username': username,
      if (password != null) 'password': password,
      'created_at': createdAt,
      'privilege': privilege.name,
    };
  }

  /// Create a secured user, with a salted and hashed password.
  SecuredUser toSecuredUser() {
    var (List<int>? passwordHash, String? salt) = (null, null);
    if (password != null) {
      (passwordHash, salt) = _hashAndSaltPassword(password: password!);
    }
    return SecuredUser(
      id: id,
      passwordHash: passwordHash,
      salt: salt,
      username: username,
      email: email,
      person: person,
      createdAt: createdAt,
      privilege: privilege,
    );
  }

  @override
  String get tableName => 'user';

  @override
  User copyWithId(int? id) {
    return copyWith(id: id);
  }
}

/// Returns the hashed password and a random salt from a given password.
(List<int>, String) _hashAndSaltPassword({required String password, int saltLength = 4}) {
  final random = Random();
  final salt = base64.encode(List.generate(saltLength, (i) => random.nextInt(256)));
  return (SecuredUser.hashPassword(password: password, salt: salt), salt);
}

/// User object to use e.g. on a server
@freezed
class SecuredUser with _$SecuredUser implements AbstractUser {
  const SecuredUser._();

  @Assert('(passwordHash != null && salt != null) || (passwordHash == null && salt == null)')
  const factory SecuredUser({
    int? id,
    String? email,
    required String username,
    List<int>? passwordHash,
    String? salt,
    Person? person,
    required DateTime createdAt,
    @Default(UserPrivilege.none) UserPrivilege privilege,
  }) = _SecuredUser;

  factory SecuredUser.fromJson(Map<String, Object?> json) => _$SecuredUserFromJson(json);

  static Future<SecuredUser> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final personId = e['personId'] as int?;
    final privilege = e['privilege'] as String;
    return SecuredUser(
      id: e['id'] as int?,
      email: e['email'] as String?,
      username: e['username'] as String,
      passwordHash: e['password_hash'] as List<int>?,
      salt: e['salt'] as String?,
      person: personId == null ? null : await getSingle<Person>(personId),
      createdAt: e['created_at'] as DateTime,
      privilege: UserPrivilege.values.byName(privilege),
    );
  }

  SecuredUser changePassword(String password) {
    final (passwordHash, salt) = _hashAndSaltPassword(password: password);
    return copyWith(
      passwordHash: passwordHash,
      salt: salt,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (person != null) 'person_id': person!.id!,
      if (email != null) 'email': email!,
      'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (salt != null) 'salt': salt,
      'created_at': createdAt,
      'privilege': privilege.name,
    };
  }

  @override
  String get tableName => 'secured_user';

  @override
  SecuredUser copyWithId(int? id) {
    return copyWith(id: id);
  }

  User toUser() {
    return User(
      id: id,
      username: username,
      email: email,
      person: person,
      createdAt: createdAt,
      privilege: privilege,
    );
  }

  static List<int> hashPassword({required String password, required String salt}) {
    final saltedPassword = salt + password;
    final bytes = utf8.encode(saltedPassword);
    return sha256.convert(bytes).bytes;
  }

  bool checkPassword(String password) {
    if (salt == null) return false;
    final givenHash = hashPassword(password: password, salt: salt!);
    return ListEquality().equals(givenHash, passwordHash);
  }
}
