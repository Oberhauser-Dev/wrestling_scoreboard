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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  @JsonKey(ignore: true)
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

  @override
  @JsonKey(ignore: true)
  _$$BasicAuthServiceImplCopyWith<_$BasicAuthServiceImpl> get copyWith => throw _privateConstructorUsedError;
}
