// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupRule {

 String get name; Duration get period; Duration get deleteAfter;
/// Create a copy of BackupRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupRuleCopyWith<BackupRule> get copyWith => _$BackupRuleCopyWithImpl<BackupRule>(this as BackupRule, _$identity);

  /// Serializes this BackupRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRule&&(identical(other.name, name) || other.name == name)&&(identical(other.period, period) || other.period == period)&&(identical(other.deleteAfter, deleteAfter) || other.deleteAfter == deleteAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,period,deleteAfter);

@override
String toString() {
  return 'BackupRule(name: $name, period: $period, deleteAfter: $deleteAfter)';
}


}

/// @nodoc
abstract mixin class $BackupRuleCopyWith<$Res>  {
  factory $BackupRuleCopyWith(BackupRule value, $Res Function(BackupRule) _then) = _$BackupRuleCopyWithImpl;
@useResult
$Res call({
 String name, Duration period, Duration deleteAfter
});




}
/// @nodoc
class _$BackupRuleCopyWithImpl<$Res>
    implements $BackupRuleCopyWith<$Res> {
  _$BackupRuleCopyWithImpl(this._self, this._then);

  final BackupRule _self;
  final $Res Function(BackupRule) _then;

/// Create a copy of BackupRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? period = null,Object? deleteAfter = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as Duration,deleteAfter: null == deleteAfter ? _self.deleteAfter : deleteAfter // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupRule].
extension BackupRulePatterns on BackupRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupRule value)  $default,){
final _that = this;
switch (_that) {
case _BackupRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupRule value)?  $default,){
final _that = this;
switch (_that) {
case _BackupRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Duration period,  Duration deleteAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupRule() when $default != null:
return $default(_that.name,_that.period,_that.deleteAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Duration period,  Duration deleteAfter)  $default,) {final _that = this;
switch (_that) {
case _BackupRule():
return $default(_that.name,_that.period,_that.deleteAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Duration period,  Duration deleteAfter)?  $default,) {final _that = this;
switch (_that) {
case _BackupRule() when $default != null:
return $default(_that.name,_that.period,_that.deleteAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupRule extends BackupRule {
  const _BackupRule({required this.name, required this.period, required this.deleteAfter}): super._();
  factory _BackupRule.fromJson(Map<String, dynamic> json) => _$BackupRuleFromJson(json);

@override final  String name;
@override final  Duration period;
@override final  Duration deleteAfter;

/// Create a copy of BackupRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupRuleCopyWith<_BackupRule> get copyWith => __$BackupRuleCopyWithImpl<_BackupRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupRule&&(identical(other.name, name) || other.name == name)&&(identical(other.period, period) || other.period == period)&&(identical(other.deleteAfter, deleteAfter) || other.deleteAfter == deleteAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,period,deleteAfter);

@override
String toString() {
  return 'BackupRule(name: $name, period: $period, deleteAfter: $deleteAfter)';
}


}

/// @nodoc
abstract mixin class _$BackupRuleCopyWith<$Res> implements $BackupRuleCopyWith<$Res> {
  factory _$BackupRuleCopyWith(_BackupRule value, $Res Function(_BackupRule) _then) = __$BackupRuleCopyWithImpl;
@override @useResult
$Res call({
 String name, Duration period, Duration deleteAfter
});




}
/// @nodoc
class __$BackupRuleCopyWithImpl<$Res>
    implements _$BackupRuleCopyWith<$Res> {
  __$BackupRuleCopyWithImpl(this._self, this._then);

  final _BackupRule _self;
  final $Res Function(_BackupRule) _then;

/// Create a copy of BackupRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? period = null,Object? deleteAfter = null,}) {
  return _then(_BackupRule(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as Duration,deleteAfter: null == deleteAfter ? _self.deleteAfter : deleteAfter // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
