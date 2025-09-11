// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authorization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BasicAuthService {

 String get username; String get password;
/// Create a copy of BasicAuthService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasicAuthServiceCopyWith<BasicAuthService> get copyWith => _$BasicAuthServiceCopyWithImpl<BasicAuthService>(this as BasicAuthService, _$identity);

  /// Serializes this BasicAuthService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasicAuthService&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'BasicAuthService(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class $BasicAuthServiceCopyWith<$Res>  {
  factory $BasicAuthServiceCopyWith(BasicAuthService value, $Res Function(BasicAuthService) _then) = _$BasicAuthServiceCopyWithImpl;
@useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class _$BasicAuthServiceCopyWithImpl<$Res>
    implements $BasicAuthServiceCopyWith<$Res> {
  _$BasicAuthServiceCopyWithImpl(this._self, this._then);

  final BasicAuthService _self;
  final $Res Function(BasicAuthService) _then;

/// Create a copy of BasicAuthService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BasicAuthService].
extension BasicAuthServicePatterns on BasicAuthService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasicAuthService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasicAuthService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasicAuthService value)  $default,){
final _that = this;
switch (_that) {
case _BasicAuthService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasicAuthService value)?  $default,){
final _that = this;
switch (_that) {
case _BasicAuthService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasicAuthService() when $default != null:
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password)  $default,) {final _that = this;
switch (_that) {
case _BasicAuthService():
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password)?  $default,) {final _that = this;
switch (_that) {
case _BasicAuthService() when $default != null:
return $default(_that.username,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasicAuthService extends BasicAuthService {
  const _BasicAuthService({required this.username, required this.password}): super._();
  factory _BasicAuthService.fromJson(Map<String, dynamic> json) => _$BasicAuthServiceFromJson(json);

@override final  String username;
@override final  String password;

/// Create a copy of BasicAuthService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasicAuthServiceCopyWith<_BasicAuthService> get copyWith => __$BasicAuthServiceCopyWithImpl<_BasicAuthService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasicAuthServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasicAuthService&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'BasicAuthService(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class _$BasicAuthServiceCopyWith<$Res> implements $BasicAuthServiceCopyWith<$Res> {
  factory _$BasicAuthServiceCopyWith(_BasicAuthService value, $Res Function(_BasicAuthService) _then) = __$BasicAuthServiceCopyWithImpl;
@override @useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class __$BasicAuthServiceCopyWithImpl<$Res>
    implements _$BasicAuthServiceCopyWith<$Res> {
  __$BasicAuthServiceCopyWithImpl(this._self, this._then);

  final _BasicAuthService _self;
  final $Res Function(_BasicAuthService) _then;

/// Create a copy of BasicAuthService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,}) {
  return _then(_BasicAuthService(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BearerAuthService {

 String get token;
/// Create a copy of BearerAuthService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BearerAuthServiceCopyWith<BearerAuthService> get copyWith => _$BearerAuthServiceCopyWithImpl<BearerAuthService>(this as BearerAuthService, _$identity);

  /// Serializes this BearerAuthService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BearerAuthService&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'BearerAuthService(token: $token)';
}


}

/// @nodoc
abstract mixin class $BearerAuthServiceCopyWith<$Res>  {
  factory $BearerAuthServiceCopyWith(BearerAuthService value, $Res Function(BearerAuthService) _then) = _$BearerAuthServiceCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$BearerAuthServiceCopyWithImpl<$Res>
    implements $BearerAuthServiceCopyWith<$Res> {
  _$BearerAuthServiceCopyWithImpl(this._self, this._then);

  final BearerAuthService _self;
  final $Res Function(BearerAuthService) _then;

/// Create a copy of BearerAuthService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BearerAuthService].
extension BearerAuthServicePatterns on BearerAuthService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BearerAuthService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BearerAuthService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BearerAuthService value)  $default,){
final _that = this;
switch (_that) {
case _BearerAuthService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BearerAuthService value)?  $default,){
final _that = this;
switch (_that) {
case _BearerAuthService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BearerAuthService() when $default != null:
return $default(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token)  $default,) {final _that = this;
switch (_that) {
case _BearerAuthService():
return $default(_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token)?  $default,) {final _that = this;
switch (_that) {
case _BearerAuthService() when $default != null:
return $default(_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BearerAuthService extends BearerAuthService {
  const _BearerAuthService({required this.token}): super._();
  factory _BearerAuthService.fromJson(Map<String, dynamic> json) => _$BearerAuthServiceFromJson(json);

@override final  String token;

/// Create a copy of BearerAuthService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BearerAuthServiceCopyWith<_BearerAuthService> get copyWith => __$BearerAuthServiceCopyWithImpl<_BearerAuthService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BearerAuthServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BearerAuthService&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'BearerAuthService(token: $token)';
}


}

/// @nodoc
abstract mixin class _$BearerAuthServiceCopyWith<$Res> implements $BearerAuthServiceCopyWith<$Res> {
  factory _$BearerAuthServiceCopyWith(_BearerAuthService value, $Res Function(_BearerAuthService) _then) = __$BearerAuthServiceCopyWithImpl;
@override @useResult
$Res call({
 String token
});




}
/// @nodoc
class __$BearerAuthServiceCopyWithImpl<$Res>
    implements _$BearerAuthServiceCopyWith<$Res> {
  __$BearerAuthServiceCopyWithImpl(this._self, this._then);

  final _BearerAuthService _self;
  final $Res Function(_BearerAuthService) _then;

/// Create a copy of BearerAuthService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_BearerAuthService(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
