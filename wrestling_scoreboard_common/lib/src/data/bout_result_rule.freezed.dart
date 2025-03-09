// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_result_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoutResultRule {
  int? get id;
  BoutConfig get boutConfig;
  BoutResult get boutResult;
  WrestlingStyle? get style; // Minimum points, the winner must have to fulfill this rule
  int? get winnerTechnicalPoints; // Minimum points, the loser must have to fulfill this rule
  int? get loserTechnicalPoints;
  int? get technicalPointsDifference;
  int get winnerClassificationPoints;
  int get loserClassificationPoints;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoutResultRuleCopyWith<BoutResultRule> get copyWith =>
      _$BoutResultRuleCopyWithImpl<BoutResultRule>(this as BoutResultRule, _$identity);

  /// Serializes this BoutResultRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BoutResultRule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.boutResult, boutResult) || other.boutResult == boutResult) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.winnerTechnicalPoints, winnerTechnicalPoints) ||
                other.winnerTechnicalPoints == winnerTechnicalPoints) &&
            (identical(other.loserTechnicalPoints, loserTechnicalPoints) ||
                other.loserTechnicalPoints == loserTechnicalPoints) &&
            (identical(other.technicalPointsDifference, technicalPointsDifference) ||
                other.technicalPointsDifference == technicalPointsDifference) &&
            (identical(other.winnerClassificationPoints, winnerClassificationPoints) ||
                other.winnerClassificationPoints == winnerClassificationPoints) &&
            (identical(other.loserClassificationPoints, loserClassificationPoints) ||
                other.loserClassificationPoints == loserClassificationPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, boutConfig, boutResult, style, winnerTechnicalPoints,
      loserTechnicalPoints, technicalPointsDifference, winnerClassificationPoints, loserClassificationPoints);

  @override
  String toString() {
    return 'BoutResultRule(id: $id, boutConfig: $boutConfig, boutResult: $boutResult, style: $style, winnerTechnicalPoints: $winnerTechnicalPoints, loserTechnicalPoints: $loserTechnicalPoints, technicalPointsDifference: $technicalPointsDifference, winnerClassificationPoints: $winnerClassificationPoints, loserClassificationPoints: $loserClassificationPoints)';
  }
}

/// @nodoc
abstract mixin class $BoutResultRuleCopyWith<$Res> {
  factory $BoutResultRuleCopyWith(BoutResultRule value, $Res Function(BoutResultRule) _then) =
      _$BoutResultRuleCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      BoutConfig boutConfig,
      BoutResult boutResult,
      WrestlingStyle? style,
      int? winnerTechnicalPoints,
      int? loserTechnicalPoints,
      int? technicalPointsDifference,
      int winnerClassificationPoints,
      int loserClassificationPoints});

  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class _$BoutResultRuleCopyWithImpl<$Res> implements $BoutResultRuleCopyWith<$Res> {
  _$BoutResultRuleCopyWithImpl(this._self, this._then);

  final BoutResultRule _self;
  final $Res Function(BoutResultRule) _then;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? boutConfig = null,
    Object? boutResult = null,
    Object? style = freezed,
    Object? winnerTechnicalPoints = freezed,
    Object? loserTechnicalPoints = freezed,
    Object? technicalPointsDifference = freezed,
    Object? winnerClassificationPoints = null,
    Object? loserClassificationPoints = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      boutConfig: null == boutConfig
          ? _self.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      boutResult: null == boutResult
          ? _self.boutResult
          : boutResult // ignore: cast_nullable_to_non_nullable
              as BoutResult,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle?,
      winnerTechnicalPoints: freezed == winnerTechnicalPoints
          ? _self.winnerTechnicalPoints
          : winnerTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      loserTechnicalPoints: freezed == loserTechnicalPoints
          ? _self.loserTechnicalPoints
          : loserTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      technicalPointsDifference: freezed == technicalPointsDifference
          ? _self.technicalPointsDifference
          : technicalPointsDifference // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerClassificationPoints: null == winnerClassificationPoints
          ? _self.winnerClassificationPoints
          : winnerClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
      loserClassificationPoints: null == loserClassificationPoints
          ? _self.loserClassificationPoints
          : loserClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
      return _then(_self.copyWith(boutConfig: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _BoutResultRule extends BoutResultRule {
  const _BoutResultRule(
      {this.id,
      required this.boutConfig,
      required this.boutResult,
      this.style,
      this.winnerTechnicalPoints,
      this.loserTechnicalPoints,
      this.technicalPointsDifference,
      required this.winnerClassificationPoints,
      required this.loserClassificationPoints})
      : super._();
  factory _BoutResultRule.fromJson(Map<String, dynamic> json) => _$BoutResultRuleFromJson(json);

  @override
  final int? id;
  @override
  final BoutConfig boutConfig;
  @override
  final BoutResult boutResult;
  @override
  final WrestlingStyle? style;
// Minimum points, the winner must have to fulfill this rule
  @override
  final int? winnerTechnicalPoints;
// Minimum points, the loser must have to fulfill this rule
  @override
  final int? loserTechnicalPoints;
  @override
  final int? technicalPointsDifference;
  @override
  final int winnerClassificationPoints;
  @override
  final int loserClassificationPoints;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoutResultRuleCopyWith<_BoutResultRule> get copyWith =>
      __$BoutResultRuleCopyWithImpl<_BoutResultRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BoutResultRuleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BoutResultRule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.boutResult, boutResult) || other.boutResult == boutResult) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.winnerTechnicalPoints, winnerTechnicalPoints) ||
                other.winnerTechnicalPoints == winnerTechnicalPoints) &&
            (identical(other.loserTechnicalPoints, loserTechnicalPoints) ||
                other.loserTechnicalPoints == loserTechnicalPoints) &&
            (identical(other.technicalPointsDifference, technicalPointsDifference) ||
                other.technicalPointsDifference == technicalPointsDifference) &&
            (identical(other.winnerClassificationPoints, winnerClassificationPoints) ||
                other.winnerClassificationPoints == winnerClassificationPoints) &&
            (identical(other.loserClassificationPoints, loserClassificationPoints) ||
                other.loserClassificationPoints == loserClassificationPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, boutConfig, boutResult, style, winnerTechnicalPoints,
      loserTechnicalPoints, technicalPointsDifference, winnerClassificationPoints, loserClassificationPoints);

  @override
  String toString() {
    return 'BoutResultRule(id: $id, boutConfig: $boutConfig, boutResult: $boutResult, style: $style, winnerTechnicalPoints: $winnerTechnicalPoints, loserTechnicalPoints: $loserTechnicalPoints, technicalPointsDifference: $technicalPointsDifference, winnerClassificationPoints: $winnerClassificationPoints, loserClassificationPoints: $loserClassificationPoints)';
  }
}

