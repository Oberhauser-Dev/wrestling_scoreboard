// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

League _$LeagueFromJson(Map<String, dynamic> json) {
  return _League.fromJson(json);
}

/// @nodoc
mixin _$League {
  int? get id => throw _privateConstructorUsedError;

  String? get orgSyncId => throw _privateConstructorUsedError;

  Organization? get organization => throw _privateConstructorUsedError;

  String get name => throw _privateConstructorUsedError;

  DateTime get startDate => throw _privateConstructorUsedError;

  DateTime get endDate => throw _privateConstructorUsedError;

  Division get division => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LeagueCopyWith<League> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueCopyWith<$Res> {
  factory $LeagueCopyWith(League value, $Res Function(League) then) = _$LeagueCopyWithImpl<$Res, League>;

  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      DateTime startDate,
      DateTime endDate,
      Division division});

  $OrganizationCopyWith<$Res>? get organization;

  $DivisionCopyWith<$Res> get division;
}

/// @nodoc
class _$LeagueCopyWithImpl<$Res, $Val extends League> implements $LeagueCopyWith<$Res> {
  _$LeagueCopyWithImpl(this._value, this._then);

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
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? division = null,
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
      division: null == division
          ? _value.division
          : division // ignore: cast_nullable_to_non_nullable
              as Division,
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
  $DivisionCopyWith<$Res> get division {
    return $DivisionCopyWith<$Res>(_value.division, (value) {
      return _then(_value.copyWith(division: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeagueImplCopyWith<$Res> implements $LeagueCopyWith<$Res> {
  factory _$$LeagueImplCopyWith(_$LeagueImpl value, $Res Function(_$LeagueImpl) then) =
      __$$LeagueImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      DateTime startDate,
      DateTime endDate,
      Division division});

  @override
  $OrganizationCopyWith<$Res>? get organization;

  @override
  $DivisionCopyWith<$Res> get division;
}

/// @nodoc
class __$$LeagueImplCopyWithImpl<$Res> extends _$LeagueCopyWithImpl<$Res, _$LeagueImpl>
    implements _$$LeagueImplCopyWith<$Res> {
  __$$LeagueImplCopyWithImpl(_$LeagueImpl _value, $Res Function(_$LeagueImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? division = null,
  }) {
    return _then(_$LeagueImpl(
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
      division: null == division
          ? _value.division
          : division // ignore: cast_nullable_to_non_nullable
              as Division,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueImpl extends _League {
  const _$LeagueImpl(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.division})
      : super._();

  factory _$LeagueImpl.fromJson(Map<String, dynamic> json) => _$$LeagueImplFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final String name;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final Division division;

  @override
  String toString() {
    return 'League(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, division: $division)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.division, division) || other.division == division));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, name, startDate, endDate, division);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith => __$$LeagueImplCopyWithImpl<_$LeagueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueImplToJson(
      this,
    );
  }
}

abstract class _League extends League {
  const factory _League(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      required final Division division}) = _$LeagueImpl;

  const _League._() : super._();

  factory _League.fromJson(Map<String, dynamic> json) = _$LeagueImpl.fromJson;

  @override
  int? get id;

  @override
  String? get orgSyncId;

  @override
  Organization? get organization;

  @override
  String get name;

  @override
  DateTime get startDate;

  @override
  DateTime get endDate;

  @override
  Division get division;

  @override
  @JsonKey(ignore: true)
  _$$LeagueImplCopyWith<_$LeagueImpl> get copyWith => throw _privateConstructorUsedError;
}
