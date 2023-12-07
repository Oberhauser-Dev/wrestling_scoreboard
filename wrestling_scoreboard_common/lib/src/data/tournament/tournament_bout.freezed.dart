// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TournamentBout _$TournamentBoutFromJson(Map<String, dynamic> json) {
  return _TournamentBout.fromJson(json);
}

/// @nodoc
mixin _$TournamentBout {
  int? get id => throw _privateConstructorUsedError;
  Tournament get tournament => throw _privateConstructorUsedError;
  Bout get bout => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentBoutCopyWith<TournamentBout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentBoutCopyWith<$Res> {
  factory $TournamentBoutCopyWith(
          TournamentBout value, $Res Function(TournamentBout) then) =
      _$TournamentBoutCopyWithImpl<$Res, TournamentBout>;
  @useResult
  $Res call({int? id, Tournament tournament, Bout bout});

  $TournamentCopyWith<$Res> get tournament;
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$TournamentBoutCopyWithImpl<$Res, $Val extends TournamentBout>
    implements $TournamentBoutCopyWith<$Res> {
  _$TournamentBoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? bout = null,
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
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
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
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_value.bout, (value) {
      return _then(_value.copyWith(bout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TournamentBoutImplCopyWith<$Res>
    implements $TournamentBoutCopyWith<$Res> {
  factory _$$TournamentBoutImplCopyWith(_$TournamentBoutImpl value,
          $Res Function(_$TournamentBoutImpl) then) =
      __$$TournamentBoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Tournament tournament, Bout bout});

  @override
  $TournamentCopyWith<$Res> get tournament;
  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$$TournamentBoutImplCopyWithImpl<$Res>
    extends _$TournamentBoutCopyWithImpl<$Res, _$TournamentBoutImpl>
    implements _$$TournamentBoutImplCopyWith<$Res> {
  __$$TournamentBoutImplCopyWithImpl(
      _$TournamentBoutImpl _value, $Res Function(_$TournamentBoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? bout = null,
  }) {
    return _then(_$TournamentBoutImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tournament: null == tournament
          ? _value.tournament
          : tournament // ignore: cast_nullable_to_non_nullable
              as Tournament,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentBoutImpl extends _TournamentBout {
  const _$TournamentBoutImpl(
      {this.id, required this.tournament, required this.bout})
      : super._();

  factory _$TournamentBoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentBoutImplFromJson(json);

  @override
  final int? id;
  @override
  final Tournament tournament;
  @override
  final Bout bout;

  @override
  String toString() {
    return 'TournamentBout(id: $id, tournament: $tournament, bout: $bout)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentBoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournament, tournament) ||
                other.tournament == tournament) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournament, bout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentBoutImplCopyWith<_$TournamentBoutImpl> get copyWith =>
      __$$TournamentBoutImplCopyWithImpl<_$TournamentBoutImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentBoutImplToJson(
      this,
    );
  }
}

abstract class _TournamentBout extends TournamentBout {
  const factory _TournamentBout(
      {final int? id,
      required final Tournament tournament,
      required final Bout bout}) = _$TournamentBoutImpl;
  const _TournamentBout._() : super._();

  factory _TournamentBout.fromJson(Map<String, dynamic> json) =
      _$TournamentBoutImpl.fromJson;

  @override
  int? get id;
  @override
  Tournament get tournament;
  @override
  Bout get bout;
  @override
  @JsonKey(ignore: true)
  _$$TournamentBoutImplCopyWith<_$TournamentBoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
