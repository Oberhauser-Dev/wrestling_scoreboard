// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Competition {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  String get name;
  BoutConfig get boutConfig;
  String? get location;
  DateTime get date;
  String? get no;
  int? get visitorsCount;
  String? get comment;

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<Competition> get copyWith =>
      _$CompetitionCopyWithImpl<Competition>(this as Competition, _$identity);

  /// Serializes this Competition to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Competition &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.location, location) || other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.visitorsCount, visitorsCount) || other.visitorsCount == visitorsCount) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, boutConfig, location, date, no, visitorsCount, comment);

  @override
  String toString() {
    return 'Competition(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, boutConfig: $boutConfig, location: $location, date: $date, no: $no, visitorsCount: $visitorsCount, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class $CompetitionCopyWith<$Res> {
  factory $CompetitionCopyWith(Competition value, $Res Function(Competition) _then) = _$CompetitionCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      BoutConfig boutConfig,
      String? location,
      DateTime date,
      String? no,
      int? visitorsCount,
      String? comment});

  $OrganizationCopyWith<$Res>? get organization;
  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class _$CompetitionCopyWithImpl<$Res> implements $CompetitionCopyWith<$Res> {
  _$CompetitionCopyWithImpl(this._self, this._then);

  final Competition _self;
  final $Res Function(Competition) _then;

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? name = null,
    Object? boutConfig = null,
    Object? location = freezed,
    Object? date = null,
    Object? no = freezed,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boutConfig: null == boutConfig
          ? _self.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _self.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Competition
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

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
      return _then(_self.copyWith(boutConfig: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Competition extends Competition {
  const _Competition(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.name,
      required this.boutConfig,
      this.location,
      required this.date,
      this.no,
      this.visitorsCount,
      this.comment})
      : super._();
  factory _Competition.fromJson(Map<String, dynamic> json) => _$CompetitionFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final String name;
  @override
  final BoutConfig boutConfig;
  @override
  final String? location;
  @override
  final DateTime date;
  @override
  final String? no;
  @override
  final int? visitorsCount;
  @override
  final String? comment;

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionCopyWith<_Competition> get copyWith => __$CompetitionCopyWithImpl<_Competition>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Competition &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.location, location) || other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.visitorsCount, visitorsCount) || other.visitorsCount == visitorsCount) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, boutConfig, location, date, no, visitorsCount, comment);

  @override
  String toString() {
    return 'Competition(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, boutConfig: $boutConfig, location: $location, date: $date, no: $no, visitorsCount: $visitorsCount, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionCopyWith<$Res> implements $CompetitionCopyWith<$Res> {
  factory _$CompetitionCopyWith(_Competition value, $Res Function(_Competition) _then) = __$CompetitionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      BoutConfig boutConfig,
      String? location,
      DateTime date,
      String? no,
      int? visitorsCount,
      String? comment});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class __$CompetitionCopyWithImpl<$Res> implements _$CompetitionCopyWith<$Res> {
  __$CompetitionCopyWithImpl(this._self, this._then);

  final _Competition _self;
  final $Res Function(_Competition) _then;

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? name = null,
    Object? boutConfig = null,
    Object? location = freezed,
    Object? date = null,
    Object? no = freezed,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
  }) {
    return _then(_Competition(
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boutConfig: null == boutConfig
          ? _self.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _self.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Competition
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

  /// Create a copy of Competition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
      return _then(_self.copyWith(boutConfig: value));
    });
  }
}

// dart format on
