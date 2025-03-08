// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bout {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  AthleteBoutState? get r; // red
  AthleteBoutState? get b; // blue
  WeightClass? get weightClass;
  int? get pool;
  BoutRole? get winnerRole;
  BoutResult? get result;
  Duration get duration;

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoutCopyWith<Bout> get copyWith =>
      _$BoutCopyWithImpl<Bout>(this as Bout, _$identity);

  /// Serializes this Bout to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Bout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.r, r) || other.r == r) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.winnerRole, winnerRole) ||
                other.winnerRole == winnerRole) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, r,
      b, weightClass, pool, winnerRole, result, duration);

  @override
  String toString() {
    return 'Bout(id: $id, orgSyncId: $orgSyncId, organization: $organization, r: $r, b: $b, weightClass: $weightClass, pool: $pool, winnerRole: $winnerRole, result: $result, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $BoutCopyWith<$Res> {
  factory $BoutCopyWith(Bout value, $Res Function(Bout) _then) =
      _$BoutCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      AthleteBoutState? r,
      AthleteBoutState? b,
      WeightClass? weightClass,
      int? pool,
      BoutRole? winnerRole,
      BoutResult? result,
      Duration duration});

  $OrganizationCopyWith<$Res>? get organization;
  $AthleteBoutStateCopyWith<$Res>? get r;
  $AthleteBoutStateCopyWith<$Res>? get b;
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class _$BoutCopyWithImpl<$Res> implements $BoutCopyWith<$Res> {
  _$BoutCopyWithImpl(this._self, this._then);

  final Bout _self;
  final $Res Function(Bout) _then;

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? r = freezed,
    Object? b = freezed,
    Object? weightClass = freezed,
    Object? pool = freezed,
    Object? winnerRole = freezed,
    Object? result = freezed,
    Object? duration = null,
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
      r: freezed == r
          ? _self.r
          : r // ignore: cast_nullable_to_non_nullable
              as AthleteBoutState?,
      b: freezed == b
          ? _self.b
          : b // ignore: cast_nullable_to_non_nullable
              as AthleteBoutState?,
      weightClass: freezed == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      pool: freezed == pool
          ? _self.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerRole: freezed == winnerRole
          ? _self.winnerRole
          : winnerRole // ignore: cast_nullable_to_non_nullable
              as BoutRole?,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as BoutResult?,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }

  /// Create a copy of Bout
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

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AthleteBoutStateCopyWith<$Res>? get r {
    if (_self.r == null) {
      return null;
    }

    return $AthleteBoutStateCopyWith<$Res>(_self.r!, (value) {
      return _then(_self.copyWith(r: value));
    });
  }

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AthleteBoutStateCopyWith<$Res>? get b {
    if (_self.b == null) {
      return null;
    }

    return $AthleteBoutStateCopyWith<$Res>(_self.b!, (value) {
      return _then(_self.copyWith(b: value));
    });
  }

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Bout extends Bout {
  const _Bout(
      {this.id,
      this.orgSyncId,
      this.organization,
      this.r,
      this.b,
      this.weightClass,
      this.pool,
      this.winnerRole,
      this.result,
      this.duration = Duration.zero})
      : super._();
  factory _Bout.fromJson(Map<String, dynamic> json) => _$BoutFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final AthleteBoutState? r;
// red
  @override
  final AthleteBoutState? b;
// blue
  @override
  final WeightClass? weightClass;
  @override
  final int? pool;
  @override
  final BoutRole? winnerRole;
  @override
  final BoutResult? result;
  @override
  @JsonKey()
  final Duration duration;

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoutCopyWith<_Bout> get copyWith =>
      __$BoutCopyWithImpl<_Bout>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BoutToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Bout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.r, r) || other.r == r) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.winnerRole, winnerRole) ||
                other.winnerRole == winnerRole) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, r,
      b, weightClass, pool, winnerRole, result, duration);

  @override
  String toString() {
    return 'Bout(id: $id, orgSyncId: $orgSyncId, organization: $organization, r: $r, b: $b, weightClass: $weightClass, pool: $pool, winnerRole: $winnerRole, result: $result, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class _$BoutCopyWith<$Res> implements $BoutCopyWith<$Res> {
  factory _$BoutCopyWith(_Bout value, $Res Function(_Bout) _then) =
      __$BoutCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      AthleteBoutState? r,
      AthleteBoutState? b,
      WeightClass? weightClass,
      int? pool,
      BoutRole? winnerRole,
      BoutResult? result,
      Duration duration});

  @override
  $OrganizationCopyWith<$Res>? get organization;
  @override
  $AthleteBoutStateCopyWith<$Res>? get r;
  @override
  $AthleteBoutStateCopyWith<$Res>? get b;
  @override
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class __$BoutCopyWithImpl<$Res> implements _$BoutCopyWith<$Res> {
  __$BoutCopyWithImpl(this._self, this._then);

  final _Bout _self;
  final $Res Function(_Bout) _then;

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? r = freezed,
    Object? b = freezed,
    Object? weightClass = freezed,
    Object? pool = freezed,
    Object? winnerRole = freezed,
    Object? result = freezed,
    Object? duration = null,
  }) {
    return _then(_Bout(
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
      r: freezed == r
          ? _self.r
          : r // ignore: cast_nullable_to_non_nullable
              as AthleteBoutState?,
      b: freezed == b
          ? _self.b
          : b // ignore: cast_nullable_to_non_nullable
              as AthleteBoutState?,
      weightClass: freezed == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      pool: freezed == pool
          ? _self.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerRole: freezed == winnerRole
          ? _self.winnerRole
          : winnerRole // ignore: cast_nullable_to_non_nullable
              as BoutRole?,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as BoutResult?,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }

  /// Create a copy of Bout
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

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AthleteBoutStateCopyWith<$Res>? get r {
    if (_self.r == null) {
      return null;
    }

    return $AthleteBoutStateCopyWith<$Res>(_self.r!, (value) {
      return _then(_self.copyWith(r: value));
    });
  }

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AthleteBoutStateCopyWith<$Res>? get b {
    if (_self.b == null) {
      return null;
    }

    return $AthleteBoutStateCopyWith<$Res>(_self.b!, (value) {
      return _then(_self.copyWith(b: value));
    });
  }

  /// Create a copy of Bout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }
}

// dart format on
