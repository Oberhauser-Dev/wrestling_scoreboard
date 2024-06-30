// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Competition _$CompetitionFromJson(Map<String, dynamic> json) {
  return _Competition.fromJson(json);
}

/// @nodoc
mixin _$Competition {
  int? get id => throw _privateConstructorUsedError;

  String? get orgSyncId => throw _privateConstructorUsedError;

  Organization? get organization => throw _privateConstructorUsedError;

  String get name => throw _privateConstructorUsedError;

  BoutConfig get boutConfig => throw _privateConstructorUsedError;

  String? get location => throw _privateConstructorUsedError;

  DateTime get date => throw _privateConstructorUsedError;

  String? get no => throw _privateConstructorUsedError;

  int? get visitorsCount => throw _privateConstructorUsedError;

  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompetitionCopyWith<Competition> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitionCopyWith<$Res> {
  factory $CompetitionCopyWith(Competition value, $Res Function(Competition) then) =
      _$CompetitionCopyWithImpl<$Res, Competition>;

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
class _$CompetitionCopyWithImpl<$Res, $Val extends Competition> implements $CompetitionCopyWith<$Res> {
  _$CompetitionCopyWithImpl(this._value, this._then);

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
    Object? boutConfig = null,
    Object? location = freezed,
    Object? date = null,
    Object? no = freezed,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
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
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompetitionImplCopyWith<$Res> implements $CompetitionCopyWith<$Res> {
  factory _$$CompetitionImplCopyWith(_$CompetitionImpl value, $Res Function(_$CompetitionImpl) then) =
      __$$CompetitionImplCopyWithImpl<$Res>;

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
class __$$CompetitionImplCopyWithImpl<$Res> extends _$CompetitionCopyWithImpl<$Res, _$CompetitionImpl>
    implements _$$CompetitionImplCopyWith<$Res> {
  __$$CompetitionImplCopyWithImpl(_$CompetitionImpl _value, $Res Function(_$CompetitionImpl) _then)
      : super(_value, _then);

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
    return _then(_$CompetitionImpl(
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
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitionImpl extends _Competition {
  const _$CompetitionImpl(
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

  factory _$CompetitionImpl.fromJson(Map<String, dynamic> json) => _$$CompetitionImplFromJson(json);

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

  @override
  String toString() {
    return 'Competition(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, boutConfig: $boutConfig, location: $location, date: $date, no: $no, visitorsCount: $visitorsCount, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitionImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, boutConfig, location, date, no, visitorsCount, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitionImplCopyWith<_$CompetitionImpl> get copyWith =>
      __$$CompetitionImplCopyWithImpl<_$CompetitionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitionImplToJson(
      this,
    );
  }
}

abstract class _Competition extends Competition {
  const factory _Competition(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      required final String name,
      required final BoutConfig boutConfig,
      final String? location,
      required final DateTime date,
      final String? no,
      final int? visitorsCount,
      final String? comment}) = _$CompetitionImpl;

  const _Competition._() : super._();

  factory _Competition.fromJson(Map<String, dynamic> json) = _$CompetitionImpl.fromJson;

  @override
  int? get id;

  @override
  String? get orgSyncId;

  @override
  Organization? get organization;

  @override
  String get name;

  @override
  BoutConfig get boutConfig;

  @override
  String? get location;

  @override
  DateTime get date;

  @override
  String? get no;

  @override
  int? get visitorsCount;

  @override
  String? get comment;

  @override
  @JsonKey(ignore: true)
  _$$CompetitionImplCopyWith<_$CompetitionImpl> get copyWith => throw _privateConstructorUsedError;
}
