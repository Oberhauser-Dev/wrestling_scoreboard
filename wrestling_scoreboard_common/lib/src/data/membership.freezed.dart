// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Membership {

 int? get id; String? get orgSyncId; Organization? get organization; String? get no;// Mitgliedsnummer
 Club get club; Person get person;
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCopyWith<Membership> get copyWith => _$MembershipCopyWithImpl<Membership>(this as Membership, _$identity);

  /// Serializes this Membership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Membership&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.no, no) || other.no == no)&&(identical(other.club, club) || other.club == club)&&(identical(other.person, person) || other.person == person));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,no,club,person);

@override
String toString() {
  return 'Membership(id: $id, orgSyncId: $orgSyncId, organization: $organization, no: $no, club: $club, person: $person)';
}


}

/// @nodoc
abstract mixin class $MembershipCopyWith<$Res>  {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) _then) = _$MembershipCopyWithImpl;
@useResult
$Res call({
 int? id, String? orgSyncId, Organization? organization, String? no, Club club, Person person
});


$OrganizationCopyWith<$Res>? get organization;$ClubCopyWith<$Res> get club;$PersonCopyWith<$Res> get person;

}
/// @nodoc
class _$MembershipCopyWithImpl<$Res>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._self, this._then);

  final Membership _self;
  final $Res Function(Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = freezed,Object? no = freezed,Object? club = null,Object? person = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization?,no: freezed == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as String?,club: null == club ? _self.club : club // ignore: cast_nullable_to_non_nullable
as Club,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,
  ));
}
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClubCopyWith<$Res> get club {
  
  return $ClubCopyWith<$Res>(_self.club, (value) {
    return _then(_self.copyWith(club: value));
  });
}/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get person {
  
  return $PersonCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [Membership].
extension MembershipPatterns on Membership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Membership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Membership value)  $default,){
final _that = this;
switch (_that) {
case _Membership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Membership value)?  $default,){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? orgSyncId,  Organization? organization,  String? no,  Club club,  Person person)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.orgSyncId,_that.organization,_that.no,_that.club,_that.person);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? orgSyncId,  Organization? organization,  String? no,  Club club,  Person person)  $default,) {final _that = this;
switch (_that) {
case _Membership():
return $default(_that.id,_that.orgSyncId,_that.organization,_that.no,_that.club,_that.person);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? orgSyncId,  Organization? organization,  String? no,  Club club,  Person person)?  $default,) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.orgSyncId,_that.organization,_that.no,_that.club,_that.person);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Membership extends Membership {
  const _Membership({this.id, this.orgSyncId, this.organization, this.no, required this.club, required this.person}): super._();
  factory _Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

@override final  int? id;
@override final  String? orgSyncId;
@override final  Organization? organization;
@override final  String? no;
// Mitgliedsnummer
@override final  Club club;
@override final  Person person;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCopyWith<_Membership> get copyWith => __$MembershipCopyWithImpl<_Membership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Membership&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.no, no) || other.no == no)&&(identical(other.club, club) || other.club == club)&&(identical(other.person, person) || other.person == person));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,no,club,person);

@override
String toString() {
  return 'Membership(id: $id, orgSyncId: $orgSyncId, organization: $organization, no: $no, club: $club, person: $person)';
}


}

/// @nodoc
abstract mixin class _$MembershipCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$MembershipCopyWith(_Membership value, $Res Function(_Membership) _then) = __$MembershipCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? orgSyncId, Organization? organization, String? no, Club club, Person person
});


@override $OrganizationCopyWith<$Res>? get organization;@override $ClubCopyWith<$Res> get club;@override $PersonCopyWith<$Res> get person;

}
/// @nodoc
class __$MembershipCopyWithImpl<$Res>
    implements _$MembershipCopyWith<$Res> {
  __$MembershipCopyWithImpl(this._self, this._then);

  final _Membership _self;
  final $Res Function(_Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = freezed,Object? no = freezed,Object? club = null,Object? person = null,}) {
  return _then(_Membership(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization?,no: freezed == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as String?,club: null == club ? _self.club : club // ignore: cast_nullable_to_non_nullable
as Club,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person,
  ));
}

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClubCopyWith<$Res> get club {
  
  return $ClubCopyWith<$Res>(_self.club, (value) {
    return _then(_self.copyWith(club: value));
  });
}/// Create a copy of Membership
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
