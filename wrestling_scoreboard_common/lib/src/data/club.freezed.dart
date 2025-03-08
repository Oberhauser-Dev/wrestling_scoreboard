// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Club {
  int? get id;
  String? get orgSyncId;
  Organization get organization;
  String get name;
  String? get no;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubCopyWith<Club> get copyWith =>
      _$ClubCopyWithImpl<Club>(this as Club, _$identity);

  /// Serializes this Club to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Club &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.no, no) || other.no == no));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, orgSyncId, organization, name, no);

  @override
  String toString() {
    return 'Club(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, no: $no)';
  }
}

/// @nodoc
abstract mixin class $ClubCopyWith<$Res> {
  factory $ClubCopyWith(Club value, $Res Function(Club) _then) =
      _$ClubCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization organization,
      String name,
      String? no});

  $OrganizationCopyWith<$Res> get organization;
}

/// @nodoc
class _$ClubCopyWithImpl<$Res> implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._self, this._then);

  final Club _self;
  final $Res Function(Club) _then;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = null,
    Object? name = null,
    Object? no = freezed,
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
      organization: null == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res> get organization {
    return $OrganizationCopyWith<$Res>(_self.organization, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Club extends Club {
  const _Club(
      {this.id,
      this.orgSyncId,
      required this.organization,
      required this.name,
      this.no})
      : super._();
  factory _Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization organization;
  @override
  final String name;
  @override
  final String? no;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubCopyWith<_Club> get copyWith =>
      __$ClubCopyWithImpl<_Club>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Club &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.no, no) || other.no == no));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, orgSyncId, organization, name, no);

  @override
  String toString() {
    return 'Club(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, no: $no)';
  }
}

/// @nodoc
abstract mixin class _$ClubCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$ClubCopyWith(_Club value, $Res Function(_Club) _then) =
      __$ClubCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization organization,
      String name,
      String? no});

  @override
  $OrganizationCopyWith<$Res> get organization;
}

/// @nodoc
class __$ClubCopyWithImpl<$Res> implements _$ClubCopyWith<$Res> {
  __$ClubCopyWithImpl(this._self, this._then);

  final _Club _self;
  final $Res Function(_Club) _then;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = null,
    Object? name = null,
    Object? no = freezed,
  }) {
    return _then(_Club(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orgSyncId: freezed == orgSyncId
          ? _self.orgSyncId
          : orgSyncId // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: null == organization
          ? _self.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as Organization,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      no: freezed == no
          ? _self.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res> get organization {
    return $OrganizationCopyWith<$Res>(_self.organization, (value) {
      return _then(_self.copyWith(organization: value));
    });
  }
}

// dart format on
