// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeagueWeightClass {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  int get pos;
  League get league;
  WeightClass get weightClass;
  int? get seasonPartition;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LeagueWeightClassCopyWith<LeagueWeightClass> get copyWith =>
      _$LeagueWeightClassCopyWithImpl<LeagueWeightClass>(
          this as LeagueWeightClass, _$identity);

  /// Serializes this LeagueWeightClass to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LeagueWeightClass &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.seasonPartition, seasonPartition) ||
                other.seasonPartition == seasonPartition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, pos,
      league, weightClass, seasonPartition);

  @override
  String toString() {
    return 'LeagueWeightClass(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, league: $league, weightClass: $weightClass, seasonPartition: $seasonPartition)';
  }
}

/// @nodoc
abstract mixin class $LeagueWeightClassCopyWith<$Res> {
  factory $LeagueWeightClassCopyWith(
          LeagueWeightClass value, $Res Function(LeagueWeightClass) _then) =
      _$LeagueWeightClassCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      int pos,
      League league,
      WeightClass weightClass,
      int? seasonPartition});

  $OrganizationCopyWith<$Res>? get organization;
  $LeagueCopyWith<$Res> get league;
  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class _$LeagueWeightClassCopyWithImpl<$Res>
    implements $LeagueWeightClassCopyWith<$Res> {
  _$LeagueWeightClassCopyWithImpl(this._self, this._then);

  final LeagueWeightClass _self;
  final $Res Function(LeagueWeightClass) _then;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? pos = null,
    Object? league = null,
    Object? weightClass = null,
    Object? seasonPartition = freezed,
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
      league: null == league
          ? _self.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _self.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of LeagueWeightClass
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

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res> get league {
    return $LeagueCopyWith<$Res>(_self.league, (value) {
      return _then(_self.copyWith(league: value));
    });
  }

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _LeagueWeightClass extends LeagueWeightClass {
  const _LeagueWeightClass(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.pos,
      required this.league,
      required this.weightClass,
      this.seasonPartition})
      : super._();
  factory _LeagueWeightClass.fromJson(Map<String, dynamic> json) =>
      _$LeagueWeightClassFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final int pos;
  @override
  final League league;
  @override
  final WeightClass weightClass;
  @override
  final int? seasonPartition;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LeagueWeightClassCopyWith<_LeagueWeightClass> get copyWith =>
      __$LeagueWeightClassCopyWithImpl<_LeagueWeightClass>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LeagueWeightClassToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LeagueWeightClass &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.seasonPartition, seasonPartition) ||
                other.seasonPartition == seasonPartition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, pos,
      league, weightClass, seasonPartition);

  @override
  String toString() {
    return 'LeagueWeightClass(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, league: $league, weightClass: $weightClass, seasonPartition: $seasonPartition)';
  }
}

/// @nodoc
abstract mixin class _$LeagueWeightClassCopyWith<$Res>
    implements $LeagueWeightClassCopyWith<$Res> {
  factory _$LeagueWeightClassCopyWith(
          _LeagueWeightClass value, $Res Function(_LeagueWeightClass) _then) =
      __$LeagueWeightClassCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      int pos,
      League league,
      WeightClass weightClass,
      int? seasonPartition});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $LeagueCopyWith<$Res> get league;
  @override
  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class __$LeagueWeightClassCopyWithImpl<$Res>
    implements _$LeagueWeightClassCopyWith<$Res> {
  __$LeagueWeightClassCopyWithImpl(this._self, this._then);

  final _LeagueWeightClass _self;
  final $Res Function(_LeagueWeightClass) _then;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? pos = null,
    Object? league = null,
    Object? weightClass = null,
    Object? seasonPartition = freezed,
  }) {
    return _then(_LeagueWeightClass(
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
      league: null == league
          ? _self.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _self.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of LeagueWeightClass
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

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res> get league {
    return $LeagueCopyWith<$Res>(_self.league, (value) {
      return _then(_self.copyWith(league: value));
    });
  }

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

// dart format on
