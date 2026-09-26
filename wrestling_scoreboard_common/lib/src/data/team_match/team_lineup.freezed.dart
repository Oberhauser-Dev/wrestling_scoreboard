// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_lineup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamLineup {

 int? get id; int? get classificationPoints; Team get team;
/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamLineupCopyWith<TeamLineup> get copyWith => _$TeamLineupCopyWithImpl<TeamLineup>(this as TeamLineup, _$identity);

  /// Serializes this TeamLineup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamLineup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLineup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.classificationPoints, _this.classificationPoints) || other.classificationPoints == _this.classificationPoints)&&(identical(other.team, _this.team) || other.team == _this.team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamLineup;
  return Object.hash(runtimeType,_this.id,_this.classificationPoints,_this.team);
}

@override
String toString() {
  final _this = this as TeamLineup;
  return 'TeamLineup(id: ${_this.id}, classificationPoints: ${_this.classificationPoints}, team: ${_this.team})';
}


}

/// @nodoc
abstract mixin class $TeamLineupCopyWith<$Res>  {
  factory $TeamLineupCopyWith(TeamLineup value, $Res Function(TeamLineup) _then) = _$TeamLineupCopyWithImpl;
@useResult
$Res call({
 int? id, int? classificationPoints, Team team
});


$TeamCopyWith<$Res> get team;

}
/// @nodoc
class _$TeamLineupCopyWithImpl<$Res>
    implements $TeamLineupCopyWith<$Res> {
  _$TeamLineupCopyWithImpl(this._self, this._then);

  final TeamLineup _self;
  final $Res Function(TeamLineup) _then;

/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? classificationPoints = freezed,Object? team = null,}) {
  return _then(TeamLineup(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,classificationPoints: freezed == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as Team,
  ));
}
/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res> get team {
  
  return $TeamCopyWith<$Res>(_self.team, (value) {
    return _then(_self.copyWith(team: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamLineup].
extension TeamLineupPatterns on TeamLineup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamLineup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamLineup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamLineup value)  $default,){
final _that = this;
switch (_that) {
case _TeamLineup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamLineup value)?  $default,){
final _that = this;
switch (_that) {
case _TeamLineup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? classificationPoints,  Team team)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamLineup() when $default != null:
return $default(_that.id,_that.classificationPoints,_that.team);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? classificationPoints,  Team team)  $default,) {final _that = this;
switch (_that) {
case _TeamLineup():
return $default(_that.id,_that.classificationPoints,_that.team);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? classificationPoints,  Team team)?  $default,) {final _that = this;
switch (_that) {
case _TeamLineup() when $default != null:
return $default(_that.id,_that.classificationPoints,_that.team);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamLineup extends TeamLineup {
  const _TeamLineup({this.id, this.classificationPoints, required this.team}): super._();
  factory _TeamLineup.fromJson(Map<String, dynamic> json) => _$TeamLineupFromJson(json);

@override final  int? id;
@override final  int? classificationPoints;
@override final  Team team;

/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamLineupCopyWith<_TeamLineup> get copyWith => __$TeamLineupCopyWithImpl<_TeamLineup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamLineupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamLineup&&(identical(other.id, id) || other.id == id)&&(identical(other.classificationPoints, classificationPoints) || other.classificationPoints == classificationPoints)&&(identical(other.team, team) || other.team == team));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,classificationPoints,team);
}

@override
String toString() {
    return 'TeamLineup(id: $id, classificationPoints: $classificationPoints, team: $team)';
}


}

/// @nodoc
abstract mixin class _$TeamLineupCopyWith<$Res> implements $TeamLineupCopyWith<$Res> {
  factory _$TeamLineupCopyWith(_TeamLineup value, $Res Function(_TeamLineup) _then) = __$TeamLineupCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? classificationPoints, Team team
});


@override $TeamCopyWith<$Res> get team;

}
/// @nodoc
class __$TeamLineupCopyWithImpl<$Res>
    implements _$TeamLineupCopyWith<$Res> {
  __$TeamLineupCopyWithImpl(this._self, this._then);

  final _TeamLineup _self;
  final $Res Function(_TeamLineup) _then;

/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? classificationPoints = freezed,Object? team = null,}) {
  return _then(_TeamLineup(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,classificationPoints: freezed == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as Team,
  ));
}

/// Create a copy of TeamLineup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res> get team {
  
  return $TeamCopyWith<$Res>(_self.team, (value) {
    return _then(_self.copyWith(team: value));
  });
}
}

// dart format on
