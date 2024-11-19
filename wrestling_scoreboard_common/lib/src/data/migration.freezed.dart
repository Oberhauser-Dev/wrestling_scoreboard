// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'migration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Migration _$MigrationFromJson(Map<String, dynamic> json) {
  return _Migration.fromJson(json);
}

/// @nodoc
mixin _$Migration {
  String get semver => throw _privateConstructorUsedError;
  String get minClientVersion => throw _privateConstructorUsedError;

  /// Serializes this Migration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Migration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MigrationCopyWith<Migration> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MigrationCopyWith<$Res> {
  factory $MigrationCopyWith(Migration value, $Res Function(Migration) then) = _$MigrationCopyWithImpl<$Res, Migration>;
  @useResult
  $Res call({String semver, String minClientVersion});
}

/// @nodoc
class _$MigrationCopyWithImpl<$Res, $Val extends Migration> implements $MigrationCopyWith<$Res> {
  _$MigrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Migration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? semver = null,
    Object? minClientVersion = null,
  }) {
    return _then(_value.copyWith(
      semver: null == semver
          ? _value.semver
          : semver // ignore: cast_nullable_to_non_nullable
              as String,
      minClientVersion: null == minClientVersion
          ? _value.minClientVersion
          : minClientVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MigrationImplCopyWith<$Res> implements $MigrationCopyWith<$Res> {
  factory _$$MigrationImplCopyWith(_$MigrationImpl value, $Res Function(_$MigrationImpl) then) =
      __$$MigrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String semver, String minClientVersion});
}

/// @nodoc
class __$$MigrationImplCopyWithImpl<$Res> extends _$MigrationCopyWithImpl<$Res, _$MigrationImpl>
    implements _$$MigrationImplCopyWith<$Res> {
  __$$MigrationImplCopyWithImpl(_$MigrationImpl _value, $Res Function(_$MigrationImpl) _then) : super(_value, _then);

  /// Create a copy of Migration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? semver = null,
    Object? minClientVersion = null,
  }) {
    return _then(_$MigrationImpl(
      semver: null == semver
          ? _value.semver
          : semver // ignore: cast_nullable_to_non_nullable
              as String,
      minClientVersion: null == minClientVersion
          ? _value.minClientVersion
          : minClientVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MigrationImpl extends _Migration {
  const _$MigrationImpl({required this.semver, required this.minClientVersion}) : super._();

  factory _$MigrationImpl.fromJson(Map<String, dynamic> json) => _$$MigrationImplFromJson(json);

  @override
  final String semver;
  @override
  final String minClientVersion;

  @override
  String toString() {
    return 'Migration(semver: $semver, minClientVersion: $minClientVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MigrationImpl &&
            (identical(other.semver, semver) || other.semver == semver) &&
            (identical(other.minClientVersion, minClientVersion) || other.minClientVersion == minClientVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, semver, minClientVersion);

  /// Create a copy of Migration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MigrationImplCopyWith<_$MigrationImpl> get copyWith =>
      __$$MigrationImplCopyWithImpl<_$MigrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MigrationImplToJson(
      this,
    );
  }
}

abstract class _Migration extends Migration {
  const factory _Migration({required final String semver, required final String minClientVersion}) = _$MigrationImpl;
  const _Migration._() : super._();

  factory _Migration.fromJson(Map<String, dynamic> json) = _$MigrationImpl.fromJson;

  @override
  String get semver;
  @override
  String get minClientVersion;

  /// Create a copy of Migration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MigrationImplCopyWith<_$MigrationImpl> get copyWith => throw _privateConstructorUsedError;
}
