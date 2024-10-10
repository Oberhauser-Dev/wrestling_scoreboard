// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_club_affiliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamClubAffiliation _$TeamClubAffiliationFromJson(Map<String, dynamic> json) {
  return _TeamClubAffiliation.fromJson(json);
}

/// @nodoc
mixin _$TeamClubAffiliation {
  int? get id => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;
  Club get club => throw _privateConstructorUsedError;

  /// Serializes this TeamClubAffiliation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamClubAffiliationCopyWith<TeamClubAffiliation> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamClubAffiliationCopyWith<$Res> {
  factory $TeamClubAffiliationCopyWith(TeamClubAffiliation value, $Res Function(TeamClubAffiliation) then) =
      _$TeamClubAffiliationCopyWithImpl<$Res, TeamClubAffiliation>;
  @useResult
  $Res call({int? id, Team team, Club club});

  $TeamCopyWith<$Res> get team;
  $ClubCopyWith<$Res> get club;
}

/// @nodoc
class _$TeamClubAffiliationCopyWithImpl<$Res, $Val extends TeamClubAffiliation>
    implements $TeamClubAffiliationCopyWith<$Res> {
  _$TeamClubAffiliationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? club = null,
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
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
    ) as $Val);
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamCopyWith<$Res> get team {
    return $TeamCopyWith<$Res>(_value.team, (value) {
      return _then(_value.copyWith(team: value) as $Val);
    });
  }

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_value.club, (value) {
      return _then(_value.copyWith(club: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamClubAffiliationImplCopyWith<$Res> implements $TeamClubAffiliationCopyWith<$Res> {
  factory _$$TeamClubAffiliationImplCopyWith(
          _$TeamClubAffiliationImpl value, $Res Function(_$TeamClubAffiliationImpl) then) =
      __$$TeamClubAffiliationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Team team, Club club});

  @override
  $TeamCopyWith<$Res> get team;
  @override
  $ClubCopyWith<$Res> get club;
}

/// @nodoc
class __$$TeamClubAffiliationImplCopyWithImpl<$Res>
    extends _$TeamClubAffiliationCopyWithImpl<$Res, _$TeamClubAffiliationImpl>
    implements _$$TeamClubAffiliationImplCopyWith<$Res> {
  __$$TeamClubAffiliationImplCopyWithImpl(
      _$TeamClubAffiliationImpl _value, $Res Function(_$TeamClubAffiliationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? team = null,
    Object? club = null,
  }) {
    return _then(_$TeamClubAffiliationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamClubAffiliationImpl extends _TeamClubAffiliation {
  const _$TeamClubAffiliationImpl({this.id, required this.team, required this.club}) : super._();

  factory _$TeamClubAffiliationImpl.fromJson(Map<String, dynamic> json) => _$$TeamClubAffiliationImplFromJson(json);

  @override
  final int? id;
  @override
  final Team team;
  @override
  final Club club;

  @override
  String toString() {
    return 'TeamClubAffiliation(id: $id, team: $team, club: $club)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamClubAffiliationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.club, club) || other.club == club));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, club);

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamClubAffiliationImplCopyWith<_$TeamClubAffiliationImpl> get copyWith =>
      __$$TeamClubAffiliationImplCopyWithImpl<_$TeamClubAffiliationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamClubAffiliationImplToJson(
      this,
    );
  }
}

abstract class _TeamClubAffiliation extends TeamClubAffiliation {
  const factory _TeamClubAffiliation({final int? id, required final Team team, required final Club club}) =
      _$TeamClubAffiliationImpl;
  const _TeamClubAffiliation._() : super._();

  factory _TeamClubAffiliation.fromJson(Map<String, dynamic> json) = _$TeamClubAffiliationImpl.fromJson;

  @override
  int? get id;
  @override
  Team get team;
  @override
  Club get club;

  /// Create a copy of TeamClubAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamClubAffiliationImplCopyWith<_$TeamClubAffiliationImpl> get copyWith => throw _privateConstructorUsedError;
}
