// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_age_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionAgeCategory {

 int? get id; Competition get competition; AgeCategory get ageCategory; int get pos; List<int> get skippedCycles;
/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionAgeCategoryCopyWith<CompetitionAgeCategory> get copyWith => _$CompetitionAgeCategoryCopyWithImpl<CompetitionAgeCategory>(this as CompetitionAgeCategory, _$identity);

  /// Serializes this CompetitionAgeCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionAgeCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.ageCategory, ageCategory) || other.ageCategory == ageCategory)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other.skippedCycles, skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,ageCategory,pos,const DeepCollectionEquality().hash(skippedCycles));

@override
String toString() {
  return 'CompetitionAgeCategory(id: $id, competition: $competition, ageCategory: $ageCategory, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class $CompetitionAgeCategoryCopyWith<$Res>  {
  factory $CompetitionAgeCategoryCopyWith(CompetitionAgeCategory value, $Res Function(CompetitionAgeCategory) _then) = _$CompetitionAgeCategoryCopyWithImpl;
@useResult
$Res call({
 int? id, Competition competition, AgeCategory ageCategory, int pos, List<int> skippedCycles
});


$CompetitionCopyWith<$Res> get competition;$AgeCategoryCopyWith<$Res> get ageCategory;

}
/// @nodoc
class _$CompetitionAgeCategoryCopyWithImpl<$Res>
    implements $CompetitionAgeCategoryCopyWith<$Res> {
  _$CompetitionAgeCategoryCopyWithImpl(this._self, this._then);

  final CompetitionAgeCategory _self;
  final $Res Function(CompetitionAgeCategory) _then;

/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? competition = null,Object? ageCategory = null,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,ageCategory: null == ageCategory ? _self.ageCategory : ageCategory // ignore: cast_nullable_to_non_nullable
as AgeCategory,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,skippedCycles: null == skippedCycles ? _self.skippedCycles : skippedCycles // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgeCategoryCopyWith<$Res> get ageCategory {
  
  return $AgeCategoryCopyWith<$Res>(_self.ageCategory, (value) {
    return _then(_self.copyWith(ageCategory: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompetitionAgeCategory].
extension CompetitionAgeCategoryPatterns on CompetitionAgeCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionAgeCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionAgeCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionAgeCategory value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionAgeCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionAgeCategory value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionAgeCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Competition competition,  AgeCategory ageCategory,  int pos,  List<int> skippedCycles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionAgeCategory() when $default != null:
return $default(_that.id,_that.competition,_that.ageCategory,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Competition competition,  AgeCategory ageCategory,  int pos,  List<int> skippedCycles)  $default,) {final _that = this;
switch (_that) {
case _CompetitionAgeCategory():
return $default(_that.id,_that.competition,_that.ageCategory,_that.pos,_that.skippedCycles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Competition competition,  AgeCategory ageCategory,  int pos,  List<int> skippedCycles)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionAgeCategory() when $default != null:
return $default(_that.id,_that.competition,_that.ageCategory,_that.pos,_that.skippedCycles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionAgeCategory extends CompetitionAgeCategory {
  const _CompetitionAgeCategory({this.id, required this.competition, required this.ageCategory, this.pos = 0, final  List<int> skippedCycles = const []}): _skippedCycles = skippedCycles,super._();
  factory _CompetitionAgeCategory.fromJson(Map<String, dynamic> json) => _$CompetitionAgeCategoryFromJson(json);

@override final  int? id;
@override final  Competition competition;
@override final  AgeCategory ageCategory;
@override@JsonKey() final  int pos;
 final  List<int> _skippedCycles;
@override@JsonKey() List<int> get skippedCycles {
  if (_skippedCycles is EqualUnmodifiableListView) return _skippedCycles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skippedCycles);
}


/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionAgeCategoryCopyWith<_CompetitionAgeCategory> get copyWith => __$CompetitionAgeCategoryCopyWithImpl<_CompetitionAgeCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionAgeCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionAgeCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.ageCategory, ageCategory) || other.ageCategory == ageCategory)&&(identical(other.pos, pos) || other.pos == pos)&&const DeepCollectionEquality().equals(other._skippedCycles, _skippedCycles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,ageCategory,pos,const DeepCollectionEquality().hash(_skippedCycles));

@override
String toString() {
  return 'CompetitionAgeCategory(id: $id, competition: $competition, ageCategory: $ageCategory, pos: $pos, skippedCycles: $skippedCycles)';
}


}

/// @nodoc
abstract mixin class _$CompetitionAgeCategoryCopyWith<$Res> implements $CompetitionAgeCategoryCopyWith<$Res> {
  factory _$CompetitionAgeCategoryCopyWith(_CompetitionAgeCategory value, $Res Function(_CompetitionAgeCategory) _then) = __$CompetitionAgeCategoryCopyWithImpl;
@override @useResult
$Res call({
 int? id, Competition competition, AgeCategory ageCategory, int pos, List<int> skippedCycles
});


@override $CompetitionCopyWith<$Res> get competition;@override $AgeCategoryCopyWith<$Res> get ageCategory;

}
/// @nodoc
class __$CompetitionAgeCategoryCopyWithImpl<$Res>
    implements _$CompetitionAgeCategoryCopyWith<$Res> {
  __$CompetitionAgeCategoryCopyWithImpl(this._self, this._then);

  final _CompetitionAgeCategory _self;
  final $Res Function(_CompetitionAgeCategory) _then;

/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? competition = null,Object? ageCategory = null,Object? pos = null,Object? skippedCycles = null,}) {
  return _then(_CompetitionAgeCategory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,ageCategory: null == ageCategory ? _self.ageCategory : ageCategory // ignore: cast_nullable_to_non_nullable
as AgeCategory,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,skippedCycles: null == skippedCycles ? _self._skippedCycles : skippedCycles // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionAgeCategory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgeCategoryCopyWith<$Res> get ageCategory {
  
  return $AgeCategoryCopyWith<$Res>(_self.ageCategory, (value) {
    return _then(_self.copyWith(ageCategory: value));
  });
}
}

// dart format on
