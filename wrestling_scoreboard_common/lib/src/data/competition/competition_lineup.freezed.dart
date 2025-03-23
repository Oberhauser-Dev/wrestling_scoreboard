// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionLineup {
  int? get id;
  Competition get competition;
  Club get club;
  Membership? get leader; // Mannschaftsführer
  Membership? get coach;

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionLineupCopyWith<CompetitionLineup> get copyWith =>
      _$CompetitionLineupCopyWithImpl<CompetitionLineup>(
          this as CompetitionLineup, _$identity);

  /// Serializes this CompetitionLineup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompetitionLineup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.club, club) || other.club == club) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.coach, coach) || other.coach == coach));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, competition, club, leader, coach);

  @override
  String toString() {
    return 'CompetitionLineup(id: $id, competition: $competition, club: $club, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class $CompetitionLineupCopyWith<$Res> {
  factory $CompetitionLineupCopyWith(
          CompetitionLineup value, $Res Function(CompetitionLineup) _then) =
      _$CompetitionLineupCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      Competition competition,
      Club club,
      Membership? leader,
      Membership? coach});

  $CompetitionCopyWith<$Res> get competition;
  $ClubCopyWith<$Res> get club;
  $MembershipCopyWith<$Res>? get leader;
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class _$CompetitionLineupCopyWithImpl<$Res>
    implements $CompetitionLineupCopyWith<$Res> {
  _$CompetitionLineupCopyWithImpl(this._self, this._then);

  final CompetitionLineup _self;
  final $Res Function(CompetitionLineup) _then;

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? club = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      club: null == club
          ? _self.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
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

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_self.club, (value) {
      return _then(_self.copyWith(club: value));
    });
  }

  /// Create a copy of CompetitionLineup
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

  /// Create a copy of CompetitionLineup
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
class _CompetitionLineup extends CompetitionLineup {
  const _CompetitionLineup(
      {this.id,
      required this.competition,
      required this.club,
      this.leader,
      this.coach})
      : super._();
  factory _CompetitionLineup.fromJson(Map<String, dynamic> json) =>
      _$CompetitionLineupFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Club club;
  @override
  final Membership? leader;
// Mannschaftsführer
  @override
  final Membership? coach;

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionLineupCopyWith<_CompetitionLineup> get copyWith =>
      __$CompetitionLineupCopyWithImpl<_CompetitionLineup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionLineupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompetitionLineup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.club, club) || other.club == club) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.coach, coach) || other.coach == coach));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, competition, club, leader, coach);

  @override
  String toString() {
    return 'CompetitionLineup(id: $id, competition: $competition, club: $club, leader: $leader, coach: $coach)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionLineupCopyWith<$Res>
    implements $CompetitionLineupCopyWith<$Res> {
  factory _$CompetitionLineupCopyWith(
          _CompetitionLineup value, $Res Function(_CompetitionLineup) _then) =
      __$CompetitionLineupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      Competition competition,
      Club club,
      Membership? leader,
      Membership? coach});

  @override
  $CompetitionCopyWith<$Res> get competition;
  @override
  $ClubCopyWith<$Res> get club;
  @override
  $MembershipCopyWith<$Res>? get leader;
  @override
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class __$CompetitionLineupCopyWithImpl<$Res>
    implements _$CompetitionLineupCopyWith<$Res> {
  __$CompetitionLineupCopyWithImpl(this._self, this._then);

  final _CompetitionLineup _self;
  final $Res Function(_CompetitionLineup) _then;

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? club = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_CompetitionLineup(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      club: null == club
          ? _self.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
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

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_self.club, (value) {
      return _then(_self.copyWith(club: value));
    });
  }

  /// Create a copy of CompetitionLineup
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

  /// Create a copy of CompetitionLineup
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
