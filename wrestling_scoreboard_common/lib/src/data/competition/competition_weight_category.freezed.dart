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

 int? get id; WeightClass get weightClass; CompetitionAgeCategory get competitionAgeCategory; Competition get competition; CompetitionSystemAffiliation? get competitionSystemAffiliation;/// Round by which is currently paired
/// - []: No round was and no phase was paired.
/// - [0]: One (first) round in the first phase was paired.
/// - [3, 1]: 4th round in the first phase, and second round in the second phase was paired.
 List<int> get pairedRoundByPhase; int get pos; List<int> get skippedCycles;
/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionWeightCategoryCopyWith<CompetitionWeightCategory> get copyWith => _$CompetitionWeightCategoryCopyWithImpl<CompetitionWeightCategory>(this as CompetitionWeightCategory, _$identity);

  /// Serializes this CompetitionWeightCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionWeightCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.competitionAgeCategory, competitionAgeCategory) || other.competitionAgeCategory == competitionAgeCategory)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystemAffiliation, competitionSystemAffiliation) || other.competitionSystemAffiliation == competitionSystemAffiliation)&&const DeepCollectionEquality().equals(other.pairedRoundByPhase, pairedRoundByPhase)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other.skippedCycles, skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weightClass,competitionAgeCategory,competition,competitionSystemAffiliation,const DeepCollectionEquality().hash(pairedRoundByPhase),pos,const DeepCollectionEquality().hash(skippedCycles));

@override
String toString() {
  return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, competitionAgeCategory: $competitionAgeCategory, competition: $competition, competitionSystemAffiliation: $competitionSystemAffiliation, pairedRoundByPhase: $pairedRoundByPhase, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class $CompetitionWeightCategoryCopyWith<$Res>  {
  factory $CompetitionWeightCategoryCopyWith(CompetitionWeightCategory value, $Res Function(CompetitionWeightCategory) _then) = _$CompetitionWeightCategoryCopyWithImpl;
@useResult
$Res call({
 int? id, WeightClass weightClass, CompetitionAgeCategory competitionAgeCategory, Competition competition, CompetitionSystemAffiliation? competitionSystemAffiliation, List<int> pairedRoundByPhase, int pos, List<int> skippedCycles
});


$WeightClassCopyWith<$Res> get weightClass;$CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory;$CompetitionCopyWith<$Res> get competition;$CompetitionSystemAffiliationCopyWith<$Res>? get competitionSystemAffiliation;

}
/// @nodoc
class _$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements $CompetitionWeightCategoryCopyWith<$Res> {
  _$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final CompetitionWeightCategory _self;
  final $Res Function(CompetitionWeightCategory) _then;

/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? weightClass = null,Object? competitionAgeCategory = null,Object? competition = null,Object? competitionSystemAffiliation = freezed,Object? pairedRoundByPhase = null,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,competitionAgeCategory: null == competitionAgeCategory ? _self.competitionAgeCategory : competitionAgeCategory // ignore: cast_nullable_to_non_nullable
as CompetitionAgeCategory,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystemAffiliation: freezed == competitionSystemAffiliation ? _self.competitionSystemAffiliation : competitionSystemAffiliation // ignore: cast_nullable_to_non_nullable
as CompetitionSystemAffiliation?,pairedRoundByPhase: null == pairedRoundByPhase ? _self.pairedRoundByPhase : pairedRoundByPhase // ignore: cast_nullable_to_non_nullable
as List<int>,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
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
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionSystemAffiliationCopyWith<$Res>? get competitionSystemAffiliation {
    if (_self.competitionSystemAffiliation == null) {
    return null;
  }

  return $CompetitionSystemAffiliationCopyWith<$Res>(_self.competitionSystemAffiliation!, (value) {
    return _then(_self.copyWith(competitionSystemAffiliation: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystemAffiliation? competitionSystemAffiliation,  List<int> pairedRoundByPhase,  int pos,  List<int> skippedCycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystemAffiliation,_that.pairedRoundByPhase,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystemAffiliation? competitionSystemAffiliation,  List<int> pairedRoundByPhase,  int pos,  List<int> skippedCycles)  $default,) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory():
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystemAffiliation,_that.pairedRoundByPhase,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  WeightClass weightClass,  CompetitionAgeCategory competitionAgeCategory,  Competition competition,  CompetitionSystemAffiliation? competitionSystemAffiliation,  List<int> pairedRoundByPhase,  int pos,  List<int> skippedCycles)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionWeightCategory() when $default != null:
return $default(_that.id,_that.weightClass,_that.competitionAgeCategory,_that.competition,_that.competitionSystemAffiliation,_that.pairedRoundByPhase,_that.pos,_that.skippedCycles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionWeightCategory extends CompetitionWeightCategory {
  const _CompetitionWeightCategory({this.id, required this.weightClass, required this.competitionAgeCategory, required this.competition, this.competitionSystemAffiliation, final  List<int> pairedRoundByPhase = const [], this.pos = 0, final  List<int> skippedCycles = const []}): _pairedRoundByPhase = pairedRoundByPhase,_skippedCycles = skippedCycles,super._();
  factory _CompetitionWeightCategory.fromJson(Map<String, dynamic> json) => _$CompetitionWeightCategoryFromJson(json);

@override final  int? id;
@override final  WeightClass weightClass;
@override final  CompetitionAgeCategory competitionAgeCategory;
@override final  Competition competition;
@override final  CompetitionSystemAffiliation? competitionSystemAffiliation;
/// Round by which is currently paired
/// - []: No round was and no phase was paired.
/// - [0]: One (first) round in the first phase was paired.
/// - [3, 1]: 4th round in the first phase, and second round in the second phase was paired.
 final  List<int> _pairedRoundByPhase;
/// Round by which is currently paired
/// - []: No round was and no phase was paired.
/// - [0]: One (first) round in the first phase was paired.
/// - [3, 1]: 4th round in the first phase, and second round in the second phase was paired.
@override@JsonKey() List<int> get pairedRoundByPhase {
  if (_pairedRoundByPhase is EqualUnmodifiableListView) return _pairedRoundByPhase;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pairedRoundByPhase);
}

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionWeightCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.competitionAgeCategory, competitionAgeCategory) || other.competitionAgeCategory == competitionAgeCategory)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystemAffiliation, competitionSystemAffiliation) || other.competitionSystemAffiliation == competitionSystemAffiliation)&&const DeepCollectionEquality().equals(other._pairedRoundByPhase, _pairedRoundByPhase)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other._skippedCycles, _skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weightClass,competitionAgeCategory,competition,competitionSystemAffiliation,const DeepCollectionEquality().hash(_pairedRoundByPhase),pos,const DeepCollectionEquality().hash(_skippedCycles));

