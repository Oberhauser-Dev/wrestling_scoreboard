// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_lineup_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamLineupMembership {

 int? get id; TeamLineup get lineup; Membership get membership; LineupRole get role;
/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamLineupMembershipCopyWith<TeamLineupMembership> get copyWith => _$TeamLineupMembershipCopyWithImpl<TeamLineupMembership>(this as TeamLineupMembership, _$identity);

  /// Serializes this TeamLineupMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamLineupMembership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLineupMembership&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.lineup, _this.lineup) || other.lineup == _this.lineup)&&(identical(other.membership, _this.membership) || other.membership == _this.membership)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamLineupMembership;
  return Object.hash(runtimeType,_this.id,_this.lineup,_this.membership,_this.role);
}

@override
String toString() {
  final _this = this as TeamLineupMembership;
  return 'TeamLineupMembership(id: ${_this.id}, lineup: ${_this.lineup}, membership: ${_this.membership}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TeamLineupMembershipCopyWith<$Res>  {
  factory $TeamLineupMembershipCopyWith(TeamLineupMembership value, $Res Function(TeamLineupMembership) _then) = _$TeamLineupMembershipCopyWithImpl;
@useResult
$Res call({
 int? id, TeamLineup lineup, Membership membership, LineupRole role
});


$TeamLineupCopyWith<$Res> get lineup;$MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$TeamLineupMembershipCopyWithImpl<$Res>
    implements $TeamLineupMembershipCopyWith<$Res> {
  _$TeamLineupMembershipCopyWithImpl(this._self, this._then);

  final TeamLineupMembership _self;
  final $Res Function(TeamLineupMembership) _then;

/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? lineup = null,Object? membership = null,Object? role = null,}) {
  return _then(TeamLineupMembership(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as TeamLineup,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as LineupRole,
  ));
}
/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamLineupCopyWith<$Res> get lineup {
  
  return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamLineupMembership].
extension TeamLineupMembershipPatterns on TeamLineupMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamLineupMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamLineupMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamLineupMembership value)  $default,){
final _that = this;
switch (_that) {
case _TeamLineupMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamLineupMembership value)?  $default,){
final _that = this;
switch (_that) {
case _TeamLineupMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  TeamLineup lineup,  Membership membership,  LineupRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamLineupMembership() when $default != null:
return $default(_that.id,_that.lineup,_that.membership,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  TeamLineup lineup,  Membership membership,  LineupRole role)  $default,) {final _that = this;
switch (_that) {
case _TeamLineupMembership():
return $default(_that.id,_that.lineup,_that.membership,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  TeamLineup lineup,  Membership membership,  LineupRole role)?  $default,) {final _that = this;
switch (_that) {
case _TeamLineupMembership() when $default != null:
return $default(_that.id,_that.lineup,_that.membership,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamLineupMembership extends TeamLineupMembership {
  const _TeamLineupMembership({this.id, required this.lineup, required this.membership, required this.role}): super._();
  factory _TeamLineupMembership.fromJson(Map<String, dynamic> json) => _$TeamLineupMembershipFromJson(json);

@override final  int? id;
@override final  TeamLineup lineup;
@override final  Membership membership;
@override final  LineupRole role;

/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamLineupMembershipCopyWith<_TeamLineupMembership> get copyWith => __$TeamLineupMembershipCopyWithImpl<_TeamLineupMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamLineupMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamLineupMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.lineup, lineup) || other.lineup == lineup)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,lineup,membership,role);
}

@override
String toString() {
    return 'TeamLineupMembership(id: $id, lineup: $lineup, membership: $membership, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TeamLineupMembershipCopyWith<$Res> implements $TeamLineupMembershipCopyWith<$Res> {
  factory _$TeamLineupMembershipCopyWith(_TeamLineupMembership value, $Res Function(_TeamLineupMembership) _then) = __$TeamLineupMembershipCopyWithImpl;
@override @useResult
$Res call({
 int? id, TeamLineup lineup, Membership membership, LineupRole role
});


@override $TeamLineupCopyWith<$Res> get lineup;@override $MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class __$TeamLineupMembershipCopyWithImpl<$Res>
    implements _$TeamLineupMembershipCopyWith<$Res> {
  __$TeamLineupMembershipCopyWithImpl(this._self, this._then);

  final _TeamLineupMembership _self;
  final $Res Function(_TeamLineupMembership) _then;

/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? lineup = null,Object? membership = null,Object? role = null,}) {
  return _then(_TeamLineupMembership(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as TeamLineup,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as LineupRole,
  ));
}

/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamLineupCopyWith<$Res> get lineup {
  
  return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of TeamLineupMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

// dart format on
