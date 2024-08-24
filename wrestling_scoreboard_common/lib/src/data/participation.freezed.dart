// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return _Participation.fromJson(json);
}

/// @nodoc
mixin _$Participation {
  int? get id => throw _privateConstructorUsedError;
  Membership get membership => throw _privateConstructorUsedError;
  Lineup get lineup => throw _privateConstructorUsedError;
  WeightClass? get weightClass => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;

  /// Serializes this Participation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipationCopyWith<Participation> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipationCopyWith<$Res> {
  factory $ParticipationCopyWith(Participation value, $Res Function(Participation) then) =
      _$ParticipationCopyWithImpl<$Res, Participation>;
  @useResult
  $Res call({int? id, Membership membership, Lineup lineup, WeightClass? weightClass, double? weight});

  $MembershipCopyWith<$Res> get membership;
  $LineupCopyWith<$Res> get lineup;
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class _$ParticipationCopyWithImpl<$Res, $Val extends Participation> implements $ParticipationCopyWith<$Res> {
  _$ParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? membership = null,
    Object? lineup = null,
    Object? weightClass = freezed,
    Object? weight = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      membership: null == membership
          ? _value.membership
          : membership // ignore: cast_nullable_to_non_nullable
              as Membership,
      lineup: null == lineup
          ? _value.lineup
          : lineup // ignore: cast_nullable_to_non_nullable
              as Lineup,
      weightClass: freezed == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res> get membership {
    return $MembershipCopyWith<$Res>(_value.membership, (value) {
      return _then(_value.copyWith(membership: value) as $Val);
    });
  }

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get lineup {
    return $LineupCopyWith<$Res>(_value.lineup, (value) {
      return _then(_value.copyWith(lineup: value) as $Val);
    });
  }

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_value.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_value.weightClass!, (value) {
      return _then(_value.copyWith(weightClass: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParticipationImplCopyWith<$Res> implements $ParticipationCopyWith<$Res> {
  factory _$$ParticipationImplCopyWith(_$ParticipationImpl value, $Res Function(_$ParticipationImpl) then) =
      __$$ParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Membership membership, Lineup lineup, WeightClass? weightClass, double? weight});

  @override
  $MembershipCopyWith<$Res> get membership;
  @override
  $LineupCopyWith<$Res> get lineup;
  @override
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class __$$ParticipationImplCopyWithImpl<$Res> extends _$ParticipationCopyWithImpl<$Res, _$ParticipationImpl>
    implements _$$ParticipationImplCopyWith<$Res> {
  __$$ParticipationImplCopyWithImpl(_$ParticipationImpl _value, $Res Function(_$ParticipationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? membership = null,
    Object? lineup = null,
    Object? weightClass = freezed,
    Object? weight = freezed,
  }) {
    return _then(_$ParticipationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      membership: null == membership
          ? _value.membership
          : membership // ignore: cast_nullable_to_non_nullable
              as Membership,
      lineup: null == lineup
          ? _value.lineup
          : lineup // ignore: cast_nullable_to_non_nullable
              as Lineup,
      weightClass: freezed == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipationImpl extends _Participation {
  const _$ParticipationImpl({this.id, required this.membership, required this.lineup, this.weightClass, this.weight})
      : super._();

  factory _$ParticipationImpl.fromJson(Map<String, dynamic> json) => _$$ParticipationImplFromJson(json);

  @override
  final int? id;
  @override
  final Membership membership;
  @override
  final Lineup lineup;
  @override
  final WeightClass? weightClass;
  @override
  final double? weight;

  @override
  String toString() {
    return 'Participation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membership, membership) || other.membership == membership) &&
            (identical(other.lineup, lineup) || other.lineup == lineup) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, membership, lineup, weightClass, weight);

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith =>
      __$$ParticipationImplCopyWithImpl<_$ParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipationImplToJson(
      this,
    );
  }
}

abstract class _Participation extends Participation {
  const factory _Participation(
      {final int? id,
      required final Membership membership,
      required final Lineup lineup,
      final WeightClass? weightClass,
      final double? weight}) = _$ParticipationImpl;
  const _Participation._() : super._();

  factory _Participation.fromJson(Map<String, dynamic> json) = _$ParticipationImpl.fromJson;

  @override
  int? get id;
  @override
  Membership get membership;
  @override
  Lineup get lineup;
  @override
  WeightClass? get weightClass;
  @override
  double? get weight;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipationImplCopyWith<_$ParticipationImpl> get copyWith => throw _privateConstructorUsedError;
}