@override
String toString() {
  return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, competitionAgeCategory: $competitionAgeCategory, competition: $competition, competitionSystemAffiliation: $competitionSystemAffiliation, pairedRoundByPhase: $pairedRoundByPhase, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class _$CompetitionWeightCategoryCopyWith<$Res> implements $CompetitionWeightCategoryCopyWith<$Res> {
  factory _$CompetitionWeightCategoryCopyWith(_CompetitionWeightCategory value, $Res Function(_CompetitionWeightCategory) _then) = __$CompetitionWeightCategoryCopyWithImpl;
@override @useResult
$Res call({
 int? id, WeightClass weightClass, CompetitionAgeCategory competitionAgeCategory, Competition competition, CompetitionSystemAffiliation? competitionSystemAffiliation, List<int> pairedRoundByPhase, int pos, List<int> skippedCycles
});


@override $WeightClassCopyWith<$Res> get weightClass;@override $CompetitionAgeCategoryCopyWith<$Res> get competitionAgeCategory;@override $CompetitionCopyWith<$Res> get competition;@override $CompetitionSystemAffiliationCopyWith<$Res>? get competitionSystemAffiliation;

}
/// @nodoc
class __$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements _$CompetitionWeightCategoryCopyWith<$Res> {
  __$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final _CompetitionWeightCategory _self;
  final $Res Function(_CompetitionWeightCategory) _then;

/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? weightClass = null,Object? competitionAgeCategory = null,Object? competition = null,Object? competitionSystemAffiliation = freezed,Object? pairedRoundByPhase = null,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_CompetitionWeightCategory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,competitionAgeCategory: null == competitionAgeCategory ? _self.competitionAgeCategory : competitionAgeCategory // ignore: cast_nullable_to_non_nullable
as CompetitionAgeCategory,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystemAffiliation: freezed == competitionSystemAffiliation ? _self.competitionSystemAffiliation : competitionSystemAffiliation // ignore: cast_nullable_to_non_nullable
as CompetitionSystemAffiliation?,pairedRoundByPhase: null == pairedRoundByPhase ? _self._pairedRoundByPhase : pairedRoundByPhase // ignore: cast_nullable_to_non_nullable
as List<int>,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
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
}/// Create a copy of CompetitionWeightCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionSystemAffiliationCopyWith<$Res>? get competitionSystemAffiliation {
    if (_self.competitionSystemAffiliation == null) {
    return null;
  }

  return $CompetitionSystemAffiliationCopyWith<$Res>(_self.competitionSystemAffiliation!, (value) {
    return _then(_self.copyWith(competitionSystemAffiliation: value));
  });
}
}

