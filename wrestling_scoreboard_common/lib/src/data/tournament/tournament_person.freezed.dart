// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TournamentPerson _$TournamentPersonFromJson(Map<String, dynamic> json) {
  return _TournamentPerson.fromJson(json);
}

/// @nodoc
mixin _$TournamentPerson {
  int? get id => throw _privateConstructorUsedError;
  Tournament get tournament => throw _privateConstructorUsedError;
  Person get person => throw _privateConstructorUsedError;
  PersonRole get role => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentPersonCopyWith<TournamentPerson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentPersonCopyWith<$Res> {
  factory $TournamentPersonCopyWith(
          TournamentPerson value, $Res Function(TournamentPerson) then) =
      _$TournamentPersonCopyWithImpl<$Res, TournamentPerson>;
  @useResult
  $Res call({int? id, Tournament tournament, Person person, PersonRole role});

  $TournamentCopyWith<$Res> get tournament;
  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class _$TournamentPersonCopyWithImpl<$Res, $Val extends TournamentPerson>
    implements $TournamentPersonCopyWith<$Res> {
  _$TournamentPersonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? person = null,
    Object? role = null,
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
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as PersonRole,
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
  $PersonCopyWith<$Res> get person {
    return $PersonCopyWith<$Res>(_value.person, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TournamentPersonImplCopyWith<$Res>
    implements $TournamentPersonCopyWith<$Res> {
  factory _$$TournamentPersonImplCopyWith(_$TournamentPersonImpl value,
          $Res Function(_$TournamentPersonImpl) then) =
      __$$TournamentPersonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Tournament tournament, Person person, PersonRole role});

  @override
  $TournamentCopyWith<$Res> get tournament;
  @override
  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class __$$TournamentPersonImplCopyWithImpl<$Res>
    extends _$TournamentPersonCopyWithImpl<$Res, _$TournamentPersonImpl>
    implements _$$TournamentPersonImplCopyWith<$Res> {
  __$$TournamentPersonImplCopyWithImpl(_$TournamentPersonImpl _value,
      $Res Function(_$TournamentPersonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tournament = null,
    Object? person = null,
    Object? role = null,
  }) {
    return _then(_$TournamentPersonImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tournament: null == tournament
          ? _value.tournament
          : tournament // ignore: cast_nullable_to_non_nullable
              as Tournament,
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as PersonRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentPersonImpl extends _TournamentPerson {
  const _$TournamentPersonImpl(
      {this.id,
      required this.tournament,
      required this.person,
      required this.role})
      : super._();

  factory _$TournamentPersonImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentPersonImplFromJson(json);

  @override
  final int? id;
  @override
  final Tournament tournament;
  @override
  final Person person;
  @override
  final PersonRole role;

  @override
  String toString() {
    return 'TournamentPerson(id: $id, tournament: $tournament, person: $person, role: $role)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentPersonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournament, tournament) ||
                other.tournament == tournament) &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournament, person, role);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentPersonImplCopyWith<_$TournamentPersonImpl> get copyWith =>
      __$$TournamentPersonImplCopyWithImpl<_$TournamentPersonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentPersonImplToJson(
      this,
    );
  }
}

abstract class _TournamentPerson extends TournamentPerson {
  const factory _TournamentPerson(
      {final int? id,
      required final Tournament tournament,
      required final Person person,
      required final PersonRole role}) = _$TournamentPersonImpl;
  const _TournamentPerson._() : super._();

  factory _TournamentPerson.fromJson(Map<String, dynamic> json) =
      _$TournamentPersonImpl.fromJson;

  @override
  int? get id;
  @override
  Tournament get tournament;
  @override
  Person get person;
  @override
  PersonRole get role;
  @override
  @JsonKey(ignore: true)
  _$$TournamentPersonImplCopyWith<_$TournamentPersonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
