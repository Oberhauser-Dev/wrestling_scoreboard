// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Organization {

 int? get id; String get name; String? get abbreviation; Organization? get parent; WrestlingApiProvider? get apiProvider; WrestlingReportProvider? get reportProvider;
/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationCopyWith<Organization> get copyWith => _$OrganizationCopyWithImpl<Organization>(this as Organization, _$identity);

  /// Serializes this Organization to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Organization&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.abbreviation, abbreviation) || other.abbreviation == abbreviation)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.apiProvider, apiProvider) || other.apiProvider == apiProvider)&&(identical(other.reportProvider, reportProvider) || other.reportProvider == reportProvider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,abbreviation,parent,apiProvider,reportProvider);

@override
String toString() {
  return 'Organization(id: $id, name: $name, abbreviation: $abbreviation, parent: $parent, apiProvider: $apiProvider, reportProvider: $reportProvider)';
}


}

/// @nodoc
abstract mixin class $OrganizationCopyWith<$Res>  {
  factory $OrganizationCopyWith(Organization value, $Res Function(Organization) _then) = _$OrganizationCopyWithImpl;
@useResult
$Res call({
 int? id, String name, String? abbreviation, Organization? parent, WrestlingApiProvider? apiProvider, WrestlingReportProvider? reportProvider
});


$OrganizationCopyWith<$Res>? get parent;

}
/// @nodoc
class _$OrganizationCopyWithImpl<$Res>
    implements $OrganizationCopyWith<$Res> {
  _$OrganizationCopyWithImpl(this._self, this._then);

  final Organization _self;
  final $Res Function(Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? abbreviation = freezed,Object? parent = freezed,Object? apiProvider = freezed,Object? reportProvider = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,abbreviation: freezed == abbreviation ? _self.abbreviation : abbreviation // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Organization?,apiProvider: freezed == apiProvider ? _self.apiProvider : apiProvider // ignore: cast_nullable_to_non_nullable
as WrestlingApiProvider?,reportProvider: freezed == reportProvider ? _self.reportProvider : reportProvider // ignore: cast_nullable_to_non_nullable
as WrestlingReportProvider?,
  ));
}
/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Organization extends Organization {
  const _Organization({this.id, required this.name, this.abbreviation, this.parent, this.apiProvider, this.reportProvider}): super._();
  factory _Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

@override final  int? id;
@override final  String name;
@override final  String? abbreviation;
@override final  Organization? parent;
@override final  WrestlingApiProvider? apiProvider;
@override final  WrestlingReportProvider? reportProvider;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationCopyWith<_Organization> get copyWith => __$OrganizationCopyWithImpl<_Organization>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Organization&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.abbreviation, abbreviation) || other.abbreviation == abbreviation)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.apiProvider, apiProvider) || other.apiProvider == apiProvider)&&(identical(other.reportProvider, reportProvider) || other.reportProvider == reportProvider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,abbreviation,parent,apiProvider,reportProvider);

@override
String toString() {
  return 'Organization(id: $id, name: $name, abbreviation: $abbreviation, parent: $parent, apiProvider: $apiProvider, reportProvider: $reportProvider)';
}


}

/// @nodoc
abstract mixin class _$OrganizationCopyWith<$Res> implements $OrganizationCopyWith<$Res> {
  factory _$OrganizationCopyWith(_Organization value, $Res Function(_Organization) _then) = __$OrganizationCopyWithImpl;
@override @useResult
$Res call({
 int? id, String name, String? abbreviation, Organization? parent, WrestlingApiProvider? apiProvider, WrestlingReportProvider? reportProvider
});


@override $OrganizationCopyWith<$Res>? get parent;

}
/// @nodoc
class __$OrganizationCopyWithImpl<$Res>
    implements _$OrganizationCopyWith<$Res> {
  __$OrganizationCopyWithImpl(this._self, this._then);

  final _Organization _self;
  final $Res Function(_Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? abbreviation = freezed,Object? parent = freezed,Object? apiProvider = freezed,Object? reportProvider = freezed,}) {
  return _then(_Organization(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,abbreviation: freezed == abbreviation ? _self.abbreviation : abbreviation // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Organization?,apiProvider: freezed == apiProvider ? _self.apiProvider : apiProvider // ignore: cast_nullable_to_non_nullable
as WrestlingApiProvider?,reportProvider: freezed == reportProvider ? _self.reportProvider : reportProvider // ignore: cast_nullable_to_non_nullable
as WrestlingReportProvider?,
  ));
}

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}

// dart format on