/// @nodoc
mixin _$RankingMetric {

 int get classificationPoints; int get technicalPoints; int get wins;
/// Create a copy of RankingMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingMetricCopyWith<RankingMetric> get copyWith => _$RankingMetricCopyWithImpl<RankingMetric>(this as RankingMetric, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingMetric&&(identical(other.classificationPoints, classificationPoints) || other.classificationPoints == classificationPoints)&&(identical(other.technicalPoints, technicalPoints) || other.technicalPoints == technicalPoints)&&(identical(other.wins, wins) || other.wins == wins));
}


@override
int get hashCode => Object.hash(runtimeType,classificationPoints,technicalPoints,wins);

@override
String toString() {
  return 'RankingMetric(classificationPoints: $classificationPoints, technicalPoints: $technicalPoints, wins: $wins)';
}


}

/// @nodoc
abstract mixin class $RankingMetricCopyWith<$Res>  {
  factory $RankingMetricCopyWith(RankingMetric value, $Res Function(RankingMetric) _then) = _$RankingMetricCopyWithImpl;
@useResult
$Res call({
 int classificationPoints, int technicalPoints, int wins
});




}
/// @nodoc
class _$RankingMetricCopyWithImpl<$Res>
    implements $RankingMetricCopyWith<$Res> {
  _$RankingMetricCopyWithImpl(this._self, this._then);

  final RankingMetric _self;
  final $Res Function(RankingMetric) _then;

/// Create a copy of RankingMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classificationPoints = null,Object? technicalPoints = null,Object? wins = null,}) {
  return _then(_self.copyWith(
classificationPoints: null == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int,technicalPoints: null == technicalPoints ? _self.technicalPoints : technicalPoints // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingMetric].
extension RankingMetricPatterns on RankingMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingMetric value)  $default,){
final _that = this;
switch (_that) {
case _RankingMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingMetric value)?  $default,){
final _that = this;
switch (_that) {
case _RankingMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int classificationPoints,  int technicalPoints,  int wins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingMetric() when $default != null:
return $default(_that.classificationPoints,_that.technicalPoints,_that.wins);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int classificationPoints,  int technicalPoints,  int wins)  $default,) {final _that = this;
switch (_that) {
case _RankingMetric():
return $default(_that.classificationPoints,_that.technicalPoints,_that.wins);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int classificationPoints,  int technicalPoints,  int wins)?  $default,) {final _that = this;
switch (_that) {
case _RankingMetric() when $default != null:
return $default(_that.classificationPoints,_that.technicalPoints,_that.wins);case _:
  return null;

}
}

}

/// @nodoc


class _RankingMetric implements RankingMetric {
  const _RankingMetric({required this.classificationPoints, required this.technicalPoints, required this.wins});
  

@override final  int classificationPoints;
@override final  int technicalPoints;
@override final  int wins;

/// Create a copy of RankingMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingMetricCopyWith<_RankingMetric> get copyWith => __$RankingMetricCopyWithImpl<_RankingMetric>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingMetric&&(identical(other.classificationPoints, classificationPoints) || other.classificationPoints == classificationPoints)&&(identical(other.technicalPoints, technicalPoints) || other.technicalPoints == technicalPoints)&&(identical(other.wins, wins) || other.wins == wins));
}


@override
int get hashCode => Object.hash(runtimeType,classificationPoints,technicalPoints,wins);

@override
String toString() {
  return 'RankingMetric(classificationPoints: $classificationPoints, technicalPoints: $technicalPoints, wins: $wins)';
}


}

