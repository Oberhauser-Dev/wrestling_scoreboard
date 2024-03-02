// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

League _$LeagueFromJson(Map<String, dynamic> json) {
  return _League.fromJson(json);
}

/// @nodoc
mixin _$League {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  BoutConfig get boutConfig => throw _privateConstructorUsedError;
  int get seasonPartitions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeagueCopyWith<League> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueCopyWith<$Res> {
  factory $LeagueCopyWith(League value, $Res Function(League) then) = _$LeagueCopyWithImpl<$Res, League>;
  @useResult
  $Res call({int? id, String name, DateTime startDate, BoutConfig boutConfig, int seasonPartitions});

  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class _$LeagueCopyWithImpl<$Res, $Val extends League> implements $LeagueCopyWith<$Res> {
  _$LeagueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? startDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      seasonPartitions: null == seasonPartitions
          ? _value.seasonPartitions
          : seasonPartitions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueImplCopyWith<$Res> implements $LeagueCopyWith<$Res> {
  factory _$$LeagueImplCopyWith(_$LeagueImpl value, $Res Function(_$LeagueImpl) then) =
      __$$LeagueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String name, DateTime startDate, BoutConfig boutConfig, int seasonPartitions});

  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class __$$LeagueImplCopyWithImpl<$Res> extends _$LeagueCopyWithImpl<$Res, _$LeagueImpl>
    implements _$$LeagueImplCopyWith<$Res> {
  __$$LeagueImplCopyWithImpl(_$LeagueImpl _value, $Res Function(_$LeagueImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? startDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
  }) {
    return _then(_$LeagueImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      seasonPartitions: null == seasonPartitions
          ? _value.seasonPartitions
          : seasonPartitions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueImpl extends _League {
  const _$LeagueImpl(
      {this.id, required this.name, required this.startDate, required this.boutConfig, required this.seasonPartitions})
      : super._();

  factory _$LeagueImpl.fromJson(Map<String, dynamic> json) => _$$LeagueImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final DateTime startDate;
  @override
  final BoutConfig boutConfig;
  @override
  final int seasonPartitions;

  @override
  String toString() {
    return 'League(id: $id, name: $name, startDate: $startDate, boutConfig: $boutConfig, seasonPartitions: $seasonPartitions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.seasonPartitions, seasonPartitions) || other.seasonPartitions == seasonPartitions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, startDate, boutConfig, seasonPartitions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith => __$$LeagueImplCopyWithImpl<_$LeagueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueImplToJson(
      this,
    );
  }
}

abstract class _League extends League {
  const factory _League(
      {final int? id,
      required final String name,
      required final DateTime startDate,
      required final BoutConfig boutConfig,
      required final int seasonPartitions}) = _$LeagueImpl;
  const _League._() : super._();

  factory _League.fromJson(Map<String, dynamic> json) = _$LeagueImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  DateTime get startDate;
  @override
  BoutConfig get boutConfig;
  @override
  int get seasonPartitions;
  @override
  @JsonKey(ignore: true)
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith => throw _privateConstructorUsedError;
}
