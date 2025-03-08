// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMatchBout {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  int get pos;
  TeamMatch get teamMatch;
  Bout get bout;

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamMatchBoutCopyWith<TeamMatchBout> get copyWith =>
      _$TeamMatchBoutCopyWithImpl<TeamMatchBout>(
          this as TeamMatchBout, _$identity);

  /// Serializes this TeamMatchBout to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamMatchBout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.teamMatch, teamMatch) ||
                other.teamMatch == teamMatch) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, pos, teamMatch, bout);

  @override
  String toString() {
    return 'TeamMatchBout(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, teamMatch: $teamMatch, bout: $bout)';
  }
}

/// @nodoc
abstract mixin class $TeamMatchBoutCopyWith<$Res> {
  factory $TeamMatchBoutCopyWith(
          TeamMatchBout value, $Res Function(TeamMatchBout) _then) =
      _$TeamMatchBoutCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      int pos,
      TeamMatch teamMatch,
      Bout bout});

  $OrganizationCopyWith<$Res>? get organization;
  $TeamMatchCopyWith<$Res> get teamMatch;
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$TeamMatchBoutCopyWithImpl<$Res>
    implements $TeamMatchBoutCopyWith<$Res> {
  _$TeamMatchBoutCopyWithImpl(this._self, this._then);

  final TeamMatchBout _self;
  final $Res Function(TeamMatchBout) _then;

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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _self.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      pos: null == pos
          ? _self.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      teamMatch: null == teamMatch
          ? _self.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      bout: null == bout
          ? _self.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamMatchCopyWith<$Res> get teamMatch {
    return $TeamMatchCopyWith<$Res>(_self.teamMatch, (value) {
      return _then(_self.copyWith(teamMatch: value));
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_self.bout, (value) {
      return _then(_self.copyWith(bout: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TeamMatchBout extends TeamMatchBout {
  const _TeamMatchBout(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.pos,
      required this.teamMatch,
      required this.bout})
      : super._();
  factory _TeamMatchBout.fromJson(Map<String, dynamic> json) =>
      _$TeamMatchBoutFromJson(json);

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

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamMatchBoutCopyWith<_TeamMatchBout> get copyWith =>
      __$TeamMatchBoutCopyWithImpl<_TeamMatchBout>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamMatchBoutToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamMatchBout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.teamMatch, teamMatch) ||
                other.teamMatch == teamMatch) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, pos, teamMatch, bout);

  @override
  String toString() {
    return 'TeamMatchBout(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, teamMatch: $teamMatch, bout: $bout)';
  }
}

/// @nodoc
abstract mixin class _$TeamMatchBoutCopyWith<$Res>
    implements $TeamMatchBoutCopyWith<$Res> {
  factory _$TeamMatchBoutCopyWith(
          _TeamMatchBout value, $Res Function(_TeamMatchBout) _then) =
      __$TeamMatchBoutCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      int pos,
      TeamMatch teamMatch,
      Bout bout});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $TeamMatchCopyWith<$Res> get teamMatch;
  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$TeamMatchBoutCopyWithImpl<$Res>
    implements _$TeamMatchBoutCopyWith<$Res> {
  __$TeamMatchBoutCopyWithImpl(this._self, this._then);

  final _TeamMatchBout _self;
  final $Res Function(_TeamMatchBout) _then;

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? pos = null,
    Object? teamMatch = null,
    Object? bout = null,
  }) {
    return _then(_TeamMatchBout(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _self.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization?,
      pos: null == pos
          ? _self.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      teamMatch: null == teamMatch
          ? _self.teamMatch
          : teamMatch // ignore: cast_nullable_to_non_nullable
              as TeamMatch,
      bout: null == bout
          ? _self.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TeamMatchCopyWith<$Res> get teamMatch {
    return $TeamMatchCopyWith<$Res>(_self.teamMatch, (value) {
      return _then(_self.copyWith(teamMatch: value));
    });
  }

  /// Create a copy of TeamMatchBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_self.bout, (value) {
      return _then(_self.copyWith(bout: value));
    });
  }
}

// dart format on
