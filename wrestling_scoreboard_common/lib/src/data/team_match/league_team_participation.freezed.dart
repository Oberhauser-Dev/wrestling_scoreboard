// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_team_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LeagueTeamParticipation _$LeagueTeamParticipationFromJson(
    Map<String, dynamic> json) {
  return _LeagueTeamParticipation.fromJson(json);
}

/// @nodoc
mixin _$LeagueTeamParticipation {
  int? get id => throw _privateConstructorUsedError;
  League get league => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeagueTeamParticipationCopyWith<LeagueTeamParticipation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueTeamParticipationCopyWith<$Res> {
  factory $LeagueTeamParticipationCopyWith(LeagueTeamParticipation value,
          $Res Function(LeagueTeamParticipation) then) =
      _$LeagueTeamParticipationCopyWithImpl<$Res, LeagueTeamParticipation>;
  @useResult
  $Res call({int? id, League league, Team team});

  $LeagueCopyWith<$Res> get league;
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class _$LeagueTeamParticipationCopyWithImpl<$Res,
        $Val extends LeagueTeamParticipation>
    implements $LeagueTeamParticipationCopyWith<$Res> {
  _$LeagueTeamParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? league = null,
    Object? team = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res> get league {
    return $LeagueCopyWith<$Res>(_value.league, (value) {
      return _then(_value.copyWith(league: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_value.team, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueTeamParticipationImplCopyWith<$Res>
    implements $LeagueTeamParticipationCopyWith<$Res> {
  factory _$$LeagueTeamParticipationImplCopyWith(
          _$LeagueTeamParticipationImpl value,
          $Res Function(_$LeagueTeamParticipationImpl) then) =
      __$$LeagueTeamParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, League league, Team team});

  @override
  $LeagueCopyWith<$Res> get league;
  @override
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class __$$LeagueTeamParticipationImplCopyWithImpl<$Res>
    extends _$LeagueTeamParticipationCopyWithImpl<$Res,
        _$LeagueTeamParticipationImpl>
    implements _$$LeagueTeamParticipationImplCopyWith<$Res> {
  __$$LeagueTeamParticipationImplCopyWithImpl(
      _$LeagueTeamParticipationImpl _value,
      $Res Function(_$LeagueTeamParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? league = null,
    Object? team = null,
  }) {
    return _then(_$LeagueTeamParticipationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueTeamParticipationImpl extends _LeagueTeamParticipation {
  const _$LeagueTeamParticipationImpl(
      {this.id, required this.league, required this.team})
      : super._();

  factory _$LeagueTeamParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueTeamParticipationImplFromJson(json);

  @override
  final int? id;
  @override
  final League league;
  @override
  final Team team;

  @override
  String toString() {
    return 'LeagueTeamParticipation(id: $id, league: $league, team: $team)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueTeamParticipationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, league, team);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueTeamParticipationImplCopyWith<_$LeagueTeamParticipationImpl>
      get copyWith => __$$LeagueTeamParticipationImplCopyWithImpl<
          _$LeagueTeamParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueTeamParticipationImplToJson(
      this,
    );
  }
}

abstract class _LeagueTeamParticipation extends LeagueTeamParticipation {
  const factory _LeagueTeamParticipation(
      {final int? id,
      required final League league,
      required final Team team}) = _$LeagueTeamParticipationImpl;
  const _LeagueTeamParticipation._() : super._();

  factory _LeagueTeamParticipation.fromJson(Map<String, dynamic> json) =
      _$LeagueTeamParticipationImpl.fromJson;

  @override
  int? get id;
  @override
  League get league;
  @override
  Team get team;
  @override
  @JsonKey(ignore: true)
  _$$LeagueTeamParticipationImplCopyWith<_$LeagueTeamParticipationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
