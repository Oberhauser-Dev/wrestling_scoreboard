// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserVerification {

 String get username; String get verificationCode; VerificationMethod get method;
/// Create a copy of UserVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserVerificationCopyWith<UserVerification> get copyWith => _$UserVerificationCopyWithImpl<UserVerification>(this as UserVerification, _$identity);

  /// Serializes this UserVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserVerification&&(identical(other.username, username) || other.username == username)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,verificationCode,method);

@override
String toString() {
  return 'UserVerification(username: $username, verificationCode: $verificationCode, method: $method)';
}


}

/// @nodoc
abstract mixin class $UserVerificationCopyWith<$Res>  {
  factory $UserVerificationCopyWith(UserVerification value, $Res Function(UserVerification) _then) = _$UserVerificationCopyWithImpl;
@useResult
$Res call({
 String username, String verificationCode, VerificationMethod method
});




}
/// @nodoc
class _$UserVerificationCopyWithImpl<$Res>
    implements $UserVerificationCopyWith<$Res> {
  _$UserVerificationCopyWithImpl(this._self, this._then);

  final UserVerification _self;
  final $Res Function(UserVerification) _then;

/// Create a copy of UserVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? verificationCode = null,Object? method = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as VerificationMethod,
  ));
}

}


/// Adds pattern-matching-related methods to [UserVerification].
extension UserVerificationPatterns on UserVerification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserVerification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserVerification value)  $default,){
final _that = this;
switch (_that) {
case _UserVerification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserVerification value)?  $default,){
final _that = this;
switch (_that) {
case _UserVerification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String verificationCode,  VerificationMethod method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserVerification() when $default != null:
return $default(_that.username,_that.verificationCode,_that.method);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String verificationCode,  VerificationMethod method)  $default,) {final _that = this;
switch (_that) {
case _UserVerification():
return $default(_that.username,_that.verificationCode,_that.method);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String verificationCode,  VerificationMethod method)?  $default,) {final _that = this;
switch (_that) {
case _UserVerification() when $default != null:
return $default(_that.username,_that.verificationCode,_that.method);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserVerification extends UserVerification {
  const _UserVerification({required this.username, required this.verificationCode, required this.method}): super._();
  factory _UserVerification.fromJson(Map<String, dynamic> json) => _$UserVerificationFromJson(json);

@override final  String username;
@override final  String verificationCode;
@override final  VerificationMethod method;

/// Create a copy of UserVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserVerificationCopyWith<_UserVerification> get copyWith => __$UserVerificationCopyWithImpl<_UserVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserVerification&&(identical(other.username, username) || other.username == username)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,verificationCode,method);

@override
String toString() {
  return 'UserVerification(username: $username, verificationCode: $verificationCode, method: $method)';
}


}

/// @nodoc
abstract mixin class _$UserVerificationCopyWith<$Res> implements $UserVerificationCopyWith<$Res> {
  factory _$UserVerificationCopyWith(_UserVerification value, $Res Function(_UserVerification) _then) = __$UserVerificationCopyWithImpl;
@override @useResult
$Res call({
 String username, String verificationCode, VerificationMethod method
});




}
/// @nodoc
class __$UserVerificationCopyWithImpl<$Res>
    implements _$UserVerificationCopyWith<$Res> {
  __$UserVerificationCopyWithImpl(this._self, this._then);

  final _UserVerification _self;
  final $Res Function(_UserVerification) _then;

/// Create a copy of UserVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? verificationCode = null,Object? method = null,}) {
  return _then(_UserVerification(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as VerificationMethod,
  ));
}


}

// dart format on
