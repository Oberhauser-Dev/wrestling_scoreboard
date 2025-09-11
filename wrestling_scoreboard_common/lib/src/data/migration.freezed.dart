// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'migration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Migration {

 String get semver; String get minClientVersion;
/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationCopyWith<Migration> get copyWith => _$MigrationCopyWithImpl<Migration>(this as Migration, _$identity);

  /// Serializes this Migration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Migration&&(identical(other.semver, semver) || other.semver == semver)&&(identical(other.minClientVersion, minClientVersion) || other.minClientVersion == minClientVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semver,minClientVersion);

@override
String toString() {
  return 'Migration(semver: $semver, minClientVersion: $minClientVersion)';
}


}

/// @nodoc
abstract mixin class $MigrationCopyWith<$Res>  {
  factory $MigrationCopyWith(Migration value, $Res Function(Migration) _then) = _$MigrationCopyWithImpl;
@useResult
$Res call({
 String semver, String minClientVersion
});




}
/// @nodoc
class _$MigrationCopyWithImpl<$Res>
    implements $MigrationCopyWith<$Res> {
  _$MigrationCopyWithImpl(this._self, this._then);

  final Migration _self;
  final $Res Function(Migration) _then;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semver = null,Object? minClientVersion = null,}) {
  return _then(_self.copyWith(
semver: null == semver ? _self.semver : semver // ignore: cast_nullable_to_non_nullable
as String,minClientVersion: null == minClientVersion ? _self.minClientVersion : minClientVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Migration].
extension MigrationPatterns on Migration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Migration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Migration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Migration value)  $default,){
final _that = this;
switch (_that) {
case _Migration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Migration value)?  $default,){
final _that = this;
switch (_that) {
case _Migration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String semver,  String minClientVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Migration() when $default != null:
return $default(_that.semver,_that.minClientVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String semver,  String minClientVersion)  $default,) {final _that = this;
switch (_that) {
case _Migration():
return $default(_that.semver,_that.minClientVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String semver,  String minClientVersion)?  $default,) {final _that = this;
switch (_that) {
case _Migration() when $default != null:
return $default(_that.semver,_that.minClientVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Migration extends Migration {
  const _Migration({required this.semver, required this.minClientVersion}): super._();
  factory _Migration.fromJson(Map<String, dynamic> json) => _$MigrationFromJson(json);

@override final  String semver;
@override final  String minClientVersion;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MigrationCopyWith<_Migration> get copyWith => __$MigrationCopyWithImpl<_Migration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MigrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Migration&&(identical(other.semver, semver) || other.semver == semver)&&(identical(other.minClientVersion, minClientVersion) || other.minClientVersion == minClientVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,semver,minClientVersion);

@override
String toString() {
  return 'Migration(semver: $semver, minClientVersion: $minClientVersion)';
}


}

/// @nodoc
abstract mixin class _$MigrationCopyWith<$Res> implements $MigrationCopyWith<$Res> {
  factory _$MigrationCopyWith(_Migration value, $Res Function(_Migration) _then) = __$MigrationCopyWithImpl;
@override @useResult
$Res call({
 String semver, String minClientVersion
});




}
/// @nodoc
class __$MigrationCopyWithImpl<$Res>
    implements _$MigrationCopyWith<$Res> {
  __$MigrationCopyWithImpl(this._self, this._then);

  final _Migration _self;
  final $Res Function(_Migration) _then;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semver = null,Object? minClientVersion = null,}) {
  return _then(_Migration(
semver: null == semver ? _self.semver : semver // ignore: cast_nullable_to_non_nullable
as String,minClientVersion: null == minClientVersion ? _self.minClientVersion : minClientVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
