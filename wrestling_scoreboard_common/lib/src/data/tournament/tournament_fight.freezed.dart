// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_fight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TournamentFight _$TournamentFightFromJson(Map<String, dynamic> json) {
  return _TournamentFight.fromJson(json);
}

/// @nodoc
mixin _$TournamentFight {
  int? get id => throw _privateConstructorUsedError;
  Tournament get tournament => throw _privateConstructorUsedError;
  Fight get fight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentFightCopyWith<TournamentFight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentFightCopyWith<$Res> {
  factory $TournamentFightCopyWith(
          TournamentFight value, $Res Function(TournamentFight) then) =
      _$TournamentFightCopyWithImpl<$Res, TournamentFight>;
  @useResult
  $Res call({int? id, Tournament tournament, Fight fight});

  $TournamentCopyWith<$Res> get tournament;
  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class _$TournamentFightCopyWithImpl<$Res, $Val extends TournamentFight>
    implements $TournamentFightCopyWith<$Res> {
  _$TournamentFightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? fight = null,
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
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
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
  $FightCopyWith<$Res> get fight {
    return $FightCopyWith<$Res>(_value.fight, (value) {
      return _then(_value.copyWith(fight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TournamentFightImplCopyWith<$Res>
    implements $TournamentFightCopyWith<$Res> {
  factory _$$TournamentFightImplCopyWith(_$TournamentFightImpl value,
          $Res Function(_$TournamentFightImpl) then) =
      __$$TournamentFightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Tournament tournament, Fight fight});

  @override
  $TournamentCopyWith<$Res> get tournament;
  @override
  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class __$$TournamentFightImplCopyWithImpl<$Res>
    extends _$TournamentFightCopyWithImpl<$Res, _$TournamentFightImpl>
    implements _$$TournamentFightImplCopyWith<$Res> {
  __$$TournamentFightImplCopyWithImpl(
      _$TournamentFightImpl _value, $Res Function(_$TournamentFightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? fight = null,
  }) {
    return _then(_$TournamentFightImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tournament: null == tournament
          ? _value.tournament
          : tournament // ignore: cast_nullable_to_non_nullable
              as Tournament,
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentFightImpl extends _TournamentFight {
  const _$TournamentFightImpl(
      {this.id, required this.tournament, required this.fight})
      : super._();

  factory _$TournamentFightImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentFightImplFromJson(json);

  @override
  final int? id;
  @override
  final Tournament tournament;
  @override
  final Fight fight;

  @override
  String toString() {
    return 'TournamentFight(id: $id, tournament: $tournament, fight: $fight)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentFightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournament, tournament) ||
                other.tournament == tournament) &&
            (identical(other.fight, fight) || other.fight == fight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournament, fight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentFightImplCopyWith<_$TournamentFightImpl> get copyWith =>
      __$$TournamentFightImplCopyWithImpl<_$TournamentFightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentFightImplToJson(
      this,
    );
  }
}

abstract class _TournamentFight extends TournamentFight {
  const factory _TournamentFight(
      {final int? id,
      required final Tournament tournament,
      required final Fight fight}) = _$TournamentFightImpl;
  const _TournamentFight._() : super._();

  factory _TournamentFight.fromJson(Map<String, dynamic> json) =
      _$TournamentFightImpl.fromJson;

  @override
  int? get id;
  @override
  Tournament get tournament;
  @override
  Fight get fight;
  @override
  @JsonKey(ignore: true)
  _$$TournamentFightImplCopyWith<_$TournamentFightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
