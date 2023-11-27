// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_team_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TournamentTeamParticipation _$TournamentTeamParticipationFromJson(
    Map<String, dynamic> json) {
  return _TournamentTeamParticipation.fromJson(json);
}

/// @nodoc
mixin _$TournamentTeamParticipation {
  int? get id => throw _privateConstructorUsedError;
  Tournament get tournament => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentTeamParticipationCopyWith<TournamentTeamParticipation>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentTeamParticipationCopyWith<$Res> {
  factory $TournamentTeamParticipationCopyWith(
          TournamentTeamParticipation value,
          $Res Function(TournamentTeamParticipation) then) =
      _$TournamentTeamParticipationCopyWithImpl<$Res,
          TournamentTeamParticipation>;
  @useResult
  $Res call({int? id, Tournament tournament, Team team});

  $TournamentCopyWith<$Res> get tournament;
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class _$TournamentTeamParticipationCopyWithImpl<$Res,
        $Val extends TournamentTeamParticipation>
    implements $TournamentTeamParticipationCopyWith<$Res> {
  _$TournamentTeamParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? team = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tournament: null == tournament
          ? _value.tournament
          : tournament // ignore: cast_nullable_to_non_nullable
              as Tournament,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TournamentCopyWith<$Res> get tournament {
    return $TournamentCopyWith<$Res>(_value.tournament, (value) {
      return _then(_value.copyWith(tournament: value) as $Val);
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
abstract class _$$TournamentTeamParticipationImplCopyWith<$Res>
    implements $TournamentTeamParticipationCopyWith<$Res> {
  factory _$$TournamentTeamParticipationImplCopyWith(
          _$TournamentTeamParticipationImpl value,
          $Res Function(_$TournamentTeamParticipationImpl) then) =
      __$$TournamentTeamParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Tournament tournament, Team team});

  @override
  $TournamentCopyWith<$Res> get tournament;
  @override
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class __$$TournamentTeamParticipationImplCopyWithImpl<$Res>
    extends _$TournamentTeamParticipationCopyWithImpl<$Res,
        _$TournamentTeamParticipationImpl>
    implements _$$TournamentTeamParticipationImplCopyWith<$Res> {
  __$$TournamentTeamParticipationImplCopyWithImpl(
      _$TournamentTeamParticipationImpl _value,
      $Res Function(_$TournamentTeamParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? team = null,
  }) {
    return _then(_$TournamentTeamParticipationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tournament: null == tournament
          ? _value.tournament
          : tournament // ignore: cast_nullable_to_non_nullable
              as Tournament,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentTeamParticipationImpl extends _TournamentTeamParticipation {
  const _$TournamentTeamParticipationImpl(
      {this.id, required this.tournament, required this.team})
      : super._();

  factory _$TournamentTeamParticipationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TournamentTeamParticipationImplFromJson(json);

  @override
  final int? id;
  @override
  final Tournament tournament;
  @override
  final Team team;

  @override
  String toString() {
    return 'TournamentTeamParticipation(id: $id, tournament: $tournament, team: $team)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentTeamParticipationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournament, tournament) ||
                other.tournament == tournament) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournament, team);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentTeamParticipationImplCopyWith<_$TournamentTeamParticipationImpl>
      get copyWith => __$$TournamentTeamParticipationImplCopyWithImpl<
          _$TournamentTeamParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentTeamParticipationImplToJson(
      this,
    );
  }
}

abstract class _TournamentTeamParticipation
    extends TournamentTeamParticipation {
  const factory _TournamentTeamParticipation(
      {final int? id,
      required final Tournament tournament,
      required final Team team}) = _$TournamentTeamParticipationImpl;
  const _TournamentTeamParticipation._() : super._();

  factory _TournamentTeamParticipation.fromJson(Map<String, dynamic> json) =
      _$TournamentTeamParticipationImpl.fromJson;

  @override
  int? get id;
  @override
  Tournament get tournament;
  @override
  Team get team;
  @override
  @JsonKey(ignore: true)
  _$$TournamentTeamParticipationImplCopyWith<_$TournamentTeamParticipationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
