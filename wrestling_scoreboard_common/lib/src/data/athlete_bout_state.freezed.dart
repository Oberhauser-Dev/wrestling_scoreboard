// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'athlete_bout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AthleteBoutState {

 int? get id; Membership get membership; int? get classificationPoints;
/// Create a copy of AthleteBoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AthleteBoutStateCopyWith<AthleteBoutState> get copyWith => _$AthleteBoutStateCopyWithImpl<AthleteBoutState>(this as AthleteBoutState, _$identity);

  /// Serializes this AthleteBoutState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AthleteBoutState&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.classificationPoints, classificationPoints) || other.classificationPoints == classificationPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,classificationPoints);

@override
String toString() {
  return 'AthleteBoutState(id: $id, membership: $membership, classificationPoints: $classificationPoints)';
}


}

/// @nodoc
abstract mixin class $AthleteBoutStateCopyWith<$Res>  {
  factory $AthleteBoutStateCopyWith(AthleteBoutState value, $Res Function(AthleteBoutState) _then) = _$AthleteBoutStateCopyWithImpl;
@useResult
$Res call({
 int? id, Membership membership, int? classificationPoints
});


$MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$AthleteBoutStateCopyWithImpl<$Res>
    implements $AthleteBoutStateCopyWith<$Res> {
  _$AthleteBoutStateCopyWithImpl(this._self, this._then);

  final AthleteBoutState _self;
  final $Res Function(AthleteBoutState) _then;

/// Create a copy of AthleteBoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? membership = null,Object? classificationPoints = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,classificationPoints: freezed == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of AthleteBoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AthleteBoutState extends AthleteBoutState {
  const _AthleteBoutState({this.id, required this.membership, this.classificationPoints}): super._();
  factory _AthleteBoutState.fromJson(Map<String, dynamic> json) => _$AthleteBoutStateFromJson(json);

@override final  int? id;
@override final  Membership membership;
@override final  int? classificationPoints;

/// Create a copy of AthleteBoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AthleteBoutStateCopyWith<_AthleteBoutState> get copyWith => __$AthleteBoutStateCopyWithImpl<_AthleteBoutState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AthleteBoutStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AthleteBoutState&&(identical(other.id, id) || other.id == id)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.classificationPoints, classificationPoints) || other.classificationPoints == classificationPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,membership,classificationPoints);

@override
String toString() {
  return 'AthleteBoutState(id: $id, membership: $membership, classificationPoints: $classificationPoints)';
}


}

/// @nodoc
abstract mixin class _$AthleteBoutStateCopyWith<$Res> implements $AthleteBoutStateCopyWith<$Res> {
  factory _$AthleteBoutStateCopyWith(_AthleteBoutState value, $Res Function(_AthleteBoutState) _then) = __$AthleteBoutStateCopyWithImpl;
@override @useResult
$Res call({
 int? id, Membership membership, int? classificationPoints
});


@override $MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class __$AthleteBoutStateCopyWithImpl<$Res>
    implements _$AthleteBoutStateCopyWith<$Res> {
  __$AthleteBoutStateCopyWithImpl(this._self, this._then);

  final _AthleteBoutState _self;
  final $Res Function(_AthleteBoutState) _then;

/// Create a copy of AthleteBoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? membership = null,Object? classificationPoints = freezed,}) {
  return _then(_AthleteBoutState(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,classificationPoints: freezed == classificationPoints ? _self.classificationPoints : classificationPoints // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of AthleteBoutState
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
