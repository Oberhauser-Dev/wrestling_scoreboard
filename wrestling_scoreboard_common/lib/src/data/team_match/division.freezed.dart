// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'division.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Division {

 int? get id; String? get orgSyncId; Organization get organization; String get name; DateTime get startDate; DateTime get endDate; BoutConfig get boutConfig; int get seasonPartitions; Division? get parent;
/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DivisionCopyWith<Division> get copyWith => _$DivisionCopyWithImpl<Division>(this as Division, _$identity);

  /// Serializes this Division to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Division&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig)&&(identical(other.seasonPartitions, seasonPartitions) || other.seasonPartitions == seasonPartitions)&&(identical(other.parent, parent) || other.parent == parent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,name,startDate,endDate,boutConfig,seasonPartitions,parent);

@override
String toString() {
  return 'Division(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, boutConfig: $boutConfig, seasonPartitions: $seasonPartitions, parent: $parent)';
}


}

/// @nodoc
abstract mixin class $DivisionCopyWith<$Res>  {
  factory $DivisionCopyWith(Division value, $Res Function(Division) _then) = _$DivisionCopyWithImpl;
@useResult
$Res call({
 int? id, String? orgSyncId, Organization organization, String name, DateTime startDate, DateTime endDate, BoutConfig boutConfig, int seasonPartitions, Division? parent
});


$OrganizationCopyWith<$Res> get organization;$BoutConfigCopyWith<$Res> get boutConfig;$DivisionCopyWith<$Res>? get parent;

}
/// @nodoc
class _$DivisionCopyWithImpl<$Res>
    implements $DivisionCopyWith<$Res> {
  _$DivisionCopyWithImpl(this._self, this._then);

  final Division _self;
  final $Res Function(Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? boutConfig = null,Object? seasonPartitions = null,Object? parent = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,seasonPartitions: null == seasonPartitions ? _self.seasonPartitions : seasonPartitions // ignore: cast_nullable_to_non_nullable
as int,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Division?,
  ));
}
/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res> get organization {
  
  return $OrganizationCopyWith<$Res>(_self.organization, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DivisionCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $DivisionCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}


/// Adds pattern-matching-related methods to [Division].
extension DivisionPatterns on Division {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Division value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Division value)  $default,){
final _that = this;
switch (_that) {
case _Division():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Division value)?  $default,){
final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? orgSyncId,  Organization organization,  String name,  DateTime startDate,  DateTime endDate,  BoutConfig boutConfig,  int seasonPartitions,  Division? parent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.id,_that.orgSyncId,_that.organization,_that.name,_that.startDate,_that.endDate,_that.boutConfig,_that.seasonPartitions,_that.parent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? orgSyncId,  Organization organization,  String name,  DateTime startDate,  DateTime endDate,  BoutConfig boutConfig,  int seasonPartitions,  Division? parent)  $default,) {final _that = this;
switch (_that) {
case _Division():
return $default(_that.id,_that.orgSyncId,_that.organization,_that.name,_that.startDate,_that.endDate,_that.boutConfig,_that.seasonPartitions,_that.parent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? orgSyncId,  Organization organization,  String name,  DateTime startDate,  DateTime endDate,  BoutConfig boutConfig,  int seasonPartitions,  Division? parent)?  $default,) {final _that = this;
switch (_that) {
case _Division() when $default != null:
return $default(_that.id,_that.orgSyncId,_that.organization,_that.name,_that.startDate,_that.endDate,_that.boutConfig,_that.seasonPartitions,_that.parent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Division extends Division {
  const _Division({this.id, this.orgSyncId, required this.organization, required this.name, required this.startDate, required this.endDate, required this.boutConfig, required this.seasonPartitions, this.parent}): super._();
  factory _Division.fromJson(Map<String, dynamic> json) => _$DivisionFromJson(json);

@override final  int? id;
@override final  String? orgSyncId;
@override final  Organization organization;
@override final  String name;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  BoutConfig boutConfig;
@override final  int seasonPartitions;
@override final  Division? parent;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DivisionCopyWith<_Division> get copyWith => __$DivisionCopyWithImpl<_Division>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DivisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Division&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig)&&(identical(other.seasonPartitions, seasonPartitions) || other.seasonPartitions == seasonPartitions)&&(identical(other.parent, parent) || other.parent == parent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,name,startDate,endDate,boutConfig,seasonPartitions,parent);

@override
String toString() {
  return 'Division(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, boutConfig: $boutConfig, seasonPartitions: $seasonPartitions, parent: $parent)';
}


}

/// @nodoc
abstract mixin class _$DivisionCopyWith<$Res> implements $DivisionCopyWith<$Res> {
  factory _$DivisionCopyWith(_Division value, $Res Function(_Division) _then) = __$DivisionCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? orgSyncId, Organization organization, String name, DateTime startDate, DateTime endDate, BoutConfig boutConfig, int seasonPartitions, Division? parent
});


@override $OrganizationCopyWith<$Res> get organization;@override $BoutConfigCopyWith<$Res> get boutConfig;@override $DivisionCopyWith<$Res>? get parent;

}
/// @nodoc
class __$DivisionCopyWithImpl<$Res>
    implements _$DivisionCopyWith<$Res> {
  __$DivisionCopyWithImpl(this._self, this._then);

  final _Division _self;
  final $Res Function(_Division) _then;

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = null,Object? name = null,Object? startDate = null,Object? endDate = null,Object? boutConfig = null,Object? seasonPartitions = null,Object? parent = freezed,}) {
  return _then(_Division(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,seasonPartitions: null == seasonPartitions ? _self.seasonPartitions : seasonPartitions // ignore: cast_nullable_to_non_nullable
as int,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as Division?,
  ));
}

/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res> get organization {
  
  return $OrganizationCopyWith<$Res>(_self.organization, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}/// Create a copy of Division
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DivisionCopyWith<$Res>? get parent {
    if (_self.parent == null) {
    return null;
  }

  return $DivisionCopyWith<$Res>(_self.parent!, (value) {
    return _then(_self.copyWith(parent: value));
  });
}
}

// dart format on
