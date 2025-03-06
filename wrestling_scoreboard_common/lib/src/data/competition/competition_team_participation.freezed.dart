// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_team_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionTeamParticipation {
  int? get id;
  Competition get competition;
  Team get team;

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionTeamParticipationCopyWith<CompetitionTeamParticipation> get copyWith =>
      _$CompetitionTeamParticipationCopyWithImpl<CompetitionTeamParticipation>(
          this as CompetitionTeamParticipation, _$identity);

  /// Serializes this CompetitionTeamParticipation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompetitionTeamParticipation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) || other.competition == competition) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, team);

  @override
  String toString() {
    return 'CompetitionTeamParticipation(id: $id, competition: $competition, team: $team)';
  }
}

/// @nodoc
abstract mixin class $CompetitionTeamParticipationCopyWith<$Res> {
  factory $CompetitionTeamParticipationCopyWith(
          CompetitionTeamParticipation value, $Res Function(CompetitionTeamParticipation) _then) =
      _$CompetitionTeamParticipationCopyWithImpl;
  @useResult
  $Res call({int? id, Competition competition, Team team});

  $CompetitionCopyWith<$Res> get competition;
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class _$CompetitionTeamParticipationCopyWithImpl<$Res> implements $CompetitionTeamParticipationCopyWith<$Res> {
  _$CompetitionTeamParticipationCopyWithImpl(this._self, this._then);

  final CompetitionTeamParticipation _self;
  final $Res Function(CompetitionTeamParticipation) _then;

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? team = null,
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
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CompetitionTeamParticipation extends CompetitionTeamParticipation {
  const _CompetitionTeamParticipation({this.id, required this.competition, required this.team}) : super._();
  factory _CompetitionTeamParticipation.fromJson(Map<String, dynamic> json) =>
      _$CompetitionTeamParticipationFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Team team;

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionTeamParticipationCopyWith<_CompetitionTeamParticipation> get copyWith =>
      __$CompetitionTeamParticipationCopyWithImpl<_CompetitionTeamParticipation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionTeamParticipationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompetitionTeamParticipation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) || other.competition == competition) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, team);

  @override
  String toString() {
    return 'CompetitionTeamParticipation(id: $id, competition: $competition, team: $team)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionTeamParticipationCopyWith<$Res>
    implements $CompetitionTeamParticipationCopyWith<$Res> {
  factory _$CompetitionTeamParticipationCopyWith(
          _CompetitionTeamParticipation value, $Res Function(_CompetitionTeamParticipation) _then) =
      __$CompetitionTeamParticipationCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, Competition competition, Team team});

  @override
  $CompetitionCopyWith<$Res> get competition;
  @override
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class __$CompetitionTeamParticipationCopyWithImpl<$Res> implements _$CompetitionTeamParticipationCopyWith<$Res> {
  __$CompetitionTeamParticipationCopyWithImpl(this._self, this._then);

  final _CompetitionTeamParticipation _self;
  final $Res Function(_CompetitionTeamParticipation) _then;

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? team = null,
  }) {
    return _then(_CompetitionTeamParticipation(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionTeamParticipation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_self.team, (value) {
      return _then(_self.copyWith(team: value));
    });
  }
}

// dart format on
