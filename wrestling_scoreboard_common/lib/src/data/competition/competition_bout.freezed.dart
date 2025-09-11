// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionBout {

 int? get id; Competition get competition; Bout get bout; int get pos; int? get mat; int? get round;/// The rank the bout is fought for. Rank is described as x * 2 + 1 (+1)
/// 0: 1+2
/// 1: 3+4
/// 2: 5+6 ...
 int? get rank; RoundType get roundType; CompetitionWeightCategory? get weightCategory;
/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionBoutCopyWith<CompetitionBout> get copyWith => _$CompetitionBoutCopyWithImpl<CompetitionBout>(this as CompetitionBout, _$identity);

  /// Serializes this CompetitionBout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionBout&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.mat, mat) || other.mat == mat)&&(identical(other.round, round) || other.round == round)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.roundType, roundType) || other.roundType == roundType)&&(identical(other.weightCategory, weightCategory) || other.weightCategory == weightCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,bout,pos,mat,round,rank,roundType,weightCategory);

@override
String toString() {
  return 'CompetitionBout(id: $id, competition: $competition, bout: $bout, pos: $pos, mat: $mat, round: $round, rank: $rank, roundType: $roundType, weightCategory: $weightCategory)';
}


}

/// @nodoc
abstract mixin class $CompetitionBoutCopyWith<$Res>  {
  factory $CompetitionBoutCopyWith(CompetitionBout value, $Res Function(CompetitionBout) _then) = _$CompetitionBoutCopyWithImpl;
@useResult
$Res call({
 int? id, Competition competition, Bout bout, int pos, int? mat, int? round, int? rank, RoundType roundType, CompetitionWeightCategory? weightCategory
});


$CompetitionCopyWith<$Res> get competition;$BoutCopyWith<$Res> get bout;$CompetitionWeightCategoryCopyWith<$Res>? get weightCategory;

}
/// @nodoc
class _$CompetitionBoutCopyWithImpl<$Res>
    implements $CompetitionBoutCopyWith<$Res> {
  _$CompetitionBoutCopyWithImpl(this._self, this._then);

  final CompetitionBout _self;
  final $Res Function(CompetitionBout) _then;

/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? competition = null,Object? bout = null,Object? pos = null,Object? mat = freezed,Object? round = freezed,Object? rank = freezed,Object? roundType = null,Object? weightCategory = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,mat: freezed == mat ? _self.mat : mat // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,roundType: null == roundType ? _self.roundType : roundType // ignore: cast_nullable_to_non_nullable
as RoundType,weightCategory: freezed == weightCategory ? _self.weightCategory : weightCategory // ignore: cast_nullable_to_non_nullable
as CompetitionWeightCategory?,
  ));
}
/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of CompetitionBout
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


/// Adds pattern-matching-related methods to [CompetitionBout].
extension CompetitionBoutPatterns on CompetitionBout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetitionBout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetitionBout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetitionBout value)  $default,){
final _that = this;
switch (_that) {
case _CompetitionBout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetitionBout value)?  $default,){
final _that = this;
switch (_that) {
case _CompetitionBout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  Competition competition,  Bout bout,  int pos,  int? mat,  int? round,  int? rank,  RoundType roundType,  CompetitionWeightCategory? weightCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetitionBout() when $default != null:
return $default(_that.id,_that.competition,_that.bout,_that.pos,_that.mat,_that.round,_that.rank,_that.roundType,_that.weightCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  Competition competition,  Bout bout,  int pos,  int? mat,  int? round,  int? rank,  RoundType roundType,  CompetitionWeightCategory? weightCategory)  $default,) {final _that = this;
switch (_that) {
case _CompetitionBout():
return $default(_that.id,_that.competition,_that.bout,_that.pos,_that.mat,_that.round,_that.rank,_that.roundType,_that.weightCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  Competition competition,  Bout bout,  int pos,  int? mat,  int? round,  int? rank,  RoundType roundType,  CompetitionWeightCategory? weightCategory)?  $default,) {final _that = this;
switch (_that) {
case _CompetitionBout() when $default != null:
return $default(_that.id,_that.competition,_that.bout,_that.pos,_that.mat,_that.round,_that.rank,_that.roundType,_that.weightCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetitionBout extends CompetitionBout {
  const _CompetitionBout({this.id, required this.competition, required this.bout, required this.pos, this.mat, this.round, this.rank, this.roundType = RoundType.elimination, this.weightCategory}): super._();
  factory _CompetitionBout.fromJson(Map<String, dynamic> json) => _$CompetitionBoutFromJson(json);

@override final  int? id;
@override final  Competition competition;
@override final  Bout bout;
@override final  int pos;
@override final  int? mat;
@override final  int? round;
/// The rank the bout is fought for. Rank is described as x * 2 + 1 (+1)
/// 0: 1+2
/// 1: 3+4
/// 2: 5+6 ...
@override final  int? rank;
@override@JsonKey() final  RoundType roundType;
@override final  CompetitionWeightCategory? weightCategory;

/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionBoutCopyWith<_CompetitionBout> get copyWith => __$CompetitionBoutCopyWithImpl<_CompetitionBout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionBoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionBout&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.mat, mat) || other.mat == mat)&&(identical(other.round, round) || other.round == round)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.roundType, roundType) || other.roundType == roundType)&&(identical(other.weightCategory, weightCategory) || other.weightCategory == weightCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,bout,pos,mat,round,rank,roundType,weightCategory);

@override
String toString() {
  return 'CompetitionBout(id: $id, competition: $competition, bout: $bout, pos: $pos, mat: $mat, round: $round, rank: $rank, roundType: $roundType, weightCategory: $weightCategory)';
}


}

/// @nodoc
abstract mixin class _$CompetitionBoutCopyWith<$Res> implements $CompetitionBoutCopyWith<$Res> {
  factory _$CompetitionBoutCopyWith(_CompetitionBout value, $Res Function(_CompetitionBout) _then) = __$CompetitionBoutCopyWithImpl;
@override @useResult
$Res call({
 int? id, Competition competition, Bout bout, int pos, int? mat, int? round, int? rank, RoundType roundType, CompetitionWeightCategory? weightCategory
});


@override $CompetitionCopyWith<$Res> get competition;@override $BoutCopyWith<$Res> get bout;@override $CompetitionWeightCategoryCopyWith<$Res>? get weightCategory;

}
/// @nodoc
class __$CompetitionBoutCopyWithImpl<$Res>
    implements _$CompetitionBoutCopyWith<$Res> {
  __$CompetitionBoutCopyWithImpl(this._self, this._then);

  final _CompetitionBout _self;
  final $Res Function(_CompetitionBout) _then;

/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? competition = null,Object? bout = null,Object? pos = null,Object? mat = freezed,Object? round = freezed,Object? rank = freezed,Object? roundType = null,Object? weightCategory = freezed,}) {
  return _then(_CompetitionBout(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as int,mat: freezed == mat ? _self.mat : mat // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,roundType: null == roundType ? _self.roundType : roundType // ignore: cast_nullable_to_non_nullable
as RoundType,weightCategory: freezed == weightCategory ? _self.weightCategory : weightCategory // ignore: cast_nullable_to_non_nullable
as CompetitionWeightCategory?,
  ));
}

/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}/// Create a copy of CompetitionBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of CompetitionBout
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
