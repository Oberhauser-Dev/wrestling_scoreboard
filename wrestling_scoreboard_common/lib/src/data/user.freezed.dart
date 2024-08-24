// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  Person? get person => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  UserPrivilege get privilege => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) = _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int? id,
      String? email,
      String username,
      String? password,
      Person? person,
      DateTime createdAt,
      UserPrivilege privilege});

  $PersonCopyWith<$Res>? get person;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = null,
    Object? password = freezed,
    Object? person = freezed,
    Object? createdAt = null,
    Object? privilege = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      person: freezed == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      privilege: null == privilege
          ? _value.privilege
          : privilege // ignore: cast_nullable_to_non_nullable
              as UserPrivilege,
    ) as $Val);
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get person {
    if (_value.person == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.person!, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(_$UserImpl value, $Res Function(_$UserImpl) then) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? email,
      String username,
      String? password,
      Person? person,
      DateTime createdAt,
      UserPrivilege privilege});

  @override
  $PersonCopyWith<$Res>? get person;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$UserImpl> implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then) : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = null,
    Object? password = freezed,
    Object? person = freezed,
    Object? createdAt = null,
    Object? privilege = null,
  }) {
    return _then(_$UserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      person: freezed == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      privilege: null == privilege
          ? _value.privilege
          : privilege // ignore: cast_nullable_to_non_nullable
              as UserPrivilege,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl(
      {this.id,
      this.email,
      required this.username,
      this.password,
      this.person,
      required this.createdAt,
      this.privilege = UserPrivilege.none})
      : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) => _$$UserImplFromJson(json);

  @override
  final int? id;
  @override
  final String? email;
  @override
  final String username;
  @override
  final String? password;
  @override
  final Person? person;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final UserPrivilege privilege;

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, password: $password, person: $person, createdAt: $createdAt, privilege: $privilege)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) || other.username == username) &&
            (identical(other.password, password) || other.password == password) &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.privilege, privilege) || other.privilege == privilege));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, username, password, person, createdAt, privilege);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith => __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
      {final int? id,
      final String? email,
      required final String username,
      final String? password,
      final Person? person,
      required final DateTime createdAt,
      final UserPrivilege privilege}) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int? get id;
  @override
  String? get email;
  @override
  String get username;
  @override
  String? get password;
  @override
  Person? get person;
  @override
  DateTime get createdAt;
  @override
  UserPrivilege get privilege;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith => throw _privateConstructorUsedError;
}

SecuredUser _$SecuredUserFromJson(Map<String, dynamic> json) {
  return _SecuredUser.fromJson(json);
}

/// @nodoc
mixin _$SecuredUser {
  int? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  List<int>? get passwordHash => throw _privateConstructorUsedError;
  String? get salt => throw _privateConstructorUsedError;
  Person? get person => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  UserPrivilege get privilege => throw _privateConstructorUsedError;

  /// Serializes this SecuredUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecuredUserCopyWith<SecuredUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecuredUserCopyWith<$Res> {
  factory $SecuredUserCopyWith(SecuredUser value, $Res Function(SecuredUser) then) =
      _$SecuredUserCopyWithImpl<$Res, SecuredUser>;
  @useResult
  $Res call(
      {int? id,
      String? email,
      String username,
      List<int>? passwordHash,
      String? salt,
      Person? person,
      DateTime createdAt,
      UserPrivilege privilege});

  $PersonCopyWith<$Res>? get person;
}

/// @nodoc
class _$SecuredUserCopyWithImpl<$Res, $Val extends SecuredUser> implements $SecuredUserCopyWith<$Res> {
  _$SecuredUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = null,
    Object? passwordHash = freezed,
    Object? salt = freezed,
    Object? person = freezed,
    Object? createdAt = null,
    Object? privilege = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      passwordHash: freezed == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as String?,
      person: freezed == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      privilege: null == privilege
          ? _value.privilege
          : privilege // ignore: cast_nullable_to_non_nullable
              as UserPrivilege,
    ) as $Val);
  }

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res>? get person {
    if (_value.person == null) {
      return null;
    }

    return $PersonCopyWith<$Res>(_value.person!, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SecuredUserImplCopyWith<$Res> implements $SecuredUserCopyWith<$Res> {
  factory _$$SecuredUserImplCopyWith(_$SecuredUserImpl value, $Res Function(_$SecuredUserImpl) then) =
      __$$SecuredUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? email,
      String username,
      List<int>? passwordHash,
      String? salt,
      Person? person,
      DateTime createdAt,
      UserPrivilege privilege});

  @override
  $PersonCopyWith<$Res>? get person;
}

