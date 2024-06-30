// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Membership _$MembershipFromJson(Map<String, dynamic> json) {
  return _Membership.fromJson(json);
}

/// @nodoc
mixin _$Membership {
  int? get id => throw _privateConstructorUsedError;

  String? get orgSyncId => throw _privateConstructorUsedError;

  Organization? get organization => throw _privateConstructorUsedError;

  String? get no => throw _privateConstructorUsedError; // Vereinsnummer
  Club get club => throw _privateConstructorUsedError;

  Person get person => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MembershipCopyWith<Membership> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipCopyWith<$Res> {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) then) =
      _$MembershipCopyWithImpl<$Res, Membership>;

  @useResult
  $Res call({int? id, String? orgSyncId, Organization? organization, String? no, Club club, Person person});

  $OrganizationCopyWith<$Res>? get organization;

  $ClubCopyWith<$Res> get club;

  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class _$MembershipCopyWithImpl<$Res, $Val extends Membership> implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._value, this._then);

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
    Object? no = freezed,
    Object? club = null,
    Object? person = null,
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
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person,
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
  $ClubCopyWith<$Res> get club {
    return $ClubCopyWith<$Res>(_value.club, (value) {
      return _then(_value.copyWith(club: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonCopyWith<$Res> get person {
    return $PersonCopyWith<$Res>(_value.person, (value) {
      return _then(_value.copyWith(person: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MembershipImplCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$$MembershipImplCopyWith(_$MembershipImpl value, $Res Function(_$MembershipImpl) then) =
      __$$MembershipImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({int? id, String? orgSyncId, Organization? organization, String? no, Club club, Person person});

  @override
  $OrganizationCopyWith<$Res>? get organization;

  @override
  $ClubCopyWith<$Res> get club;

  @override
  $PersonCopyWith<$Res> get person;
}

/// @nodoc
class __$$MembershipImplCopyWithImpl<$Res> extends _$MembershipCopyWithImpl<$Res, _$MembershipImpl>
    implements _$$MembershipImplCopyWith<$Res> {
  __$$MembershipImplCopyWithImpl(_$MembershipImpl _value, $Res Function(_$MembershipImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? no = freezed,
    Object? club = null,
    Object? person = null,
  }) {
    return _then(_$MembershipImpl(
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
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      club: null == club
          ? _value.club
          : club // ignore: cast_nullable_to_non_nullable
              as Club,
      person: null == person
          ? _value.person
          : person // ignore: cast_nullable_to_non_nullable
              as Person,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipImpl extends _Membership {
  const _$MembershipImpl(
      {this.id, this.orgSyncId, this.organization, this.no, required this.club, required this.person})
      : super._();

  factory _$MembershipImpl.fromJson(Map<String, dynamic> json) => _$$MembershipImplFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final String? no;

// Vereinsnummer
  @override
  final Club club;
  @override
  final Person person;

  @override
  String toString() {
    return 'Membership(id: $id, orgSyncId: $orgSyncId, organization: $organization, no: $no, club: $club, person: $person)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.club, club) || other.club == club) &&
            (identical(other.person, person) || other.person == person));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgSyncId, organization, no, club, person);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith =>
      __$$MembershipImplCopyWithImpl<_$MembershipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipImplToJson(
      this,
    );
  }
}

abstract class _Membership extends Membership {
  const factory _Membership(
      {final int? id,
      final String? orgSyncId,
      final Organization? organization,
      final String? no,
      required final Club club,
      required final Person person}) = _$MembershipImpl;

  const _Membership._() : super._();

  factory _Membership.fromJson(Map<String, dynamic> json) = _$MembershipImpl.fromJson;

  @override
  int? get id;

  @override
  String? get orgSyncId;

  @override
  Organization? get organization;

  @override
  String? get no;

  @override // Vereinsnummer
  Club get club;

  @override
  Person get person;

  @override
  @JsonKey(ignore: true)
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith => throw _privateConstructorUsedError;
}
