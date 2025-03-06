// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Person {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  String get prename;
  String get surname;
  Gender? get gender;
  DateTime? get birthDate;
  @CountryJsonConverter()
  Country? get nationality;

  /// Create a copy of Person
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PersonCopyWith<Person> get copyWith => _$PersonCopyWithImpl<Person>(this as Person, _$identity);

  /// Serializes this Person to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Person &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.prename, prename) || other.prename == prename) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) || other.birthDate == birthDate) &&
            (identical(other.nationality, nationality) || other.nationality == nationality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, orgSyncId, organization, prename, surname, gender, birthDate, nationality);

  @override
  String toString() {
    return 'Person(id: $id, orgSyncId: $orgSyncId, organization: $organization, prename: $prename, surname: $surname, gender: $gender, birthDate: $birthDate, nationality: $nationality)';
  }
}

/// @nodoc
abstract mixin class $PersonCopyWith<$Res> {
  factory $PersonCopyWith(Person value, $Res Function(Person) _then) = _$PersonCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String prename,
      String surname,
      Gender? gender,
      DateTime? birthDate,
      @CountryJsonConverter() Country? nationality});

  $OrganizationCopyWith<$Res>? get organization;
}

/// @nodoc
class _$PersonCopyWithImpl<$Res> implements $PersonCopyWith<$Res> {
  _$PersonCopyWithImpl(this._self, this._then);

  final Person _self;
  final $Res Function(Person) _then;

  /// Create a copy of Person
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? prename = null,
    Object? surname = null,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? nationality = freezed,
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
      prename: null == prename
          ? _self.prename
          : prename // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _self.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      birthDate: freezed == birthDate
          ? _self.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nationality: freezed == nationality
          ? _self.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as Country?,
    ));
  }

  /// Create a copy of Person
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
}

/// @nodoc
@JsonSerializable()
class _Person extends Person {
  const _Person(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.prename,
      required this.surname,
      this.gender,
      this.birthDate,
      @CountryJsonConverter() this.nationality})
      : super._();
  factory _Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final String prename;
  @override
  final String surname;
  @override
  final Gender? gender;
  @override
  final DateTime? birthDate;
  @override
  @CountryJsonConverter()
  final Country? nationality;

  /// Create a copy of Person
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PersonCopyWith<_Person> get copyWith => __$PersonCopyWithImpl<_Person>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PersonToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Person &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) || other.organization == organization) &&
            (identical(other.prename, prename) || other.prename == prename) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) || other.birthDate == birthDate) &&
            (identical(other.nationality, nationality) || other.nationality == nationality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, orgSyncId, organization, prename, surname, gender, birthDate, nationality);

  @override
  String toString() {
    return 'Person(id: $id, orgSyncId: $orgSyncId, organization: $organization, prename: $prename, surname: $surname, gender: $gender, birthDate: $birthDate, nationality: $nationality)';
  }
}

/// @nodoc
abstract mixin class _$PersonCopyWith<$Res> implements $PersonCopyWith<$Res> {
  factory _$PersonCopyWith(_Person value, $Res Function(_Person) _then) = __$PersonCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String prename,
      String surname,
      Gender? gender,
      DateTime? birthDate,
      @CountryJsonConverter() Country? nationality});

  @override
  $OrganizationCopyWith<$Res>? get organization;
}

/// @nodoc
class __$PersonCopyWithImpl<$Res> implements _$PersonCopyWith<$Res> {
  __$PersonCopyWithImpl(this._self, this._then);

  final _Person _self;
  final $Res Function(_Person) _then;

  /// Create a copy of Person
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? prename = null,
    Object? surname = null,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? nationality = freezed,
  }) {
    return _then(_Person(
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
      prename: null == prename
          ? _self.prename
          : prename // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _self.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender?,
      birthDate: freezed == birthDate
          ? _self.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nationality: freezed == nationality
          ? _self.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as Country?,
    ));
  }

  /// Create a copy of Person
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
}

// dart format on
