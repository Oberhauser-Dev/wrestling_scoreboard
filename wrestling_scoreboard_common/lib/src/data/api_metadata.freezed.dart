// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiMetadata {

 int get entityId; String get entityType; DateTime? get lastImport;
/// Create a copy of ApiMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiMetadataCopyWith<ApiMetadata> get copyWith => _$ApiMetadataCopyWithImpl<ApiMetadata>(this as ApiMetadata, _$identity);

  /// Serializes this ApiMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiMetadata&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.lastImport, lastImport) || other.lastImport == lastImport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entityId,entityType,lastImport);

@override
String toString() {
  return 'ApiMetadata(entityId: $entityId, entityType: $entityType, lastImport: $lastImport)';
}


}

/// @nodoc
abstract mixin class $ApiMetadataCopyWith<$Res>  {
  factory $ApiMetadataCopyWith(ApiMetadata value, $Res Function(ApiMetadata) _then) = _$ApiMetadataCopyWithImpl;
@useResult
$Res call({
 int entityId, String entityType, DateTime? lastImport
});




}
/// @nodoc
class _$ApiMetadataCopyWithImpl<$Res>
    implements $ApiMetadataCopyWith<$Res> {
  _$ApiMetadataCopyWithImpl(this._self, this._then);

  final ApiMetadata _self;
  final $Res Function(ApiMetadata) _then;

/// Create a copy of ApiMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityId = null,Object? entityType = null,Object? lastImport = freezed,}) {
  return _then(_self.copyWith(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as int,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,lastImport: freezed == lastImport ? _self.lastImport : lastImport // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiMetadata].
extension ApiMetadataPatterns on ApiMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ApiMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ApiMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int entityId,  String entityType,  DateTime? lastImport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiMetadata() when $default != null:
return $default(_that.entityId,_that.entityType,_that.lastImport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int entityId,  String entityType,  DateTime? lastImport)  $default,) {final _that = this;
switch (_that) {
case _ApiMetadata():
return $default(_that.entityId,_that.entityType,_that.lastImport);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int entityId,  String entityType,  DateTime? lastImport)?  $default,) {final _that = this;
switch (_that) {
case _ApiMetadata() when $default != null:
return $default(_that.entityId,_that.entityType,_that.lastImport);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiMetadata extends ApiMetadata {
  const _ApiMetadata({required this.entityId, required this.entityType, this.lastImport}): super._();
  factory _ApiMetadata.fromJson(Map<String, dynamic> json) => _$ApiMetadataFromJson(json);

@override final  int entityId;
@override final  String entityType;
@override final  DateTime? lastImport;

/// Create a copy of ApiMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiMetadataCopyWith<_ApiMetadata> get copyWith => __$ApiMetadataCopyWithImpl<_ApiMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiMetadata&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.lastImport, lastImport) || other.lastImport == lastImport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entityId,entityType,lastImport);

@override
String toString() {
  return 'ApiMetadata(entityId: $entityId, entityType: $entityType, lastImport: $lastImport)';
}


}

/// @nodoc
abstract mixin class _$ApiMetadataCopyWith<$Res> implements $ApiMetadataCopyWith<$Res> {
  factory _$ApiMetadataCopyWith(_ApiMetadata value, $Res Function(_ApiMetadata) _then) = __$ApiMetadataCopyWithImpl;
@override @useResult
$Res call({
 int entityId, String entityType, DateTime? lastImport
});




}
/// @nodoc
class __$ApiMetadataCopyWithImpl<$Res>
    implements _$ApiMetadataCopyWith<$Res> {
  __$ApiMetadataCopyWithImpl(this._self, this._then);

  final _ApiMetadata _self;
  final $Res Function(_ApiMetadata) _then;

/// Create a copy of ApiMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityId = null,Object? entityType = null,Object? lastImport = freezed,}) {
  return _then(_ApiMetadata(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as int,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,lastImport: freezed == lastImport ? _self.lastImport : lastImport // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
