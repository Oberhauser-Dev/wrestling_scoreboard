// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_team_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeagueTeamParticipation {

 int? get id; League get league; Team get team;
/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeagueTeamParticipationCopyWith<LeagueTeamParticipation> get copyWith => _$LeagueTeamParticipationCopyWithImpl<LeagueTeamParticipation>(this as LeagueTeamParticipation, _$identity);

  /// Serializes this LeagueTeamParticipation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeagueTeamParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.league, league) || other.league == league)&&(identical(other.team, team) || other.team == team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,league,team);

@override
String toString() {
  return 'LeagueTeamParticipation(id: $id, league: $league, team: $team)';
}


}

/// @nodoc
abstract mixin class $LeagueTeamParticipationCopyWith<$Res>  {
  factory $LeagueTeamParticipationCopyWith(LeagueTeamParticipation value, $Res Function(LeagueTeamParticipation) _then) = _$LeagueTeamParticipationCopyWithImpl;
@useResult
$Res call({
 int? id, League league, Team team
});


$LeagueCopyWith<$Res> get league;$TeamCopyWith<$Res> get team;

}
/// @nodoc
class _$LeagueTeamParticipationCopyWithImpl<$Res>
    implements $LeagueTeamParticipationCopyWith<$Res> {
  _$LeagueTeamParticipationCopyWithImpl(this._self, this._then);

  final LeagueTeamParticipation _self;
  final $Res Function(LeagueTeamParticipation) _then;

/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? league = null,Object? team = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,league: null == league ? _self.league : league // ignore: cast_nullable_to_non_nullable
as League,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as Team,
  ));
}
/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeagueCopyWith<$Res> get league {
  
  return $LeagueCopyWith<$Res>(_self.league, (value) {
    return _then(_self.copyWith(league: value));
  });
}/// Create a copy of LeagueTeamParticipation
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

class _LeagueTeamParticipation extends LeagueTeamParticipation {
  const _LeagueTeamParticipation({this.id, required this.league, required this.team}): super._();
  factory _LeagueTeamParticipation.fromJson(Map<String, dynamic> json) => _$LeagueTeamParticipationFromJson(json);

@override final  int? id;
@override final  League league;
@override final  Team team;

/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeagueTeamParticipationCopyWith<_LeagueTeamParticipation> get copyWith => __$LeagueTeamParticipationCopyWithImpl<_LeagueTeamParticipation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeagueTeamParticipationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeagueTeamParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.league, league) || other.league == league)&&(identical(other.team, team) || other.team == team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,league,team);

@override
String toString() {
  return 'LeagueTeamParticipation(id: $id, league: $league, team: $team)';
}


}

/// @nodoc
abstract mixin class _$LeagueTeamParticipationCopyWith<$Res> implements $LeagueTeamParticipationCopyWith<$Res> {
  factory _$LeagueTeamParticipationCopyWith(_LeagueTeamParticipation value, $Res Function(_LeagueTeamParticipation) _then) = __$LeagueTeamParticipationCopyWithImpl;
@override @useResult
$Res call({
 int? id, League league, Team team
});


@override $LeagueCopyWith<$Res> get league;@override $TeamCopyWith<$Res> get team;

}
/// @nodoc
class __$LeagueTeamParticipationCopyWithImpl<$Res>
    implements _$LeagueTeamParticipationCopyWith<$Res> {
  __$LeagueTeamParticipationCopyWithImpl(this._self, this._then);

  final _LeagueTeamParticipation _self;
  final $Res Function(_LeagueTeamParticipation) _then;

/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? league = null,Object? team = null,}) {
  return _then(_LeagueTeamParticipation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,league: null == league ? _self.league : league // ignore: cast_nullable_to_non_nullable
as League,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as Team,
  ));
}

/// Create a copy of LeagueTeamParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeagueCopyWith<$Res> get league {
  
  return $LeagueCopyWith<$Res>(_self.league, (value) {
    return _then(_self.copyWith(league: value));
  });
}/// Create a copy of LeagueTeamParticipation
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
