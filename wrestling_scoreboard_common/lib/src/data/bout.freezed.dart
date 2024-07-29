// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Bout _$BoutFromJson(Map<String, dynamic> json) {
  return _Bout.fromJson(json);
}

/// @nodoc
mixin _$Bout {
  int? get id => throw _privateConstructorUsedError;

  String? get orgSyncId => throw _privateConstructorUsedError;

  Organization? get organization => throw _privateConstructorUsedError;

  ParticipantState? get r => throw _privateConstructorUsedError; // red
  ParticipantState? get b => throw _privateConstructorUsedError; // blue
  WeightClass? get weightClass => throw _privateConstructorUsedError;

  int? get pool => throw _privateConstructorUsedError;

  BoutRole? get winnerRole => throw _privateConstructorUsedError;

  BoutResult? get result => throw _privateConstructorUsedError;

  Duration get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoutCopyWith<Bout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoutCopyWith<$Res> {
  factory $BoutCopyWith(Bout value, $Res Function(Bout) then) = _$BoutCopyWithImpl<$Res, Bout>;

  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      ParticipantState? r,
      ParticipantState? b,
      WeightClass? weightClass,
      int? pool,
      BoutRole? winnerRole,
      BoutResult? result,
      Duration duration});

  $OrganizationCopyWith<$Res>? get organization;

  $ParticipantStateCopyWith<$Res>? get r;

  $ParticipantStateCopyWith<$Res>? get b;

  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class _$BoutCopyWithImpl<$Res, $Val extends Bout> implements $BoutCopyWith<$Res> {
  _$BoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

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
      r: freezed == r
          ? _value.r
          : r // ignore: cast_nullable_to_non_nullable
              as ParticipantState?,
      b: freezed == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as ParticipantState?,
      weightClass: freezed == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      pool: freezed == pool
          ? _value.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerRole: freezed == winnerRole
          ? _value.winnerRole
          : winnerRole // ignore: cast_nullable_to_non_nullable
              as BoutRole?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as BoutResult?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }

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

  @override
  @pragma('vm:prefer-inline')
  $ParticipantStateCopyWith<$Res>? get r {
    if (_value.r == null) {
      return null;
    }

    return $ParticipantStateCopyWith<$Res>(_value.r!, (value) {
      return _then(_value.copyWith(r: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ParticipantStateCopyWith<$Res>? get b {
    if (_value.b == null) {
      return null;
    }

    return $ParticipantStateCopyWith<$Res>(_value.b!, (value) {
      return _then(_value.copyWith(b: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res>? get weightClass {
    if (_value.weightClass == null) {
      return null;
    }

    return $WeightClassCopyWith<$Res>(_value.weightClass!, (value) {
      return _then(_value.copyWith(weightClass: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoutImplCopyWith<$Res> implements $BoutCopyWith<$Res> {
  factory _$$BoutImplCopyWith(_$BoutImpl value, $Res Function(_$BoutImpl) then) = __$$BoutImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      ParticipantState? r,
      ParticipantState? b,
      WeightClass? weightClass,
      int? pool,
      BoutRole? winnerRole,
      BoutResult? result,
      Duration duration});

  @override
  $OrganizationCopyWith<$Res>? get organization;

  @override
  $ParticipantStateCopyWith<$Res>? get r;

  @override
  $ParticipantStateCopyWith<$Res>? get b;

  @override
  $WeightClassCopyWith<$Res>? get weightClass;
}

/// @nodoc
class __$$BoutImplCopyWithImpl<$Res> extends _$BoutCopyWithImpl<$Res, _$BoutImpl> implements _$$BoutImplCopyWith<$Res> {
  __$$BoutImplCopyWithImpl(_$BoutImpl _value, $Res Function(_$BoutImpl) _then) : super(_value, _then);

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
    return _then(_$BoutImpl(
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
      r: freezed == r
          ? _value.r
          : r // ignore: cast_nullable_to_non_nullable
              as ParticipantState?,
      b: freezed == b
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as ParticipantState?,
      weightClass: freezed == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass?,
      pool: freezed == pool
          ? _value.pool
          : pool // ignore: cast_nullable_to_non_nullable
              as int?,
      winnerRole: freezed == winnerRole
          ? _value.winnerRole
          : winnerRole // ignore: cast_nullable_to_non_nullable
              as BoutRole?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as BoutResult?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoutImpl extends _Bout {
  const _$BoutImpl(
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

  factory _$BoutImpl.fromJson(Map<String, dynamic> json) => _$$BoutImplFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final ParticipantState? r;

// red
  @override
  final ParticipantState? b;

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

  @override
  String toString() {
    return 'Bout(id: $id, orgSyncId: $orgSyncId, organization: $organization, r: $r, b: $b, weightClass: $weightClass, pool: $pool, winnerRole: $winnerRole, result: $result, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.r, r) || other.r == r) &&
            (identical(other.b, b) || other.b == b) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.winnerRole, winnerRole) || other.winnerRole == winnerRole) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.duration, duration) || other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, orgSyncId, organization, r, b, weightClass, pool, winnerRole, result, duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoutImplCopyWith<_$BoutImpl> get copyWith => __$$BoutImplCopyWithImpl<_$BoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoutImplToJson(
      this,
    );
  }
}

abstract class _Bout extends Bout {
  const factory _Bout(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      final ParticipantState? r,
      final ParticipantState? b,
      final WeightClass? weightClass,
      final int? pool,
      final BoutRole? winnerRole,
      final BoutResult? result,
      final Duration duration}) = _$BoutImpl;

  const _Bout._() : super._();

  factory _Bout.fromJson(Map<String, dynamic> json) = _$BoutImpl.fromJson;

  @override
  int? get id;

  @override
  String? get orgSyncId;

  @override
  Organization? get organization;

  @override
  ParticipantState? get r;

  @override // red
  ParticipantState? get b;

  @override // blue
  WeightClass? get weightClass;

  @override
  int? get pool;

  @override
  BoutRole? get winnerRole;

  @override
  BoutResult? get result;

  @override
  Duration get duration;

  @override
  @JsonKey(ignore: true)
  _$$BoutImplCopyWith<_$BoutImpl> get copyWith => throw _privateConstructorUsedError;
}
