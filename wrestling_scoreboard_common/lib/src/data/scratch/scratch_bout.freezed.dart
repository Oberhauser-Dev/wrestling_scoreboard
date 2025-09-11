// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scratch_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScratchBout {

 int? get id; Bout get bout; WeightClass get weightClass; BoutConfig get boutConfig;
/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScratchBoutCopyWith<ScratchBout> get copyWith => _$ScratchBoutCopyWithImpl<ScratchBout>(this as ScratchBout, _$identity);

  /// Serializes this ScratchBout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScratchBout&&(identical(other.id, id) || other.id == id)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bout,weightClass,boutConfig);

@override
String toString() {
  return 'ScratchBout(id: $id, bout: $bout, weightClass: $weightClass, boutConfig: $boutConfig)';
}


}

/// @nodoc
abstract mixin class $ScratchBoutCopyWith<$Res>  {
  factory $ScratchBoutCopyWith(ScratchBout value, $Res Function(ScratchBout) _then) = _$ScratchBoutCopyWithImpl;
@useResult
$Res call({
 int? id, Bout bout, WeightClass weightClass, BoutConfig boutConfig
});


$BoutCopyWith<$Res> get bout;$WeightClassCopyWith<$Res> get weightClass;$BoutConfigCopyWith<$Res> get boutConfig;

}
/// @nodoc
class _$ScratchBoutCopyWithImpl<$Res>
    implements $ScratchBoutCopyWith<$Res> {
  _$ScratchBoutCopyWithImpl(this._self, this._then);

  final ScratchBout _self;
  final $Res Function(ScratchBout) _then;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bout = null,Object? weightClass = null,Object? boutConfig = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,
  ));
}
/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScratchBout].
extension ScratchBoutPatterns on ScratchBout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScratchBout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScratchBout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScratchBout value)  $default,){
final _that = this;
switch (_that) {
case _ScratchBout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScratchBout value)?  $default,){
final _that = this;
switch (_that) {
case _ScratchBout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Bout bout,  WeightClass weightClass,  BoutConfig boutConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScratchBout() when $default != null:
return $default(_that.id,_that.bout,_that.weightClass,_that.boutConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Bout bout,  WeightClass weightClass,  BoutConfig boutConfig)  $default,) {final _that = this;
switch (_that) {
case _ScratchBout():
return $default(_that.id,_that.bout,_that.weightClass,_that.boutConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Bout bout,  WeightClass weightClass,  BoutConfig boutConfig)?  $default,) {final _that = this;
switch (_that) {
case _ScratchBout() when $default != null:
return $default(_that.id,_that.bout,_that.weightClass,_that.boutConfig);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScratchBout extends ScratchBout {
  const _ScratchBout({this.id, required this.bout, required this.weightClass, required this.boutConfig}): super._();
  factory _ScratchBout.fromJson(Map<String, dynamic> json) => _$ScratchBoutFromJson(json);

@override final  int? id;
@override final  Bout bout;
@override final  WeightClass weightClass;
@override final  BoutConfig boutConfig;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScratchBoutCopyWith<_ScratchBout> get copyWith => __$ScratchBoutCopyWithImpl<_ScratchBout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScratchBoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScratchBout&&(identical(other.id, id) || other.id == id)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bout,weightClass,boutConfig);

@override
String toString() {
  return 'ScratchBout(id: $id, bout: $bout, weightClass: $weightClass, boutConfig: $boutConfig)';
}


}

/// @nodoc
abstract mixin class _$ScratchBoutCopyWith<$Res> implements $ScratchBoutCopyWith<$Res> {
  factory _$ScratchBoutCopyWith(_ScratchBout value, $Res Function(_ScratchBout) _then) = __$ScratchBoutCopyWithImpl;
@override @useResult
$Res call({
 int? id, Bout bout, WeightClass weightClass, BoutConfig boutConfig
});


@override $BoutCopyWith<$Res> get bout;@override $WeightClassCopyWith<$Res> get weightClass;@override $BoutConfigCopyWith<$Res> get boutConfig;

}
/// @nodoc
class __$ScratchBoutCopyWithImpl<$Res>
    implements _$ScratchBoutCopyWith<$Res> {
  __$ScratchBoutCopyWithImpl(this._self, this._then);

  final _ScratchBout _self;
  final $Res Function(_ScratchBout) _then;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bout = null,Object? weightClass = null,Object? boutConfig = null,}) {
  return _then(_ScratchBout(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,
  ));
}

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}
}

// dart format on