/// @nodoc
abstract mixin class _$RankingMetricCopyWith<$Res> implements $RankingMetricCopyWith<$Res> {
  factory _$RankingMetricCopyWith(_RankingMetric value, $Res Function(_RankingMetric) _then) = __$RankingMetricCopyWithImpl;
@override @useResult
$Res call({
 int classificationPoints, int technicalPoints, int wins
});




}
/// @nodoc
class __$RankingMetricCopyWithImpl<$Res>
    implements _$RankingMetricCopyWith<$Res> {
  __$RankingMetricCopyWithImpl(this._self, this._then);

  final _RankingMetric _self;
  final $Res Function(_RankingMetric) _then;

/// Create a copy of RankingMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classificationPoints = null,Object? technicalPoints = null,Object? wins = null,}) {
  return _then(_RankingMetric(
classificationPoints: null == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int,technicalPoints: null == technicalPoints ? _self.technicalPoints : technicalPoints // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Rank {

/// Rank starts at 1
 int get rank; RankingMetric get metric;
/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankCopyWith<Rank> get copyWith => _$RankCopyWithImpl<Rank>(this as Rank, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rank&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.metric, metric) || other.metric == metric));
}


@override
int get hashCode => Object.hash(runtimeType,rank,metric);

@override
String toString() {
  return 'Rank(rank: $rank, metric: $metric)';
}


}

/// @nodoc
abstract mixin class $RankCopyWith<$Res>  {
  factory $RankCopyWith(Rank value, $Res Function(Rank) _then) = _$RankCopyWithImpl;
@useResult
$Res call({
 int rank, RankingMetric metric
});


$RankingMetricCopyWith<$Res> get metric;

}
/// @nodoc
class _$RankCopyWithImpl<$Res>
    implements $RankCopyWith<$Res> {
  _$RankCopyWithImpl(this._self, this._then);

  final Rank _self;
  final $Res Function(Rank) _then;

/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? metric = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as RankingMetric,
  ));
}
/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingMetricCopyWith<$Res> get metric {
  
  return $RankingMetricCopyWith<$Res>(_self.metric, (value) {
    return _then(_self.copyWith(metric: value));
  });
}
}


/// Adds pattern-matching-related methods to [Rank].
extension RankPatterns on Rank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rank value)  $default,){
final _that = this;
switch (_that) {
case _Rank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rank value)?  $default,){
final _that = this;
switch (_that) {
case _Rank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  RankingMetric metric)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rank() when $default != null:
return $default(_that.rank,_that.metric);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  RankingMetric metric)  $default,) {final _that = this;
switch (_that) {
case _Rank():
return $default(_that.rank,_that.metric);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  RankingMetric metric)?  $default,) {final _that = this;
switch (_that) {
case _Rank() when $default != null:
return $default(_that.rank,_that.metric);case _:
  return null;

}
}

}

/// @nodoc


class _Rank implements Rank {
  const _Rank({required this.rank, required this.metric});
  

/// Rank starts at 1
@override final  int rank;
@override final  RankingMetric metric;

/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankCopyWith<_Rank> get copyWith => __$RankCopyWithImpl<_Rank>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rank&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.metric, metric) || other.metric == metric));
}


@override
int get hashCode => Object.hash(runtimeType,rank,metric);

@override
String toString() {
  return 'Rank(rank: $rank, metric: $metric)';
}


}

/// @nodoc
abstract mixin class _$RankCopyWith<$Res> implements $RankCopyWith<$Res> {
  factory _$RankCopyWith(_Rank value, $Res Function(_Rank) _then) = __$RankCopyWithImpl;
@override @useResult
$Res call({
 int rank, RankingMetric metric
});


@override $RankingMetricCopyWith<$Res> get metric;

}
/// @nodoc
class __$RankCopyWithImpl<$Res>
    implements _$RankCopyWith<$Res> {
  __$RankCopyWithImpl(this._self, this._then);

  final _Rank _self;
  final $Res Function(_Rank) _then;

/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? metric = null,}) {
  return _then(_Rank(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as RankingMetric,
  ));
}

/// Create a copy of Rank
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingMetricCopyWith<$Res> get metric {
  
  return $RankingMetricCopyWith<$Res>(_self.metric, (value) {
    return _then(_self.copyWith(metric: value));
  });
}
}

// dart format on
