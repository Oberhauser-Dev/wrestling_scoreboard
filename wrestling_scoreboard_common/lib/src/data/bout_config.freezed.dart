// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoutConfig _$BoutConfigFromJson(Map<String, dynamic> json) {
  return _BoutConfig.fromJson(json);
}

/// @nodoc
mixin _$BoutConfig {
  int? get id => throw _privateConstructorUsedError;

  Duration get periodDuration => throw _privateConstructorUsedError;

  Duration get breakDuration => throw _privateConstructorUsedError;

  Duration get activityDuration => throw _privateConstructorUsedError;

  Duration get injuryDuration => throw _privateConstructorUsedError;

  int get periodCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoutConfigCopyWith<BoutConfig> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoutConfigCopyWith<$Res> {
  factory $BoutConfigCopyWith(BoutConfig value, $Res Function(BoutConfig) then) =
      _$BoutConfigCopyWithImpl<$Res, BoutConfig>;

  @useResult
  $Res call(
      {int? id,
      Duration periodDuration,
      Duration breakDuration,
      Duration activityDuration,
      Duration injuryDuration,
      int periodCount});
}

/// @nodoc
class _$BoutConfigCopyWithImpl<$Res, $Val extends BoutConfig> implements $BoutConfigCopyWith<$Res> {
  _$BoutConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? periodDuration = null,
    Object? breakDuration = null,
    Object? activityDuration = null,
    Object? injuryDuration = null,
    Object? periodCount = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      periodDuration: null == periodDuration
          ? _value.periodDuration
          : periodDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      breakDuration: null == breakDuration
          ? _value.breakDuration
          : breakDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      activityDuration: null == activityDuration
          ? _value.activityDuration
          : activityDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      injuryDuration: null == injuryDuration
          ? _value.injuryDuration
          : injuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      periodCount: null == periodCount
          ? _value.periodCount
          : periodCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoutConfigImplCopyWith<$Res> implements $BoutConfigCopyWith<$Res> {
  factory _$$BoutConfigImplCopyWith(_$BoutConfigImpl value, $Res Function(_$BoutConfigImpl) then) =
      __$$BoutConfigImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int? id,
      Duration periodDuration,
      Duration breakDuration,
      Duration activityDuration,
      Duration injuryDuration,
      int periodCount});
}

/// @nodoc
class __$$BoutConfigImplCopyWithImpl<$Res> extends _$BoutConfigCopyWithImpl<$Res, _$BoutConfigImpl>
    implements _$$BoutConfigImplCopyWith<$Res> {
  __$$BoutConfigImplCopyWithImpl(_$BoutConfigImpl _value, $Res Function(_$BoutConfigImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? periodDuration = null,
    Object? breakDuration = null,
    Object? activityDuration = null,
    Object? injuryDuration = null,
    Object? periodCount = null,
  }) {
    return _then(_$BoutConfigImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      periodDuration: null == periodDuration
          ? _value.periodDuration
          : periodDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      breakDuration: null == breakDuration
          ? _value.breakDuration
          : breakDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      activityDuration: null == activityDuration
          ? _value.activityDuration
          : activityDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      injuryDuration: null == injuryDuration
          ? _value.injuryDuration
          : injuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      periodCount: null == periodCount
          ? _value.periodCount
          : periodCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoutConfigImpl extends _BoutConfig {
  const _$BoutConfigImpl(
      {this.id,
      this.periodDuration = BoutConfig.defaultPeriodDuration,
      this.breakDuration = BoutConfig.defaultBreakDuration,
      this.activityDuration = BoutConfig.defaultActivityDuration,
      this.injuryDuration = BoutConfig.defaultInjuryDuration,
      this.periodCount = BoutConfig.defaultPeriodCount})
      : super._();

  factory _$BoutConfigImpl.fromJson(Map<String, dynamic> json) => _$$BoutConfigImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey()
  final Duration periodDuration;
  @override
  @JsonKey()
  final Duration breakDuration;
  @override
  @JsonKey()
  final Duration activityDuration;
  @override
  @JsonKey()
  final Duration injuryDuration;
  @override
  @JsonKey()
  final int periodCount;

  @override
  String toString() {
    return 'BoutConfig(id: $id, periodDuration: $periodDuration, breakDuration: $breakDuration, activityDuration: $activityDuration, injuryDuration: $injuryDuration, periodCount: $periodCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoutConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.periodDuration, periodDuration) || other.periodDuration == periodDuration) &&
            (identical(other.breakDuration, breakDuration) || other.breakDuration == breakDuration) &&
            (identical(other.activityDuration, activityDuration) || other.activityDuration == activityDuration) &&
            (identical(other.injuryDuration, injuryDuration) || other.injuryDuration == injuryDuration) &&
            (identical(other.periodCount, periodCount) || other.periodCount == periodCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, periodDuration, breakDuration, activityDuration, injuryDuration, periodCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoutConfigImplCopyWith<_$BoutConfigImpl> get copyWith =>
      __$$BoutConfigImplCopyWithImpl<_$BoutConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoutConfigImplToJson(
      this,
    );
  }
}

abstract class _BoutConfig extends BoutConfig {
  const factory _BoutConfig(
      {final int? id,
      final Duration periodDuration,
      final Duration breakDuration,
      final Duration activityDuration,
      final Duration injuryDuration,
      final int periodCount}) = _$BoutConfigImpl;

  const _BoutConfig._() : super._();

  factory _BoutConfig.fromJson(Map<String, dynamic> json) = _$BoutConfigImpl.fromJson;

  @override
  int? get id;

  @override
  Duration get periodDuration;

  @override
  Duration get breakDuration;

  @override
  Duration get activityDuration;

  @override
  Duration get injuryDuration;

  @override
  int get periodCount;

  @override
  @JsonKey(ignore: true)
  _$$BoutConfigImplCopyWith<_$BoutConfigImpl> get copyWith => throw _privateConstructorUsedError;
}
