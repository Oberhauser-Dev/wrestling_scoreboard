// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_weight_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionWeightCategory {

 int? get id; WeightClass get weightClass; CompetitionAgeCategory get competitionAgeCategory; Competition get competition; CompetitionSystem? get competitionSystem; int get poolGroupCount; int? get pairedRound; int get pos; List<int> get skippedCycles;
/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionWeightCategoryCopyWith<CompetitionWeightCategory> get copyWith => _$CompetitionWeightCategoryCopyWithImpl<CompetitionWeightCategory>(this as CompetitionWeightCategory, _$identity);

  /// Serializes this CompetitionWeightCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionWeightCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.competitionAgeCategory, competitionAgeCategory) || other.competitionAgeCategory == competitionAgeCategory)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.poolGroupCount, poolGroupCount) || other.poolGroupCount == poolGroupCount)&&(identical(other.pairedRound, pairedRound) || other.pairedRound == pairedRound)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other.skippedCycles, skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weightClass,competitionAgeCategory,competition,competitionSystem,poolGroupCount,pairedRound,pos,const DeepCollectionEquality().hash(skippedCycles));

@override
String toString() {
  return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, competitionAgeCategory: $competitionAgeCategory, competition: $competition, competitionSystem: $competitionSystem, poolGroupCount: $poolGroupCount, pairedRound: $pairedRound, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class $CompetitionWeightCategoryCopyWith<$Res>  {
  factory $CompetitionWeightCategoryCopyWith(CompetitionWeightCategory value, $Res Function(CompetitionWeightCategory) _then) = _$CompetitionWeightCategoryCopyWithImpl;
@useResult
$Res call({
 int? id, WeightClass weightClass, CompetitionAgeCategory competitionAgeCategory, Competition competition, CompetitionSystem? competitionSystem, int poolGroupCount, int? pairedRound, int pos, List<int> skippedCycles
});


$WeightClassCopyWith<$Res> get weightClass;$CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory;$CompetitionCopyWith<$Res> get competition;

}
/// @nodoc
class _$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements $CompetitionWeightCategoryCopyWith<$Res> {
  _$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final CompetitionWeightCategory _self;
  final $Res Function(CompetitionWeightCategory) _then;

/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? weightClass = null,Object? competitionAgeCategory = null,Object? competition = null,Object? competitionSystem = freezed,Object? poolGroupCount = null,Object? pairedRound = freezed,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,competitionAgeCategory: null == competitionAgeCategory ? _self.competitionAgeCategory : competitionAgeCategory // ignore: cast_nullable_to_non_nullable
as CompetitionAgeCategory,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystem: freezed == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem?,poolGroupCount: null == poolGroupCount ? _self.poolGroupCount : poolGroupCount // ignore: cast_nullable_to_non_nullable
as int,pairedRound: freezed == pairedRound ? _self.pairedRound : pairedRound // ignore: cast_nullable_to_non_nullable
as int?,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,skippedCycles: null == skippedCycles ? _self.skippedCycles : skippedCycles // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory {
  
  return $CompetitionAgeCategoryCopyWith<$Res>(_self.competitionAgeCategory, (value) {
    return _then(_self.copyWith(competitionAgeCategory: value));
  });
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompetitionWeightCategory].
extension CompetitionWeightCategoryPatterns on CompetitionWeightCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionWeightCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionWeightCategory value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionWeightCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionWeightCategory value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystem? competitionSystem,  int poolGroupCount,  int? pairedRound,  int pos,  List<int> skippedCycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystem,_that.poolGroupCount,_that.pairedRound,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystem? competitionSystem,  int poolGroupCount,  int? pairedRound,  int pos,  List<int> skippedCycles)  $default,) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory():
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystem,_that.poolGroupCount,_that.pairedRound,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystem? competitionSystem,  int poolGroupCount,  int? pairedRound,  int pos,  List<int> skippedCycles)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystem,_that.poolGroupCount,_that.pairedRound,_that.pos,_that.skippedCycles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionWeightCategory extends CompetitionWeightCategory {
  const _CompetitionWeightCategory({this.id, required this.weightClass, required this.competitionAgeCategory, required this.competition, this.competitionSystem, this.poolGroupCount = 1, this.pairedRound, this.pos = 0, final  List<int> skippedCycles = const []}): _skippedCycles = skippedCycles,super._();
  factory _CompetitionWeightCategory.fromJson(Map<String, dynamic> json) => _$CompetitionWeightCategoryFromJson(json);

@override final  int? id;
@override final  WeightClass weightClass;
@override final  CompetitionAgeCategory competitionAgeCategory;
@override final  Competition competition;
@override final  CompetitionSystem? competitionSystem;
@override@JsonKey() final  int poolGroupCount;
@override final  int? pairedRound;
@override@JsonKey() final  int pos;
 final  List<int> _skippedCycles;
@override@JsonKey() List<int> get skippedCycles {
  if (_skippedCycles is EqualUnmodifiableListView) return _skippedCycles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skippedCycles);
}


