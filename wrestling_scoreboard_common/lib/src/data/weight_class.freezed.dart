// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeightClass {

 int? get id; int get weight; WrestlingStyle get style; String? get suffix; WeightUnit get unit;
/// Create a copy of WeightClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightClassCopyWith<WeightClass> get copyWith => _$WeightClassCopyWithImpl<WeightClass>(this as WeightClass, _$identity);

  /// Serializes this WeightClass to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'WeightClass(id: $id, weight: $weight, style: $style, suffix: $suffix, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $WeightClassCopyWith<$Res>  {
  factory $WeightClassCopyWith(WeightClass value, $Res Function(WeightClass) _then) = _$WeightClassCopyWithImpl;
@useResult
$Res call({
 int? id, int weight, WrestlingStyle style, String? suffix, WeightUnit unit
});




}
/// @nodoc
class _$WeightClassCopyWithImpl<$Res>
    implements $WeightClassCopyWith<$Res> {
  _$WeightClassCopyWithImpl(this._self, this._then);

  final WeightClass _self;
  final $Res Function(WeightClass) _then;

/// Create a copy of WeightClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? weight = null,Object? style = null,Object? suffix = freezed,Object? unit = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as WrestlingStyle,suffix: freezed == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightClass].
extension WeightClassPatterns on WeightClass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightClass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightClass value)  $default,){
final _that = this;
switch (_that) {
case _WeightClass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightClass value)?  $default,){
final _that = this;
switch (_that) {
case _WeightClass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int weight,  WrestlingStyle style,  String? suffix,  WeightUnit unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightClass() when $default != null:
return $default(_that.id,_that.weight,_that.style,_that.suffix,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int weight,  WrestlingStyle style,  String? suffix,  WeightUnit unit)  $default,) {final _that = this;
switch (_that) {
case _WeightClass():
return $default(_that.id,_that.weight,_that.style,_that.suffix,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int weight,  WrestlingStyle style,  String? suffix,  WeightUnit unit)?  $default,) {final _that = this;
switch (_that) {
case _WeightClass() when $default != null:
return $default(_that.id,_that.weight,_that.style,_that.suffix,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightClass extends WeightClass {
  const _WeightClass({this.id, required this.weight, required this.style, this.suffix, this.unit = WeightUnit.kilogram}): super._();
  factory _WeightClass.fromJson(Map<String, dynamic> json) => _$WeightClassFromJson(json);

@override final  int? id;
@override final  int weight;
@override final  WrestlingStyle style;
@override final  String? suffix;
@override@JsonKey() final  WeightUnit unit;

/// Create a copy of WeightClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightClassCopyWith<_WeightClass> get copyWith => __$WeightClassCopyWithImpl<_WeightClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightClassToJson(this, );
}



@override
String toString() {
  return 'WeightClass(id: $id, weight: $weight, style: $style, suffix: $suffix, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$WeightClassCopyWith<$Res> implements $WeightClassCopyWith<$Res> {
  factory _$WeightClassCopyWith(_WeightClass value, $Res Function(_WeightClass) _then) = __$WeightClassCopyWithImpl;
@override @useResult
$Res call({
 int? id, int weight, WrestlingStyle style, String? suffix, WeightUnit unit
});




}
/// @nodoc
class __$WeightClassCopyWithImpl<$Res>
    implements _$WeightClassCopyWith<$Res> {
  __$WeightClassCopyWithImpl(this._self, this._then);

  final _WeightClass _self;
  final $Res Function(_WeightClass) _then;

/// Create a copy of WeightClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? weight = null,Object? style = null,Object? suffix = freezed,Object? unit = null,}) {
  return _then(_WeightClass(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as WrestlingStyle,suffix: freezed == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

// dart format on
