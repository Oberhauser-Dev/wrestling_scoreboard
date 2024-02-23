// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Lineup _$LineupFromJson(Map<String, dynamic> json) {
  return _Lineup.fromJson(json);
}

/// @nodoc
mixin _$Lineup {
  int? get id => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;
  Membership? get leader => throw _privateConstructorUsedError; // Mannschaftsführer
  Membership? get coach => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LineupCopyWith<Lineup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupCopyWith<$Res> {
  factory $LineupCopyWith(Lineup value, $Res Function(Lineup) then) = _$LineupCopyWithImpl<$Res, Lineup>;
  @useResult
  $Res call({int? id, Team team, Membership? leader, Membership? coach});

  $TeamCopyWith<$Res> get team;
  $MembershipCopyWith<$Res>? get leader;
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class _$LineupCopyWithImpl<$Res, $Val extends Lineup> implements $LineupCopyWith<$Res> {
  _$LineupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as Membership?,
      coach: freezed == coach
          ? _value.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as Membership?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_value.team, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get leader {
    if (_value.leader == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_value.leader!, (value) {
      return _then(_value.copyWith(leader: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MembershipCopyWith<$Res>? get coach {
    if (_value.coach == null) {
      return null;
    }

    return $MembershipCopyWith<$Res>(_value.coach!, (value) {
      return _then(_value.copyWith(coach: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LineupImplCopyWith<$Res> implements $LineupCopyWith<$Res> {
  factory _$$LineupImplCopyWith(_$LineupImpl value, $Res Function(_$LineupImpl) then) =
      __$$LineupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Team team, Membership? leader, Membership? coach});

  @override
  $TeamCopyWith<$Res> get team;
  @override
  $MembershipCopyWith<$Res>? get leader;
  @override
  $MembershipCopyWith<$Res>? get coach;
}

/// @nodoc
class __$$LineupImplCopyWithImpl<$Res> extends _$LineupCopyWithImpl<$Res, _$LineupImpl>
    implements _$$LineupImplCopyWith<$Res> {
  __$$LineupImplCopyWithImpl(_$LineupImpl _value, $Res Function(_$LineupImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? leader = freezed,
    Object? coach = freezed,
  }) {
    return _then(_$LineupImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as Membership?,
      coach: freezed == coach
          ? _value.coach
          : coach // ignore: cast_nullable_to_non_nullable
              as Membership?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupImpl extends _Lineup {
  const _$LineupImpl({this.id, required this.team, this.leader, this.coach}) : super._();

  factory _$LineupImpl.fromJson(Map<String, dynamic> json) => _$$LineupImplFromJson(json);

  @override
  final int? id;
  @override
  final Team team;
  @override
  final Membership? leader;
// Mannschaftsführer
  @override
  final Membership? coach;

  @override
  String toString() {
    return 'Lineup(id: $id, team: $team, leader: $leader, coach: $coach)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.coach, coach) || other.coach == coach));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, leader, coach);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupImplCopyWith<_$LineupImpl> get copyWith => __$$LineupImplCopyWithImpl<_$LineupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupImplToJson(
      this,
    );
  }
}

abstract class _Lineup extends Lineup {
  const factory _Lineup({final int? id, required final Team team, final Membership? leader, final Membership? coach}) =
      _$LineupImpl;
  const _Lineup._() : super._();

  factory _Lineup.fromJson(Map<String, dynamic> json) = _$LineupImpl.fromJson;

  @override
  int? get id;
  @override
  Team get team;
  @override
  Membership? get leader;
  @override // Mannschaftsführer
  Membership? get coach;
  @override
  @JsonKey(ignore: true)
  _$$LineupImplCopyWith<_$LineupImpl> get copyWith => throw _privateConstructorUsedError;
}
