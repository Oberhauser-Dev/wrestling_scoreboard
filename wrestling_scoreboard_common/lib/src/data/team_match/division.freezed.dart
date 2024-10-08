// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'division.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Division _$DivisionFromJson(Map<String, dynamic> json) {
  return _Division.fromJson(json);
}

/// @nodoc
mixin _$Division {
  int? get id => throw _privateConstructorUsedError;
  String? get orgSyncId => throw _privateConstructorUsedError;
  Organization get organization => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  BoutConfig get boutConfig => throw _privateConstructorUsedError;
  int get seasonPartitions => throw _privateConstructorUsedError;
  Division? get parent => throw _privateConstructorUsedError;

  /// Serializes this Division to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DivisionCopyWith<Division> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DivisionCopyWith<$Res> {
  factory $DivisionCopyWith(Division value, $Res Function(Division) then) = _$DivisionCopyWithImpl<$Res, Division>;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization organization,
      String name,
      DateTime startDate,
      DateTime endDate,
      BoutConfig boutConfig,
      int seasonPartitions,
      Division? parent});

  $OrganizationCopyWith<$Res> get organization;
  $BoutConfigCopyWith<$Res> get boutConfig;
  $DivisionCopyWith<$Res>? get parent;
}

/// @nodoc
class _$DivisionCopyWithImpl<$Res, $Val extends Division> implements $DivisionCopyWith<$Res> {
  _$DivisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
    Object? parent = freezed,
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
      organization: null == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      seasonPartitions: null == seasonPartitions
          ? _value.seasonPartitions
          : seasonPartitions // ignore: cast_nullable_to_non_nullable
              as int,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as Division?,
    ) as $Val);
  }

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res> get organization {
    return $OrganizationCopyWith<$Res>(_value.organization, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DivisionCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $DivisionCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DivisionImplCopyWith<$Res> implements $DivisionCopyWith<$Res> {
  factory _$$DivisionImplCopyWith(_$DivisionImpl value, $Res Function(_$DivisionImpl) then) =
      __$$DivisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization organization,
      String name,
      DateTime startDate,
      DateTime endDate,
      BoutConfig boutConfig,
      int seasonPartitions,
      Division? parent});

  @override
  $OrganizationCopyWith<$Res> get organization;
  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
  @override
  $DivisionCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$DivisionImplCopyWithImpl<$Res> extends _$DivisionCopyWithImpl<$Res, _$DivisionImpl>
    implements _$$DivisionImplCopyWith<$Res> {
  __$$DivisionImplCopyWithImpl(_$DivisionImpl _value, $Res Function(_$DivisionImpl) _then) : super(_value, _then);

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
    Object? parent = freezed,
  }) {
    return _then(_$DivisionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _value.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: null == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      seasonPartitions: null == seasonPartitions
          ? _value.seasonPartitions
          : seasonPartitions // ignore: cast_nullable_to_non_nullable
              as int,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as Division?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DivisionImpl extends _Division {
  const _$DivisionImpl(
      {this.id,
      this.orgSyncId,
      required this.organization,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.boutConfig,
      required this.seasonPartitions,
      this.parent})
      : super._();

  factory _$DivisionImpl.fromJson(Map<String, dynamic> json) => _$$DivisionImplFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization organization;
  @override
  final String name;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final BoutConfig boutConfig;
  @override
  final int seasonPartitions;
  @override
  final Division? parent;

  @override
  String toString() {
    return 'Division(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, boutConfig: $boutConfig, seasonPartitions: $seasonPartitions, parent: $parent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DivisionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.seasonPartitions, seasonPartitions) || other.seasonPartitions == seasonPartitions) &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, startDate, endDate, boutConfig, seasonPartitions, parent);

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DivisionImplCopyWith<_$DivisionImpl> get copyWith =>
      __$$DivisionImplCopyWithImpl<_$DivisionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DivisionImplToJson(
      this,
    );
  }
}

abstract class _Division extends Division {
  const factory _Division(
      {final int? id,
      final String? orgSyncId,
      required final Organization organization,
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      required final BoutConfig boutConfig,
      required final int seasonPartitions,
      final Division? parent}) = _$DivisionImpl;
  const _Division._() : super._();

  factory _Division.fromJson(Map<String, dynamic> json) = _$DivisionImpl.fromJson;

  @override
  int? get id;
  @override
  String? get orgSyncId;
  @override
  Organization get organization;
  @override
  String get name;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  BoutConfig get boutConfig;
  @override
  int get seasonPartitions;
  @override
  Division? get parent;

  /// Create a copy of Division
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DivisionImplCopyWith<_$DivisionImpl> get copyWith => throw _privateConstructorUsedError;
}
