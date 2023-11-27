// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match_fight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TeamMatchFight _$TeamMatchFightFromJson(Map<String, dynamic> json) {
  return _TeamMatchFight.fromJson(json);
}

/// @nodoc
mixin _$TeamMatchFight {
  int? get id => throw _privateConstructorUsedError;
  TeamMatch get teamMatch => throw _privateConstructorUsedError;
  Fight get fight => throw _privateConstructorUsedError;
  int get pos => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamMatchFightCopyWith<TeamMatchFight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMatchFightCopyWith<$Res> {
  factory $TeamMatchFightCopyWith(
          TeamMatchFight value, $Res Function(TeamMatchFight) then) =
      _$TeamMatchFightCopyWithImpl<$Res, TeamMatchFight>;
  @useResult
  $Res call({int? id, TeamMatch teamMatch, Fight fight, int pos});

  $TeamMatchCopyWith<$Res> get teamMatch;
  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class _$TeamMatchFightCopyWithImpl<$Res, $Val extends TeamMatchFight>
    implements $TeamMatchFightCopyWith<$Res> {
  _$TeamMatchFightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? teamMatch = null,
    Object? fight = null,
    Object? pos = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      teamMatch: null == teamMatch
          ? _value.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamMatchCopyWith<$Res> get teamMatch {
    return $TeamMatchCopyWith<$Res>(_value.teamMatch, (value) {
      return _then(_value.copyWith(teamMatch: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FightCopyWith<$Res> get fight {
    return $FightCopyWith<$Res>(_value.fight, (value) {
      return _then(_value.copyWith(fight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamMatchFightImplCopyWith<$Res>
    implements $TeamMatchFightCopyWith<$Res> {
  factory _$$TeamMatchFightImplCopyWith(_$TeamMatchFightImpl value,
          $Res Function(_$TeamMatchFightImpl) then) =
      __$$TeamMatchFightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, TeamMatch teamMatch, Fight fight, int pos});

  @override
  $TeamMatchCopyWith<$Res> get teamMatch;
  @override
  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class __$$TeamMatchFightImplCopyWithImpl<$Res>
    extends _$TeamMatchFightCopyWithImpl<$Res, _$TeamMatchFightImpl>
    implements _$$TeamMatchFightImplCopyWith<$Res> {
  __$$TeamMatchFightImplCopyWithImpl(
      _$TeamMatchFightImpl _value, $Res Function(_$TeamMatchFightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? teamMatch = null,
    Object? fight = null,
    Object? pos = null,
  }) {
    return _then(_$TeamMatchFightImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      teamMatch: null == teamMatch
          ? _value.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMatchFightImpl extends _TeamMatchFight {
  const _$TeamMatchFightImpl(
      {this.id,
      required this.teamMatch,
      required this.fight,
      required this.pos})
      : super._();

  factory _$TeamMatchFightImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamMatchFightImplFromJson(json);

  @override
  final int? id;
  @override
  final TeamMatch teamMatch;
  @override
  final Fight fight;
  @override
  final int pos;

  @override
  String toString() {
    return 'TeamMatchFight(id: $id, teamMatch: $teamMatch, fight: $fight, pos: $pos)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMatchFightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamMatch, teamMatch) ||
                other.teamMatch == teamMatch) &&
            (identical(other.fight, fight) || other.fight == fight) &&
            (identical(other.pos, pos) || other.pos == pos));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, teamMatch, fight, pos);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMatchFightImplCopyWith<_$TeamMatchFightImpl> get copyWith =>
      __$$TeamMatchFightImplCopyWithImpl<_$TeamMatchFightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMatchFightImplToJson(
      this,
    );
  }
}

abstract class _TeamMatchFight extends TeamMatchFight {
  const factory _TeamMatchFight(
      {final int? id,
      required final TeamMatch teamMatch,
      required final Fight fight,
      required final int pos}) = _$TeamMatchFightImpl;
  const _TeamMatchFight._() : super._();

  factory _TeamMatchFight.fromJson(Map<String, dynamic> json) =
      _$TeamMatchFightImpl.fromJson;

  @override
  int? get id;
  @override
  TeamMatch get teamMatch;
  @override
  Fight get fight;
  @override
  int get pos;
  @override
  @JsonKey(ignore: true)
  _$$TeamMatchFightImplCopyWith<_$TeamMatchFightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
