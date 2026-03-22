// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_system_phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionSystemPhase {

 int? get id; CompetitionSystemAffiliation get competitionSystemAffiliation; CompetitionSystem get competitionSystem; int get poolGroupCount; bool get isCrossOver;/// The maximum contestants that will be ranked or get into the next round.
/// This must be smaller than or equal to [CompetitionSystemAffiliation.maxContestants].
/// 0: No one will be ranked.
/// 1: 1 contestant will be ranked, but would need to fight against another unranked contestant.
/// 2: 2 contestants will be ranked.
/// 3: ...
/// null: Everyone will be ranked.
 int? get maxRank; int get pos;
/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionSystemPhaseCopyWith<CompetitionSystemPhase> get copyWith => _$CompetitionSystemPhaseCopyWithImpl<CompetitionSystemPhase>(this as CompetitionSystemPhase, _$identity);

  /// Serializes this CompetitionSystemPhase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionSystemPhase&&(identical(other.id, id) || other.id == id)&&(identical(other.competitionSystemAffiliation, competitionSystemAffiliation) || other.competitionSystemAffiliation == competitionSystemAffiliation)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.poolGroupCount, poolGroupCount) || other.poolGroupCount == poolGroupCount)&&(identical(other.isCrossOver, isCrossOver) || other.isCrossOver == isCrossOver)&&(identical(other.maxRank, maxRank) || other.maxRank == maxRank)&&(identical(other.pos, pos) || other.pos == pos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competitionSystemAffiliation,competitionSystem,poolGroupCount,isCrossOver,maxRank,pos);

@override
String toString() {
  return 'CompetitionSystemPhase(id: $id, competitionSystemAffiliation: $competitionSystemAffiliation, competitionSystem: $competitionSystem, poolGroupCount: $poolGroupCount, isCrossOver: $isCrossOver, maxRank: $maxRank, pos: $pos)';
}


}

