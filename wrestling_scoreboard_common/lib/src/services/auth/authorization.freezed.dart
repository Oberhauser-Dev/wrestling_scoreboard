// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authorization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BasicAuthService _$BasicAuthServiceFromJson(Map<String, dynamic> json) {
  return _BasicAuthService.fromJson(json);
}

/// @nodoc
mixin _$BasicAuthService {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this BasicAuthService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BasicAuthService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicAuthServiceCopyWith<BasicAuthService> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicAuthServiceCopyWith<$Res> {
  factory $BasicAuthServiceCopyWith(BasicAuthService value, $Res Function(BasicAuthService) then) =
      _$BasicAuthServiceCopyWithImpl<$Res, BasicAuthService>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$BasicAuthServiceCopyWithImpl<$Res, $Val extends BasicAuthService> implements $BasicAuthServiceCopyWith<$Res> {
  _$BasicAuthServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicAuthService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasicAuthServiceImplCopyWith<$Res> implements $BasicAuthServiceCopyWith<$Res> {
  factory _$$BasicAuthServiceImplCopyWith(_$BasicAuthServiceImpl value, $Res Function(_$BasicAuthServiceImpl) then) =
      __$$BasicAuthServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$BasicAuthServiceImplCopyWithImpl<$Res> extends _$BasicAuthServiceCopyWithImpl<$Res, _$BasicAuthServiceImpl>
    implements _$$BasicAuthServiceImplCopyWith<$Res> {
  __$$BasicAuthServiceImplCopyWithImpl(_$BasicAuthServiceImpl _value, $Res Function(_$BasicAuthServiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of BasicAuthService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_$BasicAuthServiceImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasicAuthServiceImpl extends _BasicAuthService {
  const _$BasicAuthServiceImpl({required this.username, required this.password}) : super._();

  factory _$BasicAuthServiceImpl.fromJson(Map<String, dynamic> json) => _$$BasicAuthServiceImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'BasicAuthService(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicAuthServiceImpl &&
            (identical(other.username, username) || other.username == username) &&
            (identical(other.password, password) || other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of BasicAuthService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicAuthServiceImplCopyWith<_$BasicAuthServiceImpl> get copyWith =>
      __$$BasicAuthServiceImplCopyWithImpl<_$BasicAuthServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicAuthServiceImplToJson(
      this,
    );
  }
}

abstract class _BasicAuthService extends BasicAuthService {
  const factory _BasicAuthService({required final String username, required final String password}) =
      _$BasicAuthServiceImpl;
  const _BasicAuthService._() : super._();

  factory _BasicAuthService.fromJson(Map<String, dynamic> json) = _$BasicAuthServiceImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of BasicAuthService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicAuthServiceImplCopyWith<_$BasicAuthServiceImpl> get copyWith => throw _privateConstructorUsedError;
}

BearerAuthService _$BearerAuthServiceFromJson(Map<String, dynamic> json) {
  return _BearerAuthService.fromJson(json);
}

/// @nodoc
mixin _$BearerAuthService {
  String get token => throw _privateConstructorUsedError;

  /// Serializes this BearerAuthService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BearerAuthService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BearerAuthServiceCopyWith<BearerAuthService> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BearerAuthServiceCopyWith<$Res> {
  factory $BearerAuthServiceCopyWith(BearerAuthService value, $Res Function(BearerAuthService) then) =
      _$BearerAuthServiceCopyWithImpl<$Res, BearerAuthService>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$BearerAuthServiceCopyWithImpl<$Res, $Val extends BearerAuthService>
    implements $BearerAuthServiceCopyWith<$Res> {
  _$BearerAuthServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BearerAuthService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BearerAuthServiceImplCopyWith<$Res> implements $BearerAuthServiceCopyWith<$Res> {
  factory _$$BearerAuthServiceImplCopyWith(_$BearerAuthServiceImpl value, $Res Function(_$BearerAuthServiceImpl) then) =
      __$$BearerAuthServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$BearerAuthServiceImplCopyWithImpl<$Res> extends _$BearerAuthServiceCopyWithImpl<$Res, _$BearerAuthServiceImpl>
    implements _$$BearerAuthServiceImplCopyWith<$Res> {
  __$$BearerAuthServiceImplCopyWithImpl(_$BearerAuthServiceImpl _value, $Res Function(_$BearerAuthServiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of BearerAuthService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$BearerAuthServiceImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BearerAuthServiceImpl extends _BearerAuthService {
  const _$BearerAuthServiceImpl({required this.token}) : super._();

  factory _$BearerAuthServiceImpl.fromJson(Map<String, dynamic> json) => _$$BearerAuthServiceImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'BearerAuthService(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BearerAuthServiceImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of BearerAuthService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BearerAuthServiceImplCopyWith<_$BearerAuthServiceImpl> get copyWith =>
      __$$BearerAuthServiceImplCopyWithImpl<_$BearerAuthServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BearerAuthServiceImplToJson(
      this,
    );
  }
}

abstract class _BearerAuthService extends BearerAuthService {
  const factory _BearerAuthService({required final String token}) = _$BearerAuthServiceImpl;
  const _BearerAuthService._() : super._();

  factory _BearerAuthService.fromJson(Map<String, dynamic> json) = _$BearerAuthServiceImpl.fromJson;

  @override
  String get token;

  /// Create a copy of BearerAuthService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BearerAuthServiceImplCopyWith<_$BearerAuthServiceImpl> get copyWith => throw _privateConstructorUsedError;
}
