// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionParticipation {

 int? get id; Membership get membership; CompetitionLineup get lineup; CompetitionWeightCategory? get weightCategory; double? get weight; List<int> get poolGroups; List<int> get poolDrawNumbers; ContestantStatus? get contestantStatus;
/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionParticipationCopyWith<CompetitionParticipation> get copyWith => _$CompetitionParticipationCopyWithImpl<CompetitionParticipation>(this as CompetitionParticipation, _$identity);

  /// Serializes this CompetitionParticipation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.lineup, lineup) || other.lineup == lineup)&&(identical(other.weightCategory, weightCategory) || other.weightCategory == weightCategory)&&(identical(other.weight, weight) || other.weight == weight)&&const DeepCollectionEquality().equals(other.poolGroups, poolGroups)&&const DeepCollectionEquality().equals(other.poolDrawNumbers, poolDrawNumbers)&&(identical(other.contestantStatus, contestantStatus) || other.contestantStatus == contestantStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,lineup,weightCategory,weight,const DeepCollectionEquality().hash(poolGroups),const DeepCollectionEquality().hash(poolDrawNumbers),contestantStatus);

@override
String toString() {
  return 'CompetitionParticipation(id: $id, membership: $membership, lineup: $lineup, weightCategory: $weightCategory, weight: $weight, poolGroups: $poolGroups, poolDrawNumbers: $poolDrawNumbers, contestantStatus: $contestantStatus)';
}


}

