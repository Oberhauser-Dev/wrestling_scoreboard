// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoutAction {

 int? get id; BoutActionType get actionType; Bout get bout; Duration get duration; BoutRole get role; int? get pointCount;
/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoutActionCopyWith<BoutAction> get copyWith => _$BoutActionCopyWithImpl<BoutAction>(this as BoutAction, _$identity);

  /// Serializes this BoutAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoutAction&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.role, role) || other.role == role)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionType,bout,duration,role,pointCount);

@override
String toString() {
  return 'BoutAction(id: $id, actionType: $actionType, bout: $bout, duration: $duration, role: $role, pointCount: $pointCount)';
}


}

/// @nodoc
abstract mixin class $BoutActionCopyWith<$Res>  {
  factory $BoutActionCopyWith(BoutAction value, $Res Function(BoutAction) _then) = _$BoutActionCopyWithImpl;
@useResult
$Res call({
 int? id, BoutActionType actionType, Bout bout, Duration duration, BoutRole role, int? pointCount
});


$BoutCopyWith<$Res> get bout;

}
/// @nodoc
class _$BoutActionCopyWithImpl<$Res>
    implements $BoutActionCopyWith<$Res> {
  _$BoutActionCopyWithImpl(this._self, this._then);

  final BoutAction _self;
  final $Res Function(BoutAction) _then;

/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? actionType = null,Object? bout = null,Object? duration = null,Object? role = null,Object? pointCount = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BoutActionType,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as BoutRole,pointCount: freezed == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoutAction].
extension BoutActionPatterns on BoutAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoutAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoutAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoutAction value)  $default,){
final _that = this;
switch (_that) {
case _BoutAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoutAction value)?  $default,){
final _that = this;
switch (_that) {
case _BoutAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  BoutActionType actionType,  Bout bout,  Duration duration,  BoutRole role,  int? pointCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoutAction() when $default != null:
return $default(_that.id,_that.actionType,_that.bout,_that.duration,_that.role,_that.pointCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  BoutActionType actionType,  Bout bout,  Duration duration,  BoutRole role,  int? pointCount)  $default,) {final _that = this;
switch (_that) {
case _BoutAction():
return $default(_that.id,_that.actionType,_that.bout,_that.duration,_that.role,_that.pointCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  BoutActionType actionType,  Bout bout,  Duration duration,  BoutRole role,  int? pointCount)?  $default,) {final _that = this;
switch (_that) {
case _BoutAction() when $default != null:
return $default(_that.id,_that.actionType,_that.bout,_that.duration,_that.role,_that.pointCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoutAction extends BoutAction {
  const _BoutAction({this.id, required this.actionType, required this.bout, required this.duration, required this.role, this.pointCount}): super._();
  factory _BoutAction.fromJson(Map<String, dynamic> json) => _$BoutActionFromJson(json);

@override final  int? id;
@override final  BoutActionType actionType;
@override final  Bout bout;
@override final  Duration duration;
@override final  BoutRole role;
@override final  int? pointCount;

/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoutActionCopyWith<_BoutAction> get copyWith => __$BoutActionCopyWithImpl<_BoutAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoutActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoutAction&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.role, role) || other.role == role)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionType,bout,duration,role,pointCount);

@override
String toString() {
  return 'BoutAction(id: $id, actionType: $actionType, bout: $bout, duration: $duration, role: $role, pointCount: $pointCount)';
}


}

/// @nodoc
abstract mixin class _$BoutActionCopyWith<$Res> implements $BoutActionCopyWith<$Res> {
  factory _$BoutActionCopyWith(_BoutAction value, $Res Function(_BoutAction) _then) = __$BoutActionCopyWithImpl;
@override @useResult
$Res call({
 int? id, BoutActionType actionType, Bout bout, Duration duration, BoutRole role, int? pointCount
});


@override $BoutCopyWith<$Res> get bout;

}
/// @nodoc
class __$BoutActionCopyWithImpl<$Res>
    implements _$BoutActionCopyWith<$Res> {
  __$BoutActionCopyWithImpl(this._self, this._then);

  final _BoutAction _self;
  final $Res Function(_BoutAction) _then;

/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? actionType = null,Object? bout = null,Object? duration = null,Object? role = null,Object? pointCount = freezed,}) {
  return _then(_BoutAction(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BoutActionType,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as BoutRole,pointCount: freezed == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BoutAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}
}

// dart format on
