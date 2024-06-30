// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_team_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompetitionTeamParticipation _$CompetitionTeamParticipationFromJson(Map<String, dynamic> json) {
  return _CompetitionTeamParticipation.fromJson(json);
}

/// @nodoc
mixin _$CompetitionTeamParticipation {
  int? get id => throw _privateConstructorUsedError;

  Competition get competition => throw _privateConstructorUsedError;

  Team get team => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompetitionTeamParticipationCopyWith<CompetitionTeamParticipation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitionTeamParticipationCopyWith<$Res> {
  factory $CompetitionTeamParticipationCopyWith(
          CompetitionTeamParticipation value, $Res Function(CompetitionTeamParticipation) then) =
      _$CompetitionTeamParticipationCopyWithImpl<$Res, CompetitionTeamParticipation>;

  @useResult
  $Res call({int? id, Competition competition, Team team});

  $CompetitionCopyWith<$Res> get competition;

  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class _$CompetitionTeamParticipationCopyWithImpl<$Res, $Val extends CompetitionTeamParticipation>
    implements $CompetitionTeamParticipationCopyWith<$Res> {
  _$CompetitionTeamParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? team = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_value.competition, (value) {
      return _then(_value.copyWith(competition: value) as $Val);
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
abstract class _$$CompetitionTeamParticipationImplCopyWith<$Res>
    implements $CompetitionTeamParticipationCopyWith<$Res> {
  factory _$$CompetitionTeamParticipationImplCopyWith(
          _$CompetitionTeamParticipationImpl value, $Res Function(_$CompetitionTeamParticipationImpl) then) =
      __$$CompetitionTeamParticipationImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({int? id, Competition competition, Team team});

  @override
  $CompetitionCopyWith<$Res> get competition;

  @override
  $TeamCopyWith<$Res> get team;
}

/// @nodoc
class __$$CompetitionTeamParticipationImplCopyWithImpl<$Res>
    extends _$CompetitionTeamParticipationCopyWithImpl<$Res, _$CompetitionTeamParticipationImpl>
    implements _$$CompetitionTeamParticipationImplCopyWith<$Res> {
  __$$CompetitionTeamParticipationImplCopyWithImpl(
      _$CompetitionTeamParticipationImpl _value, $Res Function(_$CompetitionTeamParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? team = null,
  }) {
    return _then(_$CompetitionTeamParticipationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitionTeamParticipationImpl extends _CompetitionTeamParticipation {
  const _$CompetitionTeamParticipationImpl({this.id, required this.competition, required this.team}) : super._();

  factory _$CompetitionTeamParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitionTeamParticipationImplFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Team team;

  @override
  String toString() {
    return 'CompetitionTeamParticipation(id: $id, competition: $competition, team: $team)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitionTeamParticipationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) || other.competition == competition) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, team);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitionTeamParticipationImplCopyWith<_$CompetitionTeamParticipationImpl> get copyWith =>
      __$$CompetitionTeamParticipationImplCopyWithImpl<_$CompetitionTeamParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitionTeamParticipationImplToJson(
      this,
    );
  }
}

abstract class _CompetitionTeamParticipation extends CompetitionTeamParticipation {
  const factory _CompetitionTeamParticipation(
      {final int? id,
      required final Competition competition,
      required final Team team}) = _$CompetitionTeamParticipationImpl;

  const _CompetitionTeamParticipation._() : super._();

  factory _CompetitionTeamParticipation.fromJson(Map<String, dynamic> json) =
      _$CompetitionTeamParticipationImpl.fromJson;

  @override
  int? get id;

  @override
  Competition get competition;

  @override
  Team get team;

  @override
  @JsonKey(ignore: true)
  _$$CompetitionTeamParticipationImplCopyWith<_$CompetitionTeamParticipationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