/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionWeightCategoryCopyWith<_CompetitionWeightCategory> get copyWith => __$CompetitionWeightCategoryCopyWithImpl<_CompetitionWeightCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionWeightCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionWeightCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.competitionAgeCategory, competitionAgeCategory) || other.competitionAgeCategory == competitionAgeCategory)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.poolGroupCount, poolGroupCount) || other.poolGroupCount == poolGroupCount)&&(identical(other.pairedRound, pairedRound) || other.pairedRound == pairedRound)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other._skippedCycles, _skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weightClass,competitionAgeCategory,competition,competitionSystem,poolGroupCount,pairedRound,pos,const DeepCollectionEquality().hash(_skippedCycles));

@override
String toString() {
  return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, competitionAgeCategory: $competitionAgeCategory, competition: $competition, competitionSystem: $competitionSystem, poolGroupCount: $poolGroupCount, pairedRound: $pairedRound, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class _$CompetitionWeightCategoryCopyWith<$Res> implements $CompetitionWeightCategoryCopyWith<$Res> {
  factory _$CompetitionWeightCategoryCopyWith(_CompetitionWeightCategory value, $Res Function(_CompetitionWeightCategory) _then) = __$CompetitionWeightCategoryCopyWithImpl;
@override @useResult
$Res call({
 int? id, WeightClass weightClass, CompetitionAgeCategory competitionAgeCategory, Competition competition, CompetitionSystem? competitionSystem, int poolGroupCount, int? pairedRound, int pos, List<int> skippedCycles
});


@override $WeightClassCopyWith<$Res> get weightClass;@override $CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory;@override $CompetitionCopyWith<$Res> get competition;

}
/// @nodoc
class __$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements _$CompetitionWeightCategoryCopyWith<$Res> {
  __$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final _CompetitionWeightCategory _self;
  final $Res Function(_CompetitionWeightCategory) _then;

/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? weightClass = null,Object? competitionAgeCategory = null,Object? competition = null,Object? competitionSystem = freezed,Object? poolGroupCount = null,Object? pairedRound = freezed,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_CompetitionWeightCategory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,competitionAgeCategory: null == competitionAgeCategory ? _self.competitionAgeCategory : competitionAgeCategory // ignore: cast_nullable_to_non_nullable
as CompetitionAgeCategory,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystem: freezed == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem?,poolGroupCount: null == poolGroupCount ? _self.poolGroupCount : poolGroupCount // ignore: cast_nullable_to_non_nullable
as int,pairedRound: freezed == pairedRound ? _self.pairedRound : pairedRound // ignore: cast_nullable_to_non_nullable
as int?,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,skippedCycles: null == skippedCycles ? _self._skippedCycles : skippedCycles // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory {
  
  return $CompetitionAgeCategoryCopyWith<$Res>(_self.competitionAgeCategory, (value) {
    return _then(_self.copyWith(competitionAgeCategory: value));
  });
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}
}

// dart format on
