// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_lineup_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamLineupParticipation {

 int? get id; Membership get membership; TeamLineup get lineup; WeightClass? get weightClass; double? get weight;
/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamLineupParticipationCopyWith<TeamLineupParticipation> get copyWith => _$TeamLineupParticipationCopyWithImpl<TeamLineupParticipation>(this as TeamLineupParticipation, _$identity);

  /// Serializes this TeamLineupParticipation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamLineupParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.lineup, lineup) || other.lineup == lineup)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,lineup,weightClass,weight);

@override
String toString() {
  return 'TeamLineupParticipation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $TeamLineupParticipationCopyWith<$Res>  {
  factory $TeamLineupParticipationCopyWith(TeamLineupParticipation value, $Res Function(TeamLineupParticipation) _then) = _$TeamLineupParticipationCopyWithImpl;
@useResult
$Res call({
 int? id, Membership membership, TeamLineup lineup, WeightClass? weightClass, double? weight
});


$MembershipCopyWith<$Res> get membership;$TeamLineupCopyWith<$Res> get lineup;$WeightClassCopyWith<$Res>? get weightClass;

}
/// @nodoc
class _$TeamLineupParticipationCopyWithImpl<$Res>
    implements $TeamLineupParticipationCopyWith<$Res> {
  _$TeamLineupParticipationCopyWithImpl(this._self, this._then);

  final TeamLineupParticipation _self;
  final $Res Function(TeamLineupParticipation) _then;

/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? membership = null,Object? lineup = null,Object? weightClass = freezed,Object? weight = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as TeamLineup,weightClass: freezed == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamLineupCopyWith<$Res> get lineup {
  
  return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
    return null;
  }

  return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamLineupParticipation].
extension TeamLineupParticipationPatterns on TeamLineupParticipation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamLineupParticipation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamLineupParticipation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamLineupParticipation value)  $default,){
final _that = this;
switch (_that) {
case _TeamLineupParticipation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamLineupParticipation value)?  $default,){
final _that = this;
switch (_that) {
case _TeamLineupParticipation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Membership membership,  TeamLineup lineup,  WeightClass? weightClass,  double? weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamLineupParticipation() when $default != null:
return $default(_that.id,_that.membership,_that.lineup,_that.weightClass,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Membership membership,  TeamLineup lineup,  WeightClass? weightClass,  double? weight)  $default,) {final _that = this;
switch (_that) {
case _TeamLineupParticipation():
return $default(_that.id,_that.membership,_that.lineup,_that.weightClass,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Membership membership,  TeamLineup lineup,  WeightClass? weightClass,  double? weight)?  $default,) {final _that = this;
switch (_that) {
case _TeamLineupParticipation() when $default != null:
return $default(_that.id,_that.membership,_that.lineup,_that.weightClass,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamLineupParticipation extends TeamLineupParticipation {
  const _TeamLineupParticipation({this.id, required this.membership, required this.lineup, this.weightClass, this.weight}): super._();
  factory _TeamLineupParticipation.fromJson(Map<String, dynamic> json) => _$TeamLineupParticipationFromJson(json);

@override final  int? id;
@override final  Membership membership;
@override final  TeamLineup lineup;
@override final  WeightClass? weightClass;
@override final  double? weight;

/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamLineupParticipationCopyWith<_TeamLineupParticipation> get copyWith => __$TeamLineupParticipationCopyWithImpl<_TeamLineupParticipation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamLineupParticipationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamLineupParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.lineup, lineup) || other.lineup == lineup)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,lineup,weightClass,weight);

@override
String toString() {
  return 'TeamLineupParticipation(id: $id, membership: $membership, lineup: $lineup, weightClass: $weightClass, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$TeamLineupParticipationCopyWith<$Res> implements $TeamLineupParticipationCopyWith<$Res> {
  factory _$TeamLineupParticipationCopyWith(_TeamLineupParticipation value, $Res Function(_TeamLineupParticipation) _then) = __$TeamLineupParticipationCopyWithImpl;
@override @useResult
$Res call({
 int? id, Membership membership, TeamLineup lineup, WeightClass? weightClass, double? weight
});


@override $MembershipCopyWith<$Res> get membership;@override $TeamLineupCopyWith<$Res> get lineup;@override $WeightClassCopyWith<$Res>? get weightClass;

}
/// @nodoc
class __$TeamLineupParticipationCopyWithImpl<$Res>
    implements _$TeamLineupParticipationCopyWith<$Res> {
  __$TeamLineupParticipationCopyWithImpl(this._self, this._then);

  final _TeamLineupParticipation _self;
  final $Res Function(_TeamLineupParticipation) _then;

/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? membership = null,Object? lineup = null,Object? weightClass = freezed,Object? weight = freezed,}) {
  return _then(_TeamLineupParticipation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as TeamLineup,weightClass: freezed == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamLineupCopyWith<$Res> get lineup {
  
  return $TeamLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of TeamLineupParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res>? get weightClass {
    if (_self.weightClass == null) {
    return null;
  }

  return $WeightClassCopyWith<$Res>(_self.weightClass!, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}
}

// dart format on
