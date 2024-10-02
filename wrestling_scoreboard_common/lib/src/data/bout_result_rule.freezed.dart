// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_result_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoutResultRule _$BoutResultRuleFromJson(Map<String, dynamic> json) {
  return _BoutResultRule.fromJson(json);
}

/// @nodoc
mixin _$BoutResultRule {
  int? get id => throw _privateConstructorUsedError;
  BoutConfig get boutConfig => throw _privateConstructorUsedError;
  BoutResult get boutResult => throw _privateConstructorUsedError;
  WrestlingStyle? get style =>
      throw _privateConstructorUsedError; // Minimum points, the winner must have to fulfill this rule
  int? get winnerTechnicalPoints =>
      throw _privateConstructorUsedError; // Minimum points, the loser must have to fulfill this rule
  int? get loserTechnicalPoints => throw _privateConstructorUsedError;
  int? get technicalPointsDifference => throw _privateConstructorUsedError;
  int get winnerClassificationPoints => throw _privateConstructorUsedError;
  int get loserClassificationPoints => throw _privateConstructorUsedError;

  /// Serializes this BoutResultRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoutResultRuleCopyWith<BoutResultRule> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoutResultRuleCopyWith<$Res> {
  factory $BoutResultRuleCopyWith(BoutResultRule value, $Res Function(BoutResultRule) then) =
      _$BoutResultRuleCopyWithImpl<$Res, BoutResultRule>;
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
class _$BoutResultRuleCopyWithImpl<$Res, $Val extends BoutResultRule> implements $BoutResultRuleCopyWith<$Res> {
  _$BoutResultRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      boutResult: null == boutResult
          ? _value.boutResult
          : boutResult // ignore: cast_nullable_to_non_nullable
              as BoutResult,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle?,
      winnerTechnicalPoints: freezed == winnerTechnicalPoints
          ? _value.winnerTechnicalPoints
          : winnerTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      loserTechnicalPoints: freezed == loserTechnicalPoints
          ? _value.loserTechnicalPoints
          : loserTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      technicalPointsDifference: freezed == technicalPointsDifference
          ? _value.technicalPointsDifference
          : technicalPointsDifference // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerClassificationPoints: null == winnerClassificationPoints
          ? _value.winnerClassificationPoints
          : winnerClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
      loserClassificationPoints: null == loserClassificationPoints
          ? _value.loserClassificationPoints
          : loserClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoutResultRuleImplCopyWith<$Res> implements $BoutResultRuleCopyWith<$Res> {
  factory _$$BoutResultRuleImplCopyWith(_$BoutResultRuleImpl value, $Res Function(_$BoutResultRuleImpl) then) =
      __$$BoutResultRuleImplCopyWithImpl<$Res>;
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
class __$$BoutResultRuleImplCopyWithImpl<$Res> extends _$BoutResultRuleCopyWithImpl<$Res, _$BoutResultRuleImpl>
    implements _$$BoutResultRuleImplCopyWith<$Res> {
  __$$BoutResultRuleImplCopyWithImpl(_$BoutResultRuleImpl _value, $Res Function(_$BoutResultRuleImpl) _then)
      : super(_value, _then);

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
    return _then(_$BoutResultRuleImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      boutResult: null == boutResult
          ? _value.boutResult
          : boutResult // ignore: cast_nullable_to_non_nullable
              as BoutResult,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle?,
      winnerTechnicalPoints: freezed == winnerTechnicalPoints
          ? _value.winnerTechnicalPoints
          : winnerTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      loserTechnicalPoints: freezed == loserTechnicalPoints
          ? _value.loserTechnicalPoints
          : loserTechnicalPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      technicalPointsDifference: freezed == technicalPointsDifference
          ? _value.technicalPointsDifference
          : technicalPointsDifference // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerClassificationPoints: null == winnerClassificationPoints
          ? _value.winnerClassificationPoints
          : winnerClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
      loserClassificationPoints: null == loserClassificationPoints
          ? _value.loserClassificationPoints
          : loserClassificationPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoutResultRuleImpl extends _BoutResultRule {
  const _$BoutResultRuleImpl(
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

  factory _$BoutResultRuleImpl.fromJson(Map<String, dynamic> json) => _$$BoutResultRuleImplFromJson(json);

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

  @override
  String toString() {
    return 'BoutResultRule(id: $id, boutConfig: $boutConfig, boutResult: $boutResult, style: $style, winnerTechnicalPoints: $winnerTechnicalPoints, loserTechnicalPoints: $loserTechnicalPoints, technicalPointsDifference: $technicalPointsDifference, winnerClassificationPoints: $winnerClassificationPoints, loserClassificationPoints: $loserClassificationPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoutResultRuleImpl &&
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

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoutResultRuleImplCopyWith<_$BoutResultRuleImpl> get copyWith =>
      __$$BoutResultRuleImplCopyWithImpl<_$BoutResultRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoutResultRuleImplToJson(
      this,
    );
  }
}

abstract class _BoutResultRule extends BoutResultRule {
  const factory _BoutResultRule(
      {final int? id,
      required final BoutConfig boutConfig,
      required final BoutResult boutResult,
      final WrestlingStyle? style,
      final int? winnerTechnicalPoints,
      final int? loserTechnicalPoints,
      final int? technicalPointsDifference,
      required final int winnerClassificationPoints,
      required final int loserClassificationPoints}) = _$BoutResultRuleImpl;
  const _BoutResultRule._() : super._();

  factory _BoutResultRule.fromJson(Map<String, dynamic> json) = _$BoutResultRuleImpl.fromJson;

  @override
  int? get id;
  @override
  BoutConfig get boutConfig;
  @override
  BoutResult get boutResult;
  @override
  WrestlingStyle? get style; // Minimum points, the winner must have to fulfill this rule
  @override
  int? get winnerTechnicalPoints; // Minimum points, the loser must have to fulfill this rule
  @override
  int? get loserTechnicalPoints;
  @override
  int? get technicalPointsDifference;
  @override
  int get winnerClassificationPoints;
  @override
  int get loserClassificationPoints;

  /// Create a copy of BoutResultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoutResultRuleImplCopyWith<_$BoutResultRuleImpl> get copyWith => throw _privateConstructorUsedError;
}
