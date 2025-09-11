// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionPerson {

 int? get id; Competition get competition; Person get person; PersonRole get role;
/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionPersonCopyWith<CompetitionPerson> get copyWith => _$CompetitionPersonCopyWithImpl<CompetitionPerson>(this as CompetitionPerson, _$identity);

  /// Serializes this CompetitionPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.person, person) || other.person == person)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,person,role);

@override
String toString() {
  return 'CompetitionPerson(id: $id, competition: $competition, person: $person, role: $role)';
}


}

/// @nodoc
abstract mixin class $CompetitionPersonCopyWith<$Res>  {
  factory $CompetitionPersonCopyWith(CompetitionPerson value, $Res Function(CompetitionPerson) _then) = _$CompetitionPersonCopyWithImpl;
@useResult
$Res call({
 int? id, Competition competition, Person person, PersonRole role
});


$CompetitionCopyWith<$Res> get competition;$PersonCopyWith<$Res> get person;

}
/// @nodoc
class _$CompetitionPersonCopyWithImpl<$Res>
    implements $CompetitionPersonCopyWith<$Res> {
  _$CompetitionPersonCopyWithImpl(this._self, this._then);

  final CompetitionPerson _self;
  final $Res Function(CompetitionPerson) _then;

/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? competition = null,Object? person = null,Object? role = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as PersonRole,
  ));
}
/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get person {
  
  return $PersonCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompetitionPerson].
extension CompetitionPersonPatterns on CompetitionPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionPerson value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionPerson value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Competition competition,  Person person,  PersonRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionPerson() when $default != null:
return $default(_that.id,_that.competition,_that.person,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Competition competition,  Person person,  PersonRole role)  $default,) {final _that = this;
switch (_that) {
case _CompetitionPerson():
return $default(_that.id,_that.competition,_that.person,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Competition competition,  Person person,  PersonRole role)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionPerson() when $default != null:
return $default(_that.id,_that.competition,_that.person,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionPerson extends CompetitionPerson {
  const _CompetitionPerson({this.id, required this.competition, required this.person, required this.role}): super._();
  factory _CompetitionPerson.fromJson(Map<String, dynamic> json) => _$CompetitionPersonFromJson(json);

@override final  int? id;
@override final  Competition competition;
@override final  Person person;
@override final  PersonRole role;

/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionPersonCopyWith<_CompetitionPerson> get copyWith => __$CompetitionPersonCopyWithImpl<_CompetitionPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionPersonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.person, person) || other.person == person)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,person,role);

@override
String toString() {
  return 'CompetitionPerson(id: $id, competition: $competition, person: $person, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CompetitionPersonCopyWith<$Res> implements $CompetitionPersonCopyWith<$Res> {
  factory _$CompetitionPersonCopyWith(_CompetitionPerson value, $Res Function(_CompetitionPerson) _then) = __$CompetitionPersonCopyWithImpl;
@override @useResult
$Res call({
 int? id, Competition competition, Person person, PersonRole role
});


@override $CompetitionCopyWith<$Res> get competition;@override $PersonCopyWith<$Res> get person;

}
/// @nodoc
class __$CompetitionPersonCopyWithImpl<$Res>
    implements _$CompetitionPersonCopyWith<$Res> {
  __$CompetitionPersonCopyWithImpl(this._self, this._then);

  final _CompetitionPerson _self;
  final $Res Function(_CompetitionPerson) _then;

/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? competition = null,Object? person = null,Object? role = null,}) {
  return _then(_CompetitionPerson(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as PersonRole,
  ));
}

/// Create a copy of CompetitionPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionPerson
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
