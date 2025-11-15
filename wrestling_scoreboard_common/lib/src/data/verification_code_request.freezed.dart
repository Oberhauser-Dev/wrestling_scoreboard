// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_code_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerificationCodeRequest {

 String? get username;
/// Create a copy of VerificationCodeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationCodeRequestCopyWith<VerificationCodeRequest> get copyWith => _$VerificationCodeRequestCopyWithImpl<VerificationCodeRequest>(this as VerificationCodeRequest, _$identity);

  /// Serializes this VerificationCodeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationCodeRequest&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username);

@override
String toString() {
  return 'VerificationCodeRequest(username: $username)';
}


}

/// @nodoc
abstract mixin class $VerificationCodeRequestCopyWith<$Res>  {
  factory $VerificationCodeRequestCopyWith(VerificationCodeRequest value, $Res Function(VerificationCodeRequest) _then) = _$VerificationCodeRequestCopyWithImpl;
@useResult
$Res call({
 String? username
});




}
/// @nodoc
class _$VerificationCodeRequestCopyWithImpl<$Res>
    implements $VerificationCodeRequestCopyWith<$Res> {
  _$VerificationCodeRequestCopyWithImpl(this._self, this._then);

  final VerificationCodeRequest _self;
  final $Res Function(VerificationCodeRequest) _then;

/// Create a copy of VerificationCodeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = freezed,}) {
  return _then(_self.copyWith(
username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerificationCodeRequest].
extension VerificationCodeRequestPatterns on VerificationCodeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationCodeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationCodeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationCodeRequest value)  $default,){
final _that = this;
switch (_that) {
case _VerificationCodeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationCodeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationCodeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationCodeRequest() when $default != null:
return $default(_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? username)  $default,) {final _that = this;
switch (_that) {
case _VerificationCodeRequest():
return $default(_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? username)?  $default,) {final _that = this;
switch (_that) {
case _VerificationCodeRequest() when $default != null:
return $default(_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationCodeRequest extends VerificationCodeRequest {
  const _VerificationCodeRequest({this.username}): super._();
  factory _VerificationCodeRequest.fromJson(Map<String, dynamic> json) => _$VerificationCodeRequestFromJson(json);

@override final  String? username;

/// Create a copy of VerificationCodeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationCodeRequestCopyWith<_VerificationCodeRequest> get copyWith => __$VerificationCodeRequestCopyWithImpl<_VerificationCodeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationCodeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationCodeRequest&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username);

@override
String toString() {
  return 'VerificationCodeRequest(username: $username)';
}


}

/// @nodoc
abstract mixin class _$VerificationCodeRequestCopyWith<$Res> implements $VerificationCodeRequestCopyWith<$Res> {
  factory _$VerificationCodeRequestCopyWith(_VerificationCodeRequest value, $Res Function(_VerificationCodeRequest) _then) = __$VerificationCodeRequestCopyWithImpl;
@override @useResult
$Res call({
 String? username
});




}
/// @nodoc
class __$VerificationCodeRequestCopyWithImpl<$Res>
    implements _$VerificationCodeRequestCopyWith<$Res> {
  __$VerificationCodeRequestCopyWithImpl(this._self, this._then);

  final _VerificationCodeRequest _self;
  final $Res Function(_VerificationCodeRequest) _then;

/// Create a copy of VerificationCodeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = freezed,}) {
  return _then(_VerificationCodeRequest(
username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