/// @nodoc
abstract mixin class $CompetitionParticipationCopyWith<$Res>  {
  factory $CompetitionParticipationCopyWith(CompetitionParticipation value, $Res Function(CompetitionParticipation) _then) = _$CompetitionParticipationCopyWithImpl;
@useResult
$Res call({
 int? id, Membership membership, CompetitionLineup lineup, CompetitionWeightCategory? weightCategory, double? weight, List<int> poolGroups, List<int> poolDrawNumbers, ContestantStatus? contestantStatus
});


$MembershipCopyWith<$Res> get membership;$CompetitionLineupCopyWith<$Res> get lineup;$CompetitionWeightCategoryCopyWith<$Res>? get weightCategory;

}
/// @nodoc
class _$CompetitionParticipationCopyWithImpl<$Res>
    implements $CompetitionParticipationCopyWith<$Res> {
  _$CompetitionParticipationCopyWithImpl(this._self, this._then);

  final CompetitionParticipation _self;
  final $Res Function(CompetitionParticipation) _then;

/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? membership = null,Object? lineup = null,Object? weightCategory = freezed,Object? weight = freezed,Object? poolGroups = null,Object? poolDrawNumbers = null,Object? contestantStatus = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as CompetitionLineup,weightCategory: freezed == weightCategory ? _self.weightCategory : weightCategory // ignore: cast_nullable_to_non_nullable
as CompetitionWeightCategory?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,poolGroups: null == poolGroups ? _self.poolGroups : poolGroups // ignore: cast_nullable_to_non_nullable
as List<int>,poolDrawNumbers: null == poolDrawNumbers ? _self.poolDrawNumbers : poolDrawNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,contestantStatus: freezed == contestantStatus ? _self.contestantStatus : contestantStatus // ignore: cast_nullable_to_non_nullable
as ContestantStatus?,
  ));
}
/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionLineupCopyWith<$Res> get lineup {
  
  return $CompetitionLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionWeightCategoryCopyWith<$Res>? get weightCategory {
    if (_self.weightCategory == null) {
    return null;
  }

  return $CompetitionWeightCategoryCopyWith<$Res>(_self.weightCategory!, (value) {
    return _then(_self.copyWith(weightCategory: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompetitionParticipation].
extension CompetitionParticipationPatterns on CompetitionParticipation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionParticipation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionParticipation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionParticipation value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionParticipation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionParticipation value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionParticipation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Membership membership,  CompetitionLineup lineup,  CompetitionWeightCategory? weightCategory,  double? weight,  List<int> poolGroups,  List<int> poolDrawNumbers,  ContestantStatus? contestantStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionParticipation() when $default != null:
return $default(_that.id,_that.membership,_that.lineup,_that.weightCategory,_that.weight,_that.poolGroups,_that.poolDrawNumbers,_that.contestantStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Membership membership,  CompetitionLineup lineup,  CompetitionWeightCategory? weightCategory,  double? weight,  List<int> poolGroups,  List<int> poolDrawNumbers,  ContestantStatus? contestantStatus)  $default,) {final _that = this;
switch (_that) {
case _CompetitionParticipation():
return $default(_that.id,_that.membership,_that.lineup,_that.weightCategory,_that.weight,_that.poolGroups,_that.poolDrawNumbers,_that.contestantStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Membership membership,  CompetitionLineup lineup,  CompetitionWeightCategory? weightCategory,  double? weight,  List<int> poolGroups,  List<int> poolDrawNumbers,  ContestantStatus? contestantStatus)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionParticipation() when $default != null:
return $default(_that.id,_that.membership,_that.lineup,_that.weightCategory,_that.weight,_that.poolGroups,_that.poolDrawNumbers,_that.contestantStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionParticipation extends CompetitionParticipation {
  const _CompetitionParticipation({this.id, required this.membership, required this.lineup, this.weightCategory, this.weight, final  List<int> poolGroups = const [], final  List<int> poolDrawNumbers = const [], this.contestantStatus}): _poolGroups = poolGroups,_poolDrawNumbers = poolDrawNumbers,super._();
  factory _CompetitionParticipation.fromJson(Map<String, dynamic> json) => _$CompetitionParticipationFromJson(json);

@override final  int? id;
@override final  Membership membership;
@override final  CompetitionLineup lineup;
@override final  CompetitionWeightCategory? weightCategory;
@override final  double? weight;
 final  List<int> _poolGroups;
@override@JsonKey() List<int> get poolGroups {
  if (_poolGroups is EqualUnmodifiableListView) return _poolGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_poolGroups);
}

 final  List<int> _poolDrawNumbers;
@override@JsonKey() List<int> get poolDrawNumbers {
  if (_poolDrawNumbers is EqualUnmodifiableListView) return _poolDrawNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_poolDrawNumbers);
}

@override final  ContestantStatus? contestantStatus;

/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionParticipationCopyWith<_CompetitionParticipation> get copyWith => __$CompetitionParticipationCopyWithImpl<_CompetitionParticipation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionParticipationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionParticipation&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.lineup, lineup) || other.lineup == lineup)&&(identical(other.weightCategory, weightCategory) || other.weightCategory == weightCategory)&&(identical(other.weight, weight) || other.weight == weight)&&const DeepCollectionEquality().equals(other._poolGroups, _poolGroups)&&const DeepCollectionEquality().equals(other._poolDrawNumbers, _poolDrawNumbers)&&(identical(other.contestantStatus, contestantStatus) || other.contestantStatus == contestantStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,lineup,weightCategory,weight,const DeepCollectionEquality().hash(_poolGroups),const DeepCollectionEquality().hash(_poolDrawNumbers),contestantStatus);

@override
String toString() {
  return 'CompetitionParticipation(id: $id, membership: $membership, lineup: $lineup, weightCategory: $weightCategory, weight: $weight, poolGroups: $poolGroups, poolDrawNumbers: $poolDrawNumbers, contestantStatus: $contestantStatus)';
}


}

/// @nodoc
abstract mixin class _$CompetitionParticipationCopyWith<$Res> implements $CompetitionParticipationCopyWith<$Res> {
  factory _$CompetitionParticipationCopyWith(_CompetitionParticipation value, $Res Function(_CompetitionParticipation) _then) = __$CompetitionParticipationCopyWithImpl;
@override @useResult
$Res call({
 int? id, Membership membership, CompetitionLineup lineup, CompetitionWeightCategory? weightCategory, double? weight, List<int> poolGroups, List<int> poolDrawNumbers, ContestantStatus? contestantStatus
});


@override $MembershipCopyWith<$Res> get membership;@override $CompetitionLineupCopyWith<$Res> get lineup;@override $CompetitionWeightCategoryCopyWith<$Res>? get weightCategory;

}
/// @nodoc
class __$CompetitionParticipationCopyWithImpl<$Res>
    implements _$CompetitionParticipationCopyWith<$Res> {
  __$CompetitionParticipationCopyWithImpl(this._self, this._then);

  final _CompetitionParticipation _self;
  final $Res Function(_CompetitionParticipation) _then;

/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? membership = null,Object? lineup = null,Object? weightCategory = freezed,Object? weight = freezed,Object? poolGroups = null,Object? poolDrawNumbers = null,Object? contestantStatus = freezed,}) {
  return _then(_CompetitionParticipation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as CompetitionLineup,weightCategory: freezed == weightCategory ? _self.weightCategory : weightCategory // ignore: cast_nullable_to_non_nullable
as CompetitionWeightCategory?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,poolGroups: null == poolGroups ? _self._poolGroups : poolGroups // ignore: cast_nullable_to_non_nullable
as List<int>,poolDrawNumbers: null == poolDrawNumbers ? _self._poolDrawNumbers : poolDrawNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,contestantStatus: freezed == contestantStatus ? _self.contestantStatus : contestantStatus // ignore: cast_nullable_to_non_nullable
as ContestantStatus?,
  ));
}

/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionLineupCopyWith<$Res> get lineup {
  
  return $CompetitionLineupCopyWith<$Res>(_self.lineup, (value) {
    return _then(_self.copyWith(lineup: value));
  });
}/// Create a copy of CompetitionParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionWeightCategoryCopyWith<$Res>? get weightCategory {
    if (_self.weightCategory == null) {
    return null;
  }

  return $CompetitionWeightCategoryCopyWith<$Res>(_self.weightCategory!, (value) {
    return _then(_self.copyWith(weightCategory: value));
  });
}
}

// dart format on
