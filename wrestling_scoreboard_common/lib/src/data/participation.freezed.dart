// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Participation {
  int? get id;
  Membership get membership;
  Lineup get lineup;
  WeightClass? get weightClass;
  double? get weight;

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipationCopyWith<Participation> get copyWith =>
      _$ParticipationCopyWithImpl<Participation>(this as Participation, _$identity);

  /// Serializes this Participation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Participation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membership, membership) || other.membership == membership) &&
            (identical(other.lineup, lineup) || other.lineup == lineup) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, membership, lineup, weightClass, weight);

  @override
  String toString() {
    return 'Participation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
  }
}

/// @nodoc
abstract mixin class $ParticipationCopyWith<$Res> {
  factory $ParticipationCopyWith(Participation value, $Res Function(Participation) _then) = _$ParticipationCopyWithImpl;
  @useResult
  $Res call({int? id, Membership membership, Lineup lineup, WeightClass? weightClass, double? weight});

  $MembershipCopyWith<$Res> get membership;
  $LineupCopyWith<$Res> get lineup;
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class _$ParticipationCopyWithImpl<$Res> implements $ParticipationCopyWith<$Res> {
  _$ParticipationCopyWithImpl(this._self, this._then);

  final Participation _self;
  final $Res Function(Participation) _then;

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
              as Lineup,
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

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res> get membership {
    return $MembershipCopyWith<$Res>(_self.membership, (value) {
      return _then(_self.copyWith(membership: value));
    });
  }

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get lineup {
    return $LineupCopyWith<$Res>(_self.lineup, (value) {
      return _then(_self.copyWith(lineup: value));
    });
  }

  /// Create a copy of Participation
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
class _Participation extends Participation {
  const _Participation({this.id, required this.membership, required this.lineup, this.weightClass, this.weight})
      : super._();
  factory _Participation.fromJson(Map<String, dynamic> json) => _$ParticipationFromJson(json);

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

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipationCopyWith<_Participation> get copyWith =>
      __$ParticipationCopyWithImpl<_Participation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Participation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membership, membership) || other.membership == membership) &&
            (identical(other.lineup, lineup) || other.lineup == lineup) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, membership, lineup, weightClass, weight);

  @override
  String toString() {
    return 'Participation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
  }
}

/// @nodoc
abstract mixin class _$ParticipationCopyWith<$Res> implements $ParticipationCopyWith<$Res> {
  factory _$ParticipationCopyWith(_Participation value, $Res Function(_Participation) _then) =
      __$ParticipationCopyWithImpl;
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
class __$ParticipationCopyWithImpl<$Res> implements _$ParticipationCopyWith<$Res> {
  __$ParticipationCopyWithImpl(this._self, this._then);

  final _Participation _self;
  final $Res Function(_Participation) _then;

  /// Create a copy of Participation
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
    return _then(_Participation(
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
              as Lineup,
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

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res> get membership {
    return $MembershipCopyWith<$Res>(_self.membership, (value) {
      return _then(_self.copyWith(membership: value));
    });
  }

  /// Create a copy of Participation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LineupCopyWith<$Res> get lineup {
    return $LineupCopyWith<$Res>(_self.lineup, (value) {
      return _then(_self.copyWith(lineup: value));
    });
  }

  /// Create a copy of Participation
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
