// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TeamMatchBout _$TeamMatchBoutFromJson(Map<String, dynamic> json) {
  return _TeamMatchBout.fromJson(json);
}

/// @nodoc
mixin _$TeamMatchBout {
  int? get id => throw _privateConstructorUsedError;
  String? get orgSyncId => throw _privateConstructorUsedError;
  Organization? get organization => throw _privateConstructorUsedError;
  int get pos => throw _privateConstructorUsedError;
  TeamMatch get teamMatch => throw _privateConstructorUsedError;
  Bout get bout => throw _privateConstructorUsedError;

  /// Serializes this TeamMatchBout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMatchBoutCopyWith<TeamMatchBout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMatchBoutCopyWith<$Res> {
  factory $TeamMatchBoutCopyWith(TeamMatchBout value, $Res Function(TeamMatchBout) then) =
      _$TeamMatchBoutCopyWithImpl<$Res, TeamMatchBout>;
  @useResult
  $Res call({int? id, String? orgSyncId, Organization? organization, int pos, TeamMatch teamMatch, Bout bout});

  $OrganizationCopyWith<$Res>? get organization;
  $TeamMatchCopyWith<$Res> get teamMatch;
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$TeamMatchBoutCopyWithImpl<$Res, $Val extends TeamMatchBout> implements $TeamMatchBoutCopyWith<$Res> {
  _$TeamMatchBoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? pos = null,
    Object? teamMatch = null,
    Object? bout = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _value.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      teamMatch: null == teamMatch
          ? _value.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ) as $Val);
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_value.organization!, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamMatchCopyWith<$Res> get teamMatch {
    return $TeamMatchCopyWith<$Res>(_value.teamMatch, (value) {
      return _then(_value.copyWith(teamMatch: value) as $Val);
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_value.bout, (value) {
      return _then(_value.copyWith(bout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamMatchBoutImplCopyWith<$Res> implements $TeamMatchBoutCopyWith<$Res> {
  factory _$$TeamMatchBoutImplCopyWith(_$TeamMatchBoutImpl value, $Res Function(_$TeamMatchBoutImpl) then) =
      __$$TeamMatchBoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? orgSyncId, Organization? organization, int pos, TeamMatch teamMatch, Bout bout});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $TeamMatchCopyWith<$Res> get teamMatch;
  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$$TeamMatchBoutImplCopyWithImpl<$Res> extends _$TeamMatchBoutCopyWithImpl<$Res, _$TeamMatchBoutImpl>
    implements _$$TeamMatchBoutImplCopyWith<$Res> {
  __$$TeamMatchBoutImplCopyWithImpl(_$TeamMatchBoutImpl _value, $Res Function(_$TeamMatchBoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? pos = null,
    Object? teamMatch = null,
    Object? bout = null,
  }) {
    return _then(_$TeamMatchBoutImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _value.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      teamMatch: null == teamMatch
          ? _value.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamMatchBoutImpl extends _TeamMatchBout {
  const _$TeamMatchBoutImpl(
      {this.id, this.orgSyncId, this.organization, required this.pos, required this.teamMatch, required this.bout})
      : super._();

  factory _$TeamMatchBoutImpl.fromJson(Map<String, dynamic> json) => _$$TeamMatchBoutImplFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final int pos;
  @override
  final TeamMatch teamMatch;
  @override
  final Bout bout;

  @override
  String toString() {
    return 'TeamMatchBout(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, teamMatch: $teamMatch, bout: $bout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMatchBoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.teamMatch, teamMatch) || other.teamMatch == teamMatch) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, pos, teamMatch, bout);

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMatchBoutImplCopyWith<_$TeamMatchBoutImpl> get copyWith =>
      __$$TeamMatchBoutImplCopyWithImpl<_$TeamMatchBoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamMatchBoutImplToJson(
      this,
    );
  }
}

abstract class _TeamMatchBout extends TeamMatchBout {
  const factory _TeamMatchBout(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      required final int pos,
      required final TeamMatch teamMatch,
      required final Bout bout}) = _$TeamMatchBoutImpl;
  const _TeamMatchBout._() : super._();

  factory _TeamMatchBout.fromJson(Map<String, dynamic> json) = _$TeamMatchBoutImpl.fromJson;

  @override
  int? get id;
  @override
  String? get orgSyncId;
  @override
  Organization? get organization;
  @override
  int get pos;
  @override
  TeamMatch get teamMatch;
  @override
  Bout get bout;

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMatchBoutImplCopyWith<_$TeamMatchBoutImpl> get copyWith => throw _privateConstructorUsedError;
}
