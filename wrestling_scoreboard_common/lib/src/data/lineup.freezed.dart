// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lineup {
  int? get id;
  Team get team;
  Membership? get leader; // Mannschaftsführer
  Membership? get coach;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LineupCopyWith<Lineup> get copyWith => _$LineupCopyWithImpl<Lineup>(this as Lineup, _$identity);

  /// Serializes this Lineup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Lineup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.coach, coach) || other.coach == coach));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, leader, coach);

  @override
  String toString() {
    return 'Lineup(id: $id, team: $team, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class $LineupCopyWith<$Res> {
  factory $LineupCopyWith(Lineup value, $Res Function(Lineup) _then) = _$LineupCopyWithImpl;
  @useResult
  $Res call({int? id, Team team, Membership? leader, Membership? coach});

  $TeamCopyWith<$Res> get team;
  $MembershipCopyWith<$Res>? get leader;
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class _$LineupCopyWithImpl<$Res> implements $LineupCopyWith<$Res> {
  _$LineupCopyWithImpl(this._self, this._then);

  final Lineup _self;
  final $Res Function(Lineup) _then;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      leader: freezed == leader
          ? _self.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as Membership?,
      coach: freezed == coach
          ? _self.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as Membership?,
    ));
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get leader {
    if (_self.leader == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_self.leader!, (value) {
      return _then(_self.copyWith(leader: value));
    });
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get coach {
    if (_self.coach == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_self.coach!, (value) {
      return _then(_self.copyWith(coach: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Lineup extends Lineup {
  const _Lineup({this.id, required this.team, this.leader, this.coach}) : super._();
  factory _Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);

  @override
  final int? id;
  @override
  final Team team;
  @override
  final Membership? leader;
// Mannschaftsführer
  @override
  final Membership? coach;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LineupCopyWith<_Lineup> get copyWith => __$LineupCopyWithImpl<_Lineup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LineupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Lineup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.coach, coach) || other.coach == coach));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, leader, coach);

  @override
  String toString() {
    return 'Lineup(id: $id, team: $team, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class _$LineupCopyWith<$Res> implements $LineupCopyWith<$Res> {
  factory _$LineupCopyWith(_Lineup value, $Res Function(_Lineup) _then) = __$LineupCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, Team team, Membership? leader, Membership? coach});

  @override
  $TeamCopyWith<$Res> get team;
  @override
  $MembershipCopyWith<$Res>? get leader;
  @override
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class __$LineupCopyWithImpl<$Res> implements _$LineupCopyWith<$Res> {
  __$LineupCopyWithImpl(this._self, this._then);

  final _Lineup _self;
  final $Res Function(_Lineup) _then;

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_Lineup(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      leader: freezed == leader
          ? _self.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as Membership?,
      coach: freezed == coach
          ? _self.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as Membership?,
    ));
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get leader {
    if (_self.leader == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_self.leader!, (value) {
      return _then(_self.copyWith(leader: value));
    });
  }

  /// Create a copy of Lineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get coach {
    if (_self.coach == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_self.coach!, (value) {
      return _then(_self.copyWith(coach: value));
    });
  }
}

// dart format on
