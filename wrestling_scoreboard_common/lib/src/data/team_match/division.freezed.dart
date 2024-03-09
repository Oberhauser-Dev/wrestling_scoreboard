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
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  BoutConfig get boutConfig => throw _privateConstructorUsedError;
  int get seasonPartitions => throw _privateConstructorUsedError;
  Division? get parent => throw _privateConstructorUsedError;
  Organization get organization => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DivisionCopyWith<Division> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DivisionCopyWith<$Res> {
  factory $DivisionCopyWith(Division value, $Res Function(Division) then) = _$DivisionCopyWithImpl<$Res, Division>;
  @useResult
  $Res call(
      {int? id,
      String name,
      DateTime startDate,
      DateTime endDate,
      BoutConfig boutConfig,
      int seasonPartitions,
      Division? parent,
      Organization organization});

  $BoutConfigCopyWith<$Res> get boutConfig;
  $DivisionCopyWith<$Res>? get parent;
  $OrganizationCopyWith<$Res> get organization;
}

/// @nodoc
class _$DivisionCopyWithImpl<$Res, $Val extends Division> implements $DivisionCopyWith<$Res> {
  _$DivisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
    Object? parent = freezed,
    Object? organization = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
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
      organization: null == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }

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

  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res> get organization {
    return $OrganizationCopyWith<$Res>(_value.organization, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
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
      String name,
      DateTime startDate,
      DateTime endDate,
      BoutConfig boutConfig,
      int seasonPartitions,
      Division? parent,
      Organization organization});

  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
  @override
  $DivisionCopyWith<$Res>? get parent;
  @override
  $OrganizationCopyWith<$Res> get organization;
}

/// @nodoc
class __$$DivisionImplCopyWithImpl<$Res> extends _$DivisionCopyWithImpl<$Res, _$DivisionImpl>
    implements _$$DivisionImplCopyWith<$Res> {
  __$$DivisionImplCopyWithImpl(_$DivisionImpl _value, $Res Function(_$DivisionImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? boutConfig = null,
    Object? seasonPartitions = null,
    Object? parent = freezed,
    Object? organization = null,
  }) {
    return _then(_$DivisionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
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
      organization: null == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DivisionImpl extends _Division {
  const _$DivisionImpl(
      {this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.boutConfig,
      required this.seasonPartitions,
      this.parent,
      required this.organization})
      : super._();

  factory _$DivisionImpl.fromJson(Map<String, dynamic> json) => _$$DivisionImplFromJson(json);

  @override
  final int? id;
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
  final Organization organization;

  @override
  String toString() {
    return 'Division(id: $id, name: $name, startDate: $startDate, endDate: $endDate, boutConfig: $boutConfig, seasonPartitions: $seasonPartitions, parent: $parent, organization: $organization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DivisionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig) &&
            (identical(other.seasonPartitions, seasonPartitions) || other.seasonPartitions == seasonPartitions) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.organization, organization) || other.organization == organization));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, startDate, endDate, boutConfig, seasonPartitions, parent, organization);

  @JsonKey(ignore: true)
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
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      required final BoutConfig boutConfig,
      required final int seasonPartitions,
      final Division? parent,
      required final Organization organization}) = _$DivisionImpl;
  const _Division._() : super._();

  factory _Division.fromJson(Map<String, dynamic> json) = _$DivisionImpl.fromJson;

  @override
  int? get id;
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
  @override
  Organization get organization;
  @override
  @JsonKey(ignore: true)
  _$$DivisionImplCopyWith<_$DivisionImpl> get copyWith => throw _privateConstructorUsedError;
}
