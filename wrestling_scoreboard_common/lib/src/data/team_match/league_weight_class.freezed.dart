// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeagueWeightClass _$LeagueWeightClassFromJson(Map<String, dynamic> json) {
  return _LeagueWeightClass.fromJson(json);
}

/// @nodoc
mixin _$LeagueWeightClass {
  int? get id => throw _privateConstructorUsedError;
  String? get orgSyncId => throw _privateConstructorUsedError;
  Organization? get organization => throw _privateConstructorUsedError;
  int get pos => throw _privateConstructorUsedError;
  League get league => throw _privateConstructorUsedError;
  WeightClass get weightClass => throw _privateConstructorUsedError;
  int? get seasonPartition => throw _privateConstructorUsedError;

  /// Serializes this LeagueWeightClass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueWeightClassCopyWith<LeagueWeightClass> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueWeightClassCopyWith<$Res> {
  factory $LeagueWeightClassCopyWith(LeagueWeightClass value, $Res Function(LeagueWeightClass) then) =
      _$LeagueWeightClassCopyWithImpl<$Res, LeagueWeightClass>;
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
class _$LeagueWeightClassCopyWithImpl<$Res, $Val extends LeagueWeightClass>
    implements $LeagueWeightClassCopyWith<$Res> {
  _$LeagueWeightClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _value.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of LeagueWeightClass
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

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res> get league {
    return $LeagueCopyWith<$Res>(_value.league, (value) {
      return _then(_value.copyWith(league: value) as $Val);
    });
  }

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_value.weightClass, (value) {
      return _then(_value.copyWith(weightClass: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueWeightClassImplCopyWith<$Res> implements $LeagueWeightClassCopyWith<$Res> {
  factory _$$LeagueWeightClassImplCopyWith(_$LeagueWeightClassImpl value, $Res Function(_$LeagueWeightClassImpl) then) =
      __$$LeagueWeightClassImplCopyWithImpl<$Res>;
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
class __$$LeagueWeightClassImplCopyWithImpl<$Res> extends _$LeagueWeightClassCopyWithImpl<$Res, _$LeagueWeightClassImpl>
    implements _$$LeagueWeightClassImplCopyWith<$Res> {
  __$$LeagueWeightClassImplCopyWithImpl(_$LeagueWeightClassImpl _value, $Res Function(_$LeagueWeightClassImpl) _then)
      : super(_value, _then);

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
    return _then(_$LeagueWeightClassImpl(
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
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _value.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueWeightClassImpl extends _LeagueWeightClass {
  const _$LeagueWeightClassImpl(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.pos,
      required this.league,
      required this.weightClass,
      this.seasonPartition})
      : super._();

  factory _$LeagueWeightClassImpl.fromJson(Map<String, dynamic> json) => _$$LeagueWeightClassImplFromJson(json);

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

  @override
  String toString() {
    return 'LeagueWeightClass(id: $id, orgSyncId: $orgSyncId, organization: $organization, pos: $pos, league: $league, weightClass: $weightClass, seasonPartition: $seasonPartition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueWeightClassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.seasonPartition, seasonPartition) || other.seasonPartition == seasonPartition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, pos, league, weightClass, seasonPartition);

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueWeightClassImplCopyWith<_$LeagueWeightClassImpl> get copyWith =>
      __$$LeagueWeightClassImplCopyWithImpl<_$LeagueWeightClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueWeightClassImplToJson(
      this,
    );
  }
}

abstract class _LeagueWeightClass extends LeagueWeightClass {
  const factory _LeagueWeightClass(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      required final int pos,
      required final League league,
      required final WeightClass weightClass,
      final int? seasonPartition}) = _$LeagueWeightClassImpl;
  const _LeagueWeightClass._() : super._();

  factory _LeagueWeightClass.fromJson(Map<String, dynamic> json) = _$LeagueWeightClassImpl.fromJson;

  @override
  int? get id;
  @override
  String? get orgSyncId;
  @override
  Organization? get organization;
  @override
  int get pos;
  @override
  League get league;
  @override
  WeightClass get weightClass;
  @override
  int? get seasonPartition;

  /// Create a copy of LeagueWeightClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueWeightClassImplCopyWith<_$LeagueWeightClassImpl> get copyWith => throw _privateConstructorUsedError;
}
