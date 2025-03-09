// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamLineup {
  int? get id;
  Team get team;
  Membership? get leader; // Mannschaftsführer
  Membership? get coach;

  /// Create a copy of TeamLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamLineupCopyWith<TeamLineup> get copyWith => _$TeamLineupCopyWithImpl<TeamLineup>(this as TeamLineup, _$identity);

  /// Serializes this TeamLineup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamLineup &&
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
    return 'TeamLineup(id: $id, team: $team, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class $TeamLineupCopyWith<$Res> {
  factory $TeamLineupCopyWith(TeamLineup value, $Res Function(TeamLineup) _then) = _$TeamLineupCopyWithImpl;
  @useResult
  $Res call({int? id, Team team, Membership? leader, Membership? coach});

  $TeamCopyWith<$Res> get team;
  $MembershipCopyWith<$Res>? get leader;
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class _$TeamLineupCopyWithImpl<$Res> implements $TeamLineupCopyWith<$Res> {
  _$TeamLineupCopyWithImpl(this._self, this._then);

  final TeamLineup _self;
  final $Res Function(TeamLineup) _then;

  /// Create a copy of TeamLineup
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

  /// Create a copy of TeamLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of TeamLineup
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

  /// Create a copy of TeamLineup
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
class _TeamLineup extends TeamLineup {
  const _TeamLineup({this.id, required this.team, this.leader, this.coach}) : super._();
  factory _TeamLineup.fromJson(Map<String, dynamic> json) => _$TeamLineupFromJson(json);

  @override
  final int? id;
  @override
  final Team team;
  @override
  final Membership? leader;
// Mannschaftsführer
  @override
  final Membership? coach;

  /// Create a copy of TeamLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamLineupCopyWith<_TeamLineup> get copyWith => __$TeamLineupCopyWithImpl<_TeamLineup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamLineupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamLineup &&
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
    return 'TeamLineup(id: $id, team: $team, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class _$TeamLineupCopyWith<$Res> implements $TeamLineupCopyWith<$Res> {
  factory _$TeamLineupCopyWith(_TeamLineup value, $Res Function(_TeamLineup) _then) = __$TeamLineupCopyWithImpl;
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
class __$TeamLineupCopyWithImpl<$Res> implements _$TeamLineupCopyWith<$Res> {
  __$TeamLineupCopyWithImpl(this._self, this._then);

  final _TeamLineup _self;
  final $Res Function(_TeamLineup) _then;

  /// Create a copy of TeamLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_TeamLineup(
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

  /// Create a copy of TeamLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of TeamLineup
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

  /// Create a copy of TeamLineup
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
