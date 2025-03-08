// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'age_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgeCategory {
  int? get id;
  String? get orgSyncId;
  Organization? get organization;
  String get name;
  int get minAge;
  int get maxAge;

  /// Create a copy of AgeCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgeCategoryCopyWith<AgeCategory> get copyWith =>
      _$AgeCategoryCopyWithImpl<AgeCategory>(this as AgeCategory, _$identity);

  /// Serializes this AgeCategory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgeCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, minAge, maxAge);

  @override
  String toString() {
    return 'AgeCategory(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, minAge: $minAge, maxAge: $maxAge)';
  }
}

/// @nodoc
abstract mixin class $AgeCategoryCopyWith<$Res> {
  factory $AgeCategoryCopyWith(
          AgeCategory value, $Res Function(AgeCategory) _then) =
      _$AgeCategoryCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      int minAge,
      int maxAge});

  $OrganizationCopyWith<$Res>? get organization;
}

/// @nodoc
class _$AgeCategoryCopyWithImpl<$Res> implements $AgeCategoryCopyWith<$Res> {
  _$AgeCategoryCopyWithImpl(this._self, this._then);

  final AgeCategory _self;
  final $Res Function(AgeCategory) _then;

  /// Create a copy of AgeCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? name = null,
    Object? minAge = null,
    Object? maxAge = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: null == minAge
          ? _self.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int,
      maxAge: null == maxAge
          ? _self.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of AgeCategory
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
class _AgeCategory extends AgeCategory {
  const _AgeCategory(
      {this.id,
      this.orgSyncId,
      this.organization,
      required this.name,
      required this.minAge,
      required this.maxAge})
      : super._();
  factory _AgeCategory.fromJson(Map<String, dynamic> json) =>
      _$AgeCategoryFromJson(json);

  @override
  final int? id;
  @override
  final String? orgSyncId;
  @override
  final Organization? organization;
  @override
  final String name;
  @override
  final int minAge;
  @override
  final int maxAge;

  /// Create a copy of AgeCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgeCategoryCopyWith<_AgeCategory> get copyWith =>
      __$AgeCategoryCopyWithImpl<_AgeCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgeCategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgeCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgSyncId, orgSyncId) ||
                other.orgSyncId == orgSyncId) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgSyncId, organization, name, minAge, maxAge);

  @override
  String toString() {
    return 'AgeCategory(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, minAge: $minAge, maxAge: $maxAge)';
  }
}

/// @nodoc
abstract mixin class _$AgeCategoryCopyWith<$Res>
    implements $AgeCategoryCopyWith<$Res> {
  factory _$AgeCategoryCopyWith(
          _AgeCategory value, $Res Function(_AgeCategory) _then) =
      __$AgeCategoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? orgSyncId,
      Organization? organization,
      String name,
      int minAge,
      int maxAge});

  @override
  $OrganizationCopyWith<$Res>? get organization;
}

/// @nodoc
class __$AgeCategoryCopyWithImpl<$Res> implements _$AgeCategoryCopyWith<$Res> {
  __$AgeCategoryCopyWithImpl(this._self, this._then);

  final _AgeCategory _self;
  final $Res Function(_AgeCategory) _then;

  /// Create a copy of AgeCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? orgSyncId = freezed,
    Object? organization = freezed,
    Object? name = null,
    Object? minAge = null,
    Object? maxAge = null,
  }) {
    return _then(_AgeCategory(
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: null == minAge
          ? _self.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int,
      maxAge: null == maxAge
          ? _self.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of AgeCategory
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
