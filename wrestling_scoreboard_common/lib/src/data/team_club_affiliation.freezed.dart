// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_club_affiliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamClubAffiliation {
  int? get id;
  Team get team;
  Club get club;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamClubAffiliationCopyWith<TeamClubAffiliation> get copyWith =>
      _$TeamClubAffiliationCopyWithImpl<TeamClubAffiliation>(this as TeamClubAffiliation, _$identity);

  /// Serializes this TeamClubAffiliation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamClubAffiliation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.club, club) || other.club == club));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, club);

  @override
  String toString() {
    return 'TeamClubAffiliation(id: $id, team: $team, club: $club)';
  }
}

/// @nodoc
abstract mixin class $TeamClubAffiliationCopyWith<$Res> {
  factory $TeamClubAffiliationCopyWith(TeamClubAffiliation value, $Res Function(TeamClubAffiliation) _then) =
      _$TeamClubAffiliationCopyWithImpl;
  @useResult
  $Res call({int? id, Team team, Club club});

  $TeamCopyWith<$Res> get team;
  $ClubCopyWith<$Res> get club;
}

/// @nodoc
class _$TeamClubAffiliationCopyWithImpl<$Res> implements $TeamClubAffiliationCopyWith<$Res> {
  _$TeamClubAffiliationCopyWithImpl(this._self, this._then);

  final TeamClubAffiliation _self;
  final $Res Function(TeamClubAffiliation) _then;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? club = null,
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
      club: null == club
          ? _self.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
    ));
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_self.club, (value) {
      return _then(_self.copyWith(club: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TeamClubAffiliation extends TeamClubAffiliation {
  const _TeamClubAffiliation({this.id, required this.team, required this.club}) : super._();
  factory _TeamClubAffiliation.fromJson(Map<String, dynamic> json) => _$TeamClubAffiliationFromJson(json);

  @override
  final int? id;
  @override
  final Team team;
  @override
  final Club club;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamClubAffiliationCopyWith<_TeamClubAffiliation> get copyWith =>
      __$TeamClubAffiliationCopyWithImpl<_TeamClubAffiliation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamClubAffiliationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamClubAffiliation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.club, club) || other.club == club));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, club);

  @override
  String toString() {
    return 'TeamClubAffiliation(id: $id, team: $team, club: $club)';
  }
}

/// @nodoc
abstract mixin class _$TeamClubAffiliationCopyWith<$Res> implements $TeamClubAffiliationCopyWith<$Res> {
  factory _$TeamClubAffiliationCopyWith(_TeamClubAffiliation value, $Res Function(_TeamClubAffiliation) _then) =
      __$TeamClubAffiliationCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, Team team, Club club});

  @override
  $TeamCopyWith<$Res> get team;
  @override
  $ClubCopyWith<$Res> get club;
}

/// @nodoc
class __$TeamClubAffiliationCopyWithImpl<$Res> implements _$TeamClubAffiliationCopyWith<$Res> {
  __$TeamClubAffiliationCopyWithImpl(this._self, this._then);

  final _TeamClubAffiliation _self;
  final $Res Function(_TeamClubAffiliation) _then;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? club = null,
  }) {
    return _then(_TeamClubAffiliation(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      club: null == club
          ? _self.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
    ));
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_self.club, (value) {
      return _then(_self.copyWith(club: value));
    });
  }
}

// dart format on
