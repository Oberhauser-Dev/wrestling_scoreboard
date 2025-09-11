// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_match_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMatchPerson {

 int? get id; TeamMatch get teamMatch; Person get person; PersonRole get role;
/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamMatchPersonCopyWith<TeamMatchPerson> get copyWith => _$TeamMatchPersonCopyWithImpl<TeamMatchPerson>(this as TeamMatchPerson, _$identity);

  /// Serializes this TeamMatchPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamMatchPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.teamMatch, teamMatch) || other.teamMatch == teamMatch)&&(identical(other.person, person) || other.person == person)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamMatch,person,role);

@override
String toString() {
  return 'TeamMatchPerson(id: $id, teamMatch: $teamMatch, person: $person, role: $role)';
}


}

/// @nodoc
abstract mixin class $TeamMatchPersonCopyWith<$Res>  {
  factory $TeamMatchPersonCopyWith(TeamMatchPerson value, $Res Function(TeamMatchPerson) _then) = _$TeamMatchPersonCopyWithImpl;
@useResult
$Res call({
 int? id, TeamMatch teamMatch, Person person, PersonRole role
});


$TeamMatchCopyWith<$Res> get teamMatch;$PersonCopyWith<$Res> get person;

}
/// @nodoc
class _$TeamMatchPersonCopyWithImpl<$Res>
    implements $TeamMatchPersonCopyWith<$Res> {
  _$TeamMatchPersonCopyWithImpl(this._self, this._then);

  final TeamMatchPerson _self;
  final $Res Function(TeamMatchPerson) _then;

/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? teamMatch = null,Object? person = null,Object? role = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,teamMatch: null == teamMatch ? _self.teamMatch : teamMatch // ignore: cast_nullable_to_non_nullable
as TeamMatch,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as PersonRole,
  ));
}
/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamMatchCopyWith<$Res> get teamMatch {
  
  return $TeamMatchCopyWith<$Res>(_self.teamMatch, (value) {
    return _then(_self.copyWith(teamMatch: value));
  });
}/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get person {
  
  return $PersonCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamMatchPerson].
extension TeamMatchPersonPatterns on TeamMatchPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamMatchPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamMatchPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamMatchPerson value)  $default,){
final _that = this;
switch (_that) {
case _TeamMatchPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamMatchPerson value)?  $default,){
final _that = this;
switch (_that) {
case _TeamMatchPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  TeamMatch teamMatch,  Person person,  PersonRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamMatchPerson() when $default != null:
return $default(_that.id,_that.teamMatch,_that.person,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  TeamMatch teamMatch,  Person person,  PersonRole role)  $default,) {final _that = this;
switch (_that) {
case _TeamMatchPerson():
return $default(_that.id,_that.teamMatch,_that.person,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  TeamMatch teamMatch,  Person person,  PersonRole role)?  $default,) {final _that = this;
switch (_that) {
case _TeamMatchPerson() when $default != null:
return $default(_that.id,_that.teamMatch,_that.person,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamMatchPerson extends TeamMatchPerson {
  const _TeamMatchPerson({this.id, required this.teamMatch, required this.person, required this.role}): super._();
  factory _TeamMatchPerson.fromJson(Map<String, dynamic> json) => _$TeamMatchPersonFromJson(json);

@override final  int? id;
@override final  TeamMatch teamMatch;
@override final  Person person;
@override final  PersonRole role;

/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamMatchPersonCopyWith<_TeamMatchPerson> get copyWith => __$TeamMatchPersonCopyWithImpl<_TeamMatchPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamMatchPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamMatchPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.teamMatch, teamMatch) || other.teamMatch == teamMatch)&&(identical(other.person, person) || other.person == person)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamMatch,person,role);

@override
String toString() {
  return 'TeamMatchPerson(id: $id, teamMatch: $teamMatch, person: $person, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TeamMatchPersonCopyWith<$Res> implements $TeamMatchPersonCopyWith<$Res> {
  factory _$TeamMatchPersonCopyWith(_TeamMatchPerson value, $Res Function(_TeamMatchPerson) _then) = __$TeamMatchPersonCopyWithImpl;
@override @useResult
$Res call({
 int? id, TeamMatch teamMatch, Person person, PersonRole role
});


@override $TeamMatchCopyWith<$Res> get teamMatch;@override $PersonCopyWith<$Res> get person;

}
/// @nodoc
class __$TeamMatchPersonCopyWithImpl<$Res>
    implements _$TeamMatchPersonCopyWith<$Res> {
  __$TeamMatchPersonCopyWithImpl(this._self, this._then);

  final _TeamMatchPerson _self;
  final $Res Function(_TeamMatchPerson) _then;

/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? teamMatch = null,Object? person = null,Object? role = null,}) {
  return _then(_TeamMatchPerson(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,teamMatch: null == teamMatch ? _self.teamMatch : teamMatch // ignore: cast_nullable_to_non_nullable
as TeamMatch,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as PersonRole,
  ));
}

/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamMatchCopyWith<$Res> get teamMatch {
  
  return $TeamMatchCopyWith<$Res>(_self.teamMatch, (value) {
    return _then(_self.copyWith(teamMatch: value));
  });
}/// Create a copy of TeamMatchPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get person {
  
  return $PersonCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}

// dart format on