/// @nodoc
abstract mixin class $CompetitionSystemPhaseCopyWith<$Res>  {
  factory $CompetitionSystemPhaseCopyWith(CompetitionSystemPhase value, $Res Function(CompetitionSystemPhase) _then) = _$CompetitionSystemPhaseCopyWithImpl;
@useResult
$Res call({
 int? id, CompetitionSystemAffiliation competitionSystemAffiliation, CompetitionSystem competitionSystem, int poolGroupCount, bool isCrossOver, int? maxRank, int pos
});


$CompetitionSystemAffiliationCopyWith<$Res> get competitionSystemAffiliation;

}
/// @nodoc
class _$CompetitionSystemPhaseCopyWithImpl<$Res>
    implements $CompetitionSystemPhaseCopyWith<$Res> {
  _$CompetitionSystemPhaseCopyWithImpl(this._self, this._then);

  final CompetitionSystemPhase _self;
  final $Res Function(CompetitionSystemPhase) _then;

/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? competitionSystemAffiliation = null,Object? competitionSystem = null,Object? poolGroupCount = null,Object? isCrossOver = null,Object? maxRank = freezed,Object? pos = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competitionSystemAffiliation: null == competitionSystemAffiliation ? _self.competitionSystemAffiliation : competitionSystemAffiliation // ignore: cast_nullable_to_non_nullable
as CompetitionSystemAffiliation,competitionSystem: null == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem,poolGroupCount: null == poolGroupCount ? _self.poolGroupCount : poolGroupCount // ignore: cast_nullable_to_non_nullable
as int,isCrossOver: null == isCrossOver ? _self.isCrossOver : isCrossOver // ignore: cast_nullable_to_non_nullable
as bool,maxRank: freezed == maxRank ? _self.maxRank : maxRank // ignore: cast_nullable_to_non_nullable
as int?,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionSystemAffiliationCopyWith<$Res> get competitionSystemAffiliation {
  
  return $CompetitionSystemAffiliationCopyWith<$Res>(_self.competitionSystemAffiliation, (value) {
    return _then(_self.copyWith(competitionSystemAffiliation: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompetitionSystemPhase].
extension CompetitionSystemPhasePatterns on CompetitionSystemPhase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionSystemPhase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionSystemPhase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionSystemPhase value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionSystemPhase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionSystemPhase value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionSystemPhase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  CompetitionSystemAffiliation competitionSystemAffiliation,  CompetitionSystem competitionSystem,  int poolGroupCount,  bool isCrossOver,  int? maxRank,  int pos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionSystemPhase() when $default != null:
return $default(_that.id,_that.competitionSystemAffiliation,_that.competitionSystem,_that.poolGroupCount,_that.isCrossOver,_that.maxRank,_that.pos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  CompetitionSystemAffiliation competitionSystemAffiliation,  CompetitionSystem competitionSystem,  int poolGroupCount,  bool isCrossOver,  int? maxRank,  int pos)  $default,) {final _that = this;
switch (_that) {
case _CompetitionSystemPhase():
return $default(_that.id,_that.competitionSystemAffiliation,_that.competitionSystem,_that.poolGroupCount,_that.isCrossOver,_that.maxRank,_that.pos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  CompetitionSystemAffiliation competitionSystemAffiliation,  CompetitionSystem competitionSystem,  int poolGroupCount,  bool isCrossOver,  int? maxRank,  int pos)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionSystemPhase() when $default != null:
return $default(_that.id,_that.competitionSystemAffiliation,_that.competitionSystem,_that.poolGroupCount,_that.isCrossOver,_that.maxRank,_that.pos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionSystemPhase extends CompetitionSystemPhase {
  const _CompetitionSystemPhase({this.id, required this.competitionSystemAffiliation, required this.competitionSystem, this.poolGroupCount = 1, this.isCrossOver = false, this.maxRank, required this.pos}): super._();
  factory _CompetitionSystemPhase.fromJson(Map<String, dynamic> json) => _$CompetitionSystemPhaseFromJson(json);

@override final  int? id;
@override final  CompetitionSystemAffiliation competitionSystemAffiliation;
@override final  CompetitionSystem competitionSystem;
@override@JsonKey() final  int poolGroupCount;
@override@JsonKey() final  bool isCrossOver;
/// The maximum contestants that will be ranked or get into the next round.
/// This must be smaller than or equal to [CompetitionSystemAffiliation.maxContestants].
/// 0: No one will be ranked.
/// 1: 1 contestant will be ranked, but would need to fight against another unranked contestant.
/// 2: 2 contestants will be ranked.
/// 3: ...
/// null: Everyone will be ranked.
@override final  int? maxRank;
@override final  int pos;

/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionSystemPhaseCopyWith<_CompetitionSystemPhase> get copyWith => __$CompetitionSystemPhaseCopyWithImpl<_CompetitionSystemPhase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionSystemPhaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionSystemPhase&&(identical(other.id, id) || other.id == id)&&(identical(other.competitionSystemAffiliation, competitionSystemAffiliation) || other.competitionSystemAffiliation == competitionSystemAffiliation)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.poolGroupCount, poolGroupCount) || other.poolGroupCount == poolGroupCount)&&(identical(other.isCrossOver, isCrossOver) || other.isCrossOver == isCrossOver)&&(identical(other.maxRank, maxRank) || other.maxRank == maxRank)&&(identical(other.pos, pos) || other.pos == pos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competitionSystemAffiliation,competitionSystem,poolGroupCount,isCrossOver,maxRank,pos);

@override
String toString() {
  return 'CompetitionSystemPhase(id: $id, competitionSystemAffiliation: $competitionSystemAffiliation, competitionSystem: $competitionSystem, poolGroupCount: $poolGroupCount, isCrossOver: $isCrossOver, maxRank: $maxRank, pos: $pos)';
}


}

/// @nodoc
abstract mixin class _$CompetitionSystemPhaseCopyWith<$Res> implements $CompetitionSystemPhaseCopyWith<$Res> {
  factory _$CompetitionSystemPhaseCopyWith(_CompetitionSystemPhase value, $Res Function(_CompetitionSystemPhase) _then) = __$CompetitionSystemPhaseCopyWithImpl;
@override @useResult
$Res call({
 int? id, CompetitionSystemAffiliation competitionSystemAffiliation, CompetitionSystem competitionSystem, int poolGroupCount, bool isCrossOver, int? maxRank, int pos
});


@override $CompetitionSystemAffiliationCopyWith<$Res> get competitionSystemAffiliation;

}
/// @nodoc
class __$CompetitionSystemPhaseCopyWithImpl<$Res>
    implements _$CompetitionSystemPhaseCopyWith<$Res> {
  __$CompetitionSystemPhaseCopyWithImpl(this._self, this._then);

  final _CompetitionSystemPhase _self;
  final $Res Function(_CompetitionSystemPhase) _then;

/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? competitionSystemAffiliation = null,Object? competitionSystem = null,Object? poolGroupCount = null,Object? isCrossOver = null,Object? maxRank = freezed,Object? pos = null,}) {
  return _then(_CompetitionSystemPhase(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competitionSystemAffiliation: null == competitionSystemAffiliation ? _self.competitionSystemAffiliation : competitionSystemAffiliation // ignore: cast_nullable_to_non_nullable
as CompetitionSystemAffiliation,competitionSystem: null == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem,poolGroupCount: null == poolGroupCount ? _self.poolGroupCount : poolGroupCount // ignore: cast_nullable_to_non_nullable
as int,isCrossOver: null == isCrossOver ? _self.isCrossOver : isCrossOver // ignore: cast_nullable_to_non_nullable
as bool,maxRank: freezed == maxRank ? _self.maxRank : maxRank // ignore: cast_nullable_to_non_nullable
as int?,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CompetitionSystemPhase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionSystemAffiliationCopyWith<$Res> get competitionSystemAffiliation {
  
  return $CompetitionSystemAffiliationCopyWith<$Res>(_self.competitionSystemAffiliation, (value) {
    return _then(_self.copyWith(competitionSystemAffiliation: value));
  });
}
}

// dart format on
