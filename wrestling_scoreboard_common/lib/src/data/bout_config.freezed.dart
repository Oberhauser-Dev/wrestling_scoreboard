// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoutConfig {
  int? get id;
  Duration get periodDuration;
  Duration get breakDuration;
  Duration? get activityDuration;
  Duration? get injuryDuration;
  Duration? get bleedingInjuryDuration;
  int get periodCount;

  /// Create a copy of BoutConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<BoutConfig> get copyWith => _$BoutConfigCopyWithImpl<BoutConfig>(this as BoutConfig, _$identity);

  /// Serializes this BoutConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BoutConfig &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.periodDuration, periodDuration) || other.periodDuration == periodDuration) &&
            (identical(other.breakDuration, breakDuration) || other.breakDuration == breakDuration) &&
            (identical(other.activityDuration, activityDuration) || other.activityDuration == activityDuration) &&
            (identical(other.injuryDuration, injuryDuration) || other.injuryDuration == injuryDuration) &&
            (identical(other.bleedingInjuryDuration, bleedingInjuryDuration) ||
                other.bleedingInjuryDuration == bleedingInjuryDuration) &&
            (identical(other.periodCount, periodCount) || other.periodCount == periodCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, periodDuration, breakDuration, activityDuration, injuryDuration,
      bleedingInjuryDuration, periodCount);

  @override
  String toString() {
    return 'BoutConfig(id: $id, periodDuration: $periodDuration, breakDuration: $breakDuration, activityDuration: $activityDuration, injuryDuration: $injuryDuration, bleedingInjuryDuration: $bleedingInjuryDuration, periodCount: $periodCount)';
  }
}

/// @nodoc
abstract mixin class $BoutConfigCopyWith<$Res> {
  factory $BoutConfigCopyWith(BoutConfig value, $Res Function(BoutConfig) _then) = _$BoutConfigCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      Duration periodDuration,
      Duration breakDuration,
      Duration? activityDuration,
      Duration? injuryDuration,
      Duration? bleedingInjuryDuration,
      int periodCount});
}

/// @nodoc
class _$BoutConfigCopyWithImpl<$Res> implements $BoutConfigCopyWith<$Res> {
  _$BoutConfigCopyWithImpl(this._self, this._then);

  final BoutConfig _self;
  final $Res Function(BoutConfig) _then;

  /// Create a copy of BoutConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? periodDuration = null,
    Object? breakDuration = null,
    Object? activityDuration = freezed,
    Object? injuryDuration = freezed,
    Object? bleedingInjuryDuration = freezed,
    Object? periodCount = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      periodDuration: null == periodDuration
          ? _self.periodDuration
          : periodDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      breakDuration: null == breakDuration
          ? _self.breakDuration
          : breakDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      activityDuration: freezed == activityDuration
          ? _self.activityDuration
          : activityDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      injuryDuration: freezed == injuryDuration
          ? _self.injuryDuration
          : injuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      bleedingInjuryDuration: freezed == bleedingInjuryDuration
          ? _self.bleedingInjuryDuration
          : bleedingInjuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      periodCount: null == periodCount
          ? _self.periodCount
          : periodCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BoutConfig extends BoutConfig {
  const _BoutConfig(
      {this.id,
      this.periodDuration = BoutConfig.defaultPeriodDuration,
      this.breakDuration = BoutConfig.defaultBreakDuration,
      this.activityDuration,
      this.injuryDuration,
      this.bleedingInjuryDuration,
      this.periodCount = BoutConfig.defaultPeriodCount})
      : super._();
  factory _BoutConfig.fromJson(Map<String, dynamic> json) => _$BoutConfigFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey()
  final Duration periodDuration;
  @override
  @JsonKey()
  final Duration breakDuration;
  @override
  final Duration? activityDuration;
  @override
  final Duration? injuryDuration;
  @override
  final Duration? bleedingInjuryDuration;
  @override
  @JsonKey()
  final int periodCount;

  /// Create a copy of BoutConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoutConfigCopyWith<_BoutConfig> get copyWith => __$BoutConfigCopyWithImpl<_BoutConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BoutConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BoutConfig &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.periodDuration, periodDuration) || other.periodDuration == periodDuration) &&
            (identical(other.breakDuration, breakDuration) || other.breakDuration == breakDuration) &&
            (identical(other.activityDuration, activityDuration) || other.activityDuration == activityDuration) &&
            (identical(other.injuryDuration, injuryDuration) || other.injuryDuration == injuryDuration) &&
            (identical(other.bleedingInjuryDuration, bleedingInjuryDuration) ||
                other.bleedingInjuryDuration == bleedingInjuryDuration) &&
            (identical(other.periodCount, periodCount) || other.periodCount == periodCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, periodDuration, breakDuration, activityDuration, injuryDuration,
      bleedingInjuryDuration, periodCount);

  @override
  String toString() {
    return 'BoutConfig(id: $id, periodDuration: $periodDuration, breakDuration: $breakDuration, activityDuration: $activityDuration, injuryDuration: $injuryDuration, bleedingInjuryDuration: $bleedingInjuryDuration, periodCount: $periodCount)';
  }
}

/// @nodoc
abstract mixin class _$BoutConfigCopyWith<$Res> implements $BoutConfigCopyWith<$Res> {
  factory _$BoutConfigCopyWith(_BoutConfig value, $Res Function(_BoutConfig) _then) = __$BoutConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      Duration periodDuration,
      Duration breakDuration,
      Duration? activityDuration,
      Duration? injuryDuration,
      Duration? bleedingInjuryDuration,
      int periodCount});
}

/// @nodoc
class __$BoutConfigCopyWithImpl<$Res> implements _$BoutConfigCopyWith<$Res> {
  __$BoutConfigCopyWithImpl(this._self, this._then);

  final _BoutConfig _self;
  final $Res Function(_BoutConfig) _then;

  /// Create a copy of BoutConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? periodDuration = null,
    Object? breakDuration = null,
    Object? activityDuration = freezed,
    Object? injuryDuration = freezed,
    Object? bleedingInjuryDuration = freezed,
    Object? periodCount = null,
  }) {
    return _then(_BoutConfig(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      periodDuration: null == periodDuration
          ? _self.periodDuration
          : periodDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      breakDuration: null == breakDuration
          ? _self.breakDuration
          : breakDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      activityDuration: freezed == activityDuration
          ? _self.activityDuration
          : activityDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      injuryDuration: freezed == injuryDuration
          ? _self.injuryDuration
          : injuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      bleedingInjuryDuration: freezed == bleedingInjuryDuration
          ? _self.bleedingInjuryDuration
          : bleedingInjuryDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      periodCount: null == periodCount
          ? _self.periodCount
          : periodCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