/// @nodoc
class __$$SecuredUserImplCopyWithImpl<$Res> extends _$SecuredUserCopyWithImpl<$Res, _$SecuredUserImpl>
    implements _$$SecuredUserImplCopyWith<$Res> {
  __$$SecuredUserImplCopyWithImpl(_$SecuredUserImpl _value, $Res Function(_$SecuredUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? username = null,
    Object? passwordHash = freezed,
    Object? salt = freezed,
    Object? person = freezed,
    Object? createdAt = null,
    Object? privilege = null,
  }) {
    return _then(_$SecuredUserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      passwordHash: freezed == passwordHash
          ? _value._passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      salt: freezed == salt
          ? _value.salt
          : salt // ignore: cast_nullable_to_non_nullable
              as String?,
      person: freezed == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      privilege: null == privilege
          ? _value.privilege
          : privilege // ignore: cast_nullable_to_non_nullable
              as UserPrivilege,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecuredUserImpl extends _SecuredUser {
  const _$SecuredUserImpl(
      {this.id,
      this.email,
      required this.username,
      final List<int>? passwordHash,
      this.salt,
      this.person,
      required this.createdAt,
      this.privilege = UserPrivilege.none})
      : assert((passwordHash != null && salt != null) || (passwordHash == null && salt == null)),
        _passwordHash = passwordHash,
        super._();

  factory _$SecuredUserImpl.fromJson(Map<String, dynamic> json) => _$$SecuredUserImplFromJson(json);

  @override
  final int? id;
  @override
  final String? email;
  @override
  final String username;
  final List<int>? _passwordHash;
  @override
  List<int>? get passwordHash {
    final value = _passwordHash;
    if (value == null) return null;
    if (_passwordHash is EqualUnmodifiableListView) return _passwordHash;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? salt;
  @override
  final Person? person;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final UserPrivilege privilege;

  @override
  String toString() {
    return 'SecuredUser(id: $id, email: $email, username: $username, passwordHash: $passwordHash, salt: $salt, person: $person, createdAt: $createdAt, privilege: $privilege)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecuredUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) || other.username == username) &&
            const DeepCollectionEquality().equals(other._passwordHash, _passwordHash) &&
            (identical(other.salt, salt) || other.salt == salt) &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.privilege, privilege) || other.privilege == privilege));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, username, const DeepCollectionEquality().hash(_passwordHash),
      salt, person, createdAt, privilege);

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecuredUserImplCopyWith<_$SecuredUserImpl> get copyWith =>
      __$$SecuredUserImplCopyWithImpl<_$SecuredUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecuredUserImplToJson(
      this,
    );
  }
}

abstract class _SecuredUser extends SecuredUser {
  const factory _SecuredUser(
      {final int? id,
      final String? email,
      required final String username,
      final List<int>? passwordHash,
      final String? salt,
      final Person? person,
      required final DateTime createdAt,
      final UserPrivilege privilege}) = _$SecuredUserImpl;
  const _SecuredUser._() : super._();

  factory _SecuredUser.fromJson(Map<String, dynamic> json) = _$SecuredUserImpl.fromJson;

  @override
  int? get id;
  @override
  String? get email;
  @override
  String get username;
  @override
  List<int>? get passwordHash;
  @override
  String? get salt;
  @override
  Person? get person;
  @override
  DateTime get createdAt;
  @override
  UserPrivilege get privilege;

  /// Create a copy of SecuredUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecuredUserImplCopyWith<_$SecuredUserImpl> get copyWith => throw _privateConstructorUsedError;
}
