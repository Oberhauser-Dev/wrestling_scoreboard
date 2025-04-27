// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMatchParticipation {
  int? get id;
  Membership get membership;
  TeamLineup get lineup;
  WeightClass? get weightClass;
  double? get weight;

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamMatchParticipationCopyWith<TeamMatchParticipation> get copyWith =>
      _$TeamMatchParticipationCopyWithImpl<TeamMatchParticipation>(
          this as TeamMatchParticipation, _$identity);

  /// Serializes this TeamMatchParticipation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamMatchParticipation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membership, membership) ||
                other.membership == membership) &&
            (identical(other.lineup, lineup) || other.lineup == lineup) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, membership, lineup, weightClass, weight);

  @override
  String toString() {
    return 'TeamMatchParticipation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
  }
}

/// @nodoc
abstract mixin class $TeamMatchParticipationCopyWith<$Res> {
  factory $TeamMatchParticipationCopyWith(TeamMatchParticipation value,
          $Res Function(TeamMatchParticipation) _then) =
      _$TeamMatchParticipationCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      Membership membership,
      TeamLineup lineup,
      WeightClass? weightClass,
      double? weight});

  $MembershipCopyWith<$Res> get membership;
  $TeamLineupCopyWith<$Res> get lineup;
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class _$TeamMatchParticipationCopyWithImpl<$Res>
    implements $TeamMatchParticipationCopyWith<$Res> {
  _$TeamMatchParticipationCopyWithImpl(this._self, this._then);

  final TeamMatchParticipation _self;
  final $Res Function(TeamMatchParticipation) _then;

  /// Create a copy of TeamMatchParticipation
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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      membership: null == membership
          ? _self.membership
          : membership // ignore: cast_nullable_to_non_nullable
              as Membership,
      lineup: null == lineup
          ? _self.lineup
          : lineup // ignore: cast_nullable_to_non_nullable
              as TeamLineup,
      weightClass: freezed == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res> get membership {
    return $MembershipCopyWith<$Res>(_self.membership, (value) {
      return _then(_self.copyWith(membership: value));
    });
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamLineupCopyWith<$Res> get lineup {
    return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
      return _then(_self.copyWith(lineup: value));
    });
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TeamMatchParticipation extends TeamMatchParticipation {
  const _TeamMatchParticipation(
      {this.id,
      required this.membership,
      required this.lineup,
      this.weightClass,
      this.weight})
      : super._();
  factory _TeamMatchParticipation.fromJson(Map<String, dynamic> json) =>
      _$TeamMatchParticipationFromJson(json);

  @override
  final int? id;
  @override
  final Membership membership;
  @override
  final TeamLineup lineup;
  @override
  final WeightClass? weightClass;
  @override
  final double? weight;

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamMatchParticipationCopyWith<_TeamMatchParticipation> get copyWith =>
      __$TeamMatchParticipationCopyWithImpl<_TeamMatchParticipation>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamMatchParticipationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamMatchParticipation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membership, membership) ||
                other.membership == membership) &&
            (identical(other.lineup, lineup) || other.lineup == lineup) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, membership, lineup, weightClass, weight);

  @override
  String toString() {
    return 'TeamMatchParticipation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
  }
}

/// @nodoc
abstract mixin class _$TeamMatchParticipationCopyWith<$Res>
    implements $TeamMatchParticipationCopyWith<$Res> {
  factory _$TeamMatchParticipationCopyWith(_TeamMatchParticipation value,
          $Res Function(_TeamMatchParticipation) _then) =
      __$TeamMatchParticipationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      Membership membership,
      TeamLineup lineup,
      WeightClass? weightClass,
      double? weight});

  @override
  $MembershipCopyWith<$Res> get membership;
  @override
  $TeamLineupCopyWith<$Res> get lineup;
  @override
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class __$TeamMatchParticipationCopyWithImpl<$Res>
    implements _$TeamMatchParticipationCopyWith<$Res> {
  __$TeamMatchParticipationCopyWithImpl(this._self, this._then);

  final _TeamMatchParticipation _self;
  final $Res Function(_TeamMatchParticipation) _then;

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? membership = null,
    Object? lineup = null,
    Object? weightClass = freezed,
    Object? weight = freezed,
  }) {
    return _then(_TeamMatchParticipation(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      membership: null == membership
          ? _self.membership
          : membership // ignore: cast_nullable_to_non_nullable
              as Membership,
      lineup: null == lineup
          ? _self.lineup
          : lineup // ignore: cast_nullable_to_non_nullable
              as TeamLineup,
      weightClass: freezed == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res> get membership {
    return $MembershipCopyWith<$Res>(_self.membership, (value) {
      return _then(_self.copyWith(membership: value));
    });
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamLineupCopyWith<$Res> get lineup {
    return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
      return _then(_self.copyWith(lineup: value));
    });
  }

  /// Create a copy of TeamMatchParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

// dart format on
