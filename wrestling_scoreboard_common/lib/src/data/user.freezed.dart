// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int? get id; String? get email; String get username; String? get password; Person? get person; DateTime get createdAt; UserPrivilege get privilege;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.person, person) || other.person == person)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.privilege, privilege) || other.privilege == privilege));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,password,person,createdAt,privilege);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, password: $password, person: $person, createdAt: $createdAt, privilege: $privilege)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int? id, String? email, String username, String? password, Person? person, DateTime createdAt, UserPrivilege privilege
});


$PersonCopyWith<$Res>? get person;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = freezed,Object? username = null,Object? password = freezed,Object? person = freezed,Object? createdAt = null,Object? privilege = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,privilege: null == privilege ? _self.privilege : privilege // ignore: cast_nullable_to_non_nullable
as UserPrivilege,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get person {
    if (_self.person == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.person!, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({this.id, this.email, required this.username, this.password, this.person, required this.createdAt, this.privilege = UserPrivilege.none}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int? id;
@override final  String? email;
@override final  String username;
@override final  String? password;
@override final  Person? person;
@override final  DateTime createdAt;
@override@JsonKey() final  UserPrivilege privilege;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.person, person) || other.person == person)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.privilege, privilege) || other.privilege == privilege));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,password,person,createdAt,privilege);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, password: $password, person: $person, createdAt: $createdAt, privilege: $privilege)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? email, String username, String? password, Person? person, DateTime createdAt, UserPrivilege privilege
});


@override $PersonCopyWith<$Res>? get person;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = freezed,Object? username = null,Object? password = freezed,Object? person = freezed,Object? createdAt = null,Object? privilege = null,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,privilege: null == privilege ? _self.privilege : privilege // ignore: cast_nullable_to_non_nullable
as UserPrivilege,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get person {
    if (_self.person == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.person!, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// @nodoc
mixin _$SecuredUser {

 int? get id; String? get email; String get username; List<int>? get passwordHash; String? get salt; Person? get person; DateTime get createdAt; UserPrivilege get privilege;
/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecuredUserCopyWith<SecuredUser> get copyWith => _$SecuredUserCopyWithImpl<SecuredUser>(this as SecuredUser, _$identity);

  /// Serializes this SecuredUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecuredUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other.passwordHash, passwordHash)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.person, person) || other.person == person)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.privilege, privilege) || other.privilege == privilege));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,const DeepCollectionEquality().hash(passwordHash),salt,person,createdAt,privilege);

@override
String toString() {
  return 'SecuredUser(id: $id, email: $email, username: $username, passwordHash: $passwordHash, salt: $salt, person: $person, createdAt: $createdAt, privilege: $privilege)';
}


}

/// @nodoc
abstract mixin class $SecuredUserCopyWith<$Res>  {
  factory $SecuredUserCopyWith(SecuredUser value, $Res Function(SecuredUser) _then) = _$SecuredUserCopyWithImpl;
@useResult
$Res call({
 int? id, String? email, String username, List<int>? passwordHash, String? salt, Person? person, DateTime createdAt, UserPrivilege privilege
});


$PersonCopyWith<$Res>? get person;

}
/// @nodoc
class _$SecuredUserCopyWithImpl<$Res>
    implements $SecuredUserCopyWith<$Res> {
  _$SecuredUserCopyWithImpl(this._self, this._then);

  final SecuredUser _self;
  final $Res Function(SecuredUser) _then;

/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = freezed,Object? username = null,Object? passwordHash = freezed,Object? salt = freezed,Object? person = freezed,Object? createdAt = null,Object? privilege = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,passwordHash: freezed == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as List<int>?,salt: freezed == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String?,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,privilege: null == privilege ? _self.privilege : privilege // ignore: cast_nullable_to_non_nullable
as UserPrivilege,
  ));
}
/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get person {
    if (_self.person == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.person!, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SecuredUser extends SecuredUser {
  const _SecuredUser({this.id, this.email, required this.username, final  List<int>? passwordHash, this.salt, this.person, required this.createdAt, this.privilege = UserPrivilege.none}): assert((passwordHash != null && salt != null) || (passwordHash == null && salt == null)),_passwordHash = passwordHash,super._();
  factory _SecuredUser.fromJson(Map<String, dynamic> json) => _$SecuredUserFromJson(json);

@override final  int? id;
@override final  String? email;
@override final  String username;
 final  List<int>? _passwordHash;
@override List<int>? get passwordHash {
  final value = _passwordHash;
  if (value == null) return null;
  if (_passwordHash is EqualUnmodifiableListView) return _passwordHash;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? salt;
@override final  Person? person;
@override final  DateTime createdAt;
@override@JsonKey() final  UserPrivilege privilege;

/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecuredUserCopyWith<_SecuredUser> get copyWith => __$SecuredUserCopyWithImpl<_SecuredUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecuredUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecuredUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&const DeepCollectionEquality().equals(other._passwordHash, _passwordHash)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.person, person) || other.person == person)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.privilege, privilege) || other.privilege == privilege));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,const DeepCollectionEquality().hash(_passwordHash),salt,person,createdAt,privilege);

@override
String toString() {
  return 'SecuredUser(id: $id, email: $email, username: $username, passwordHash: $passwordHash, salt: $salt, person: $person, createdAt: $createdAt, privilege: $privilege)';
}


}

/// @nodoc
abstract mixin class _$SecuredUserCopyWith<$Res> implements $SecuredUserCopyWith<$Res> {
  factory _$SecuredUserCopyWith(_SecuredUser value, $Res Function(_SecuredUser) _then) = __$SecuredUserCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? email, String username, List<int>? passwordHash, String? salt, Person? person, DateTime createdAt, UserPrivilege privilege
});


@override $PersonCopyWith<$Res>? get person;

}
/// @nodoc
class __$SecuredUserCopyWithImpl<$Res>
    implements _$SecuredUserCopyWith<$Res> {
  __$SecuredUserCopyWithImpl(this._self, this._then);

  final _SecuredUser _self;
  final $Res Function(_SecuredUser) _then;

/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = freezed,Object? username = null,Object? passwordHash = freezed,Object? salt = freezed,Object? person = freezed,Object? createdAt = null,Object? privilege = null,}) {
  return _then(_SecuredUser(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,passwordHash: freezed == passwordHash ? _self._passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as List<int>?,salt: freezed == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String?,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,privilege: null == privilege ? _self.privilege : privilege // ignore: cast_nullable_to_non_nullable
as UserPrivilege,
  ));
}

/// Create a copy of SecuredUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get person {
    if (_self.person == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.person!, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}

// dart format on