/// @nodoc
abstract mixin class _$BoutResultRuleCopyWith<$Res> implements $BoutResultRuleCopyWith<$Res> {
  factory _$BoutResultRuleCopyWith(_BoutResultRule value, $Res Function(_BoutResultRule) _then) =
      __$BoutResultRuleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      BoutConfig boutConfig,
      BoutResult boutResult,
      WrestlingStyle? style,
      int? winnerTechnicalPoints,
      int? loserTechnicalPoints,
      int? technicalPointsDifference,
      int winnerClassificationPoints,
      int loserClassificationPoints});

  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class __$BoutResultRuleCopyWithImpl<$Res> implements _$BoutResultRuleCopyWith<$Res> {
  __$BoutResultRuleCopyWithImpl(this._self, this._then);

  final _BoutResultRule _self;
  final $Res Function(_BoutResultRule) _then;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? boutConfig = null,
    Object? boutResult = null,
    Object? style = freezed,
    Object? winnerTechnicalPoints = freezed,
    Object? loserTechnicalPoints = freezed,
    Object? technicalPointsDifference = freezed,
    Object? winnerClassificationPoints = null,
    Object? loserClassificationPoints = null,
  }) {
    return _then(_BoutResultRule(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      boutConfig: null == boutConfig
          ? _self.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      boutResult: null == boutResult
          ? _self.boutResult
          : boutResult // ignore: cast_nullable_to_non_nullable
              as BoutResult,
      style: freezed == style
          ? _self.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle?,
      winnerTechnicalPoints: freezed == winnerTechnicalPoints
          ? _self.winnerTechnicalPoints
          : winnerTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      loserTechnicalPoints: freezed == loserTechnicalPoints
          ? _self.loserTechnicalPoints
          : loserTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      technicalPointsDifference: freezed == technicalPointsDifference
          ? _self.technicalPointsDifference
          : technicalPointsDifference // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerClassificationPoints: null == winnerClassificationPoints
          ? _self.winnerClassificationPoints
          : winnerClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
      loserClassificationPoints: null == loserClassificationPoints
          ? _self.loserClassificationPoints
          : loserClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
      return _then(_self.copyWith(boutConfig: value));
    });
  }
}

// dart format on
