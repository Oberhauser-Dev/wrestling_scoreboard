// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CompetitionPerson _$CompetitionPersonFromJson(Map<String, dynamic> json) {
  return _CompetitionPerson.fromJson(json);
}

/// @nodoc
mixin _$CompetitionPerson {
  int? get id => throw _privateConstructorUsedError;
  Competition get competition => throw _privateConstructorUsedError;
  Person get person => throw _privateConstructorUsedError;
  PersonRole get role => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompetitionPersonCopyWith<CompetitionPerson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitionPersonCopyWith<$Res> {
  factory $CompetitionPersonCopyWith(
          CompetitionPerson value, $Res Function(CompetitionPerson) then) =
      _$CompetitionPersonCopyWithImpl<$Res, CompetitionPerson>;
  @useResult
  $Res call({int? id, Competition competition, Person person, PersonRole role});

  $CompetitionCopyWith<$Res> get competition;
  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class _$CompetitionPersonCopyWithImpl<$Res, $Val extends CompetitionPerson>
    implements $CompetitionPersonCopyWith<$Res> {
  _$CompetitionPersonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? person = null,
    Object? role = null,
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
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_value.competition, (value) {
      return _then(_value.copyWith(competition: value) as $Val);
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
abstract class _$$CompetitionPersonImplCopyWith<$Res>
    implements $CompetitionPersonCopyWith<$Res> {
  factory _$$CompetitionPersonImplCopyWith(_$CompetitionPersonImpl value,
          $Res Function(_$CompetitionPersonImpl) then) =
      __$$CompetitionPersonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Competition competition, Person person, PersonRole role});

  @override
  $CompetitionCopyWith<$Res> get competition;
  @override
  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class __$$CompetitionPersonImplCopyWithImpl<$Res>
    extends _$CompetitionPersonCopyWithImpl<$Res, _$CompetitionPersonImpl>
    implements _$$CompetitionPersonImplCopyWith<$Res> {
  __$$CompetitionPersonImplCopyWithImpl(_$CompetitionPersonImpl _value,
      $Res Function(_$CompetitionPersonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? person = null,
    Object? role = null,
  }) {
    return _then(_$CompetitionPersonImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
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
class _$CompetitionPersonImpl extends _CompetitionPerson {
  const _$CompetitionPersonImpl(
      {this.id,
      required this.competition,
      required this.person,
      required this.role})
      : super._();

  factory _$CompetitionPersonImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitionPersonImplFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Person person;
  @override
  final PersonRole role;

  @override
  String toString() {
    return 'CompetitionPerson(id: $id, competition: $competition, person: $person, role: $role)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitionPersonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.person, person) || other.person == person) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, person, role);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitionPersonImplCopyWith<_$CompetitionPersonImpl> get copyWith =>
      __$$CompetitionPersonImplCopyWithImpl<_$CompetitionPersonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitionPersonImplToJson(
      this,
    );
  }
}

abstract class _CompetitionPerson extends CompetitionPerson {
  const factory _CompetitionPerson(
      {final int? id,
      required final Competition competition,
      required final Person person,
      required final PersonRole role}) = _$CompetitionPersonImpl;
  const _CompetitionPerson._() : super._();

  factory _CompetitionPerson.fromJson(Map<String, dynamic> json) =
      _$CompetitionPersonImpl.fromJson;

  @override
  int? get id;
  @override
  Competition get competition;
  @override
  Person get person;
  @override
  PersonRole get role;
  @override
  @JsonKey(ignore: true)
  _$$CompetitionPersonImplCopyWith<_$CompetitionPersonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
