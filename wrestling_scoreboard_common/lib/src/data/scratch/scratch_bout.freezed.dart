// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scratch_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScratchBout {

 int? get id; Bout get bout; WeightClass get weightClass; BoutConfig get boutConfig;
/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScratchBoutCopyWith<ScratchBout> get copyWith => _$ScratchBoutCopyWithImpl<ScratchBout>(this as ScratchBout, _$identity);

  /// Serializes this ScratchBout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScratchBout&&(identical(other.id, id) || other.id == id)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bout,weightClass,boutConfig);

@override
String toString() {
  return 'ScratchBout(id: $id, bout: $bout, weightClass: $weightClass, boutConfig: $boutConfig)';
}


}

/// @nodoc
abstract mixin class $ScratchBoutCopyWith<$Res>  {
  factory $ScratchBoutCopyWith(ScratchBout value, $Res Function(ScratchBout) _then) = _$ScratchBoutCopyWithImpl;
@useResult
$Res call({
 int? id, Bout bout, WeightClass weightClass, BoutConfig boutConfig
});


$BoutCopyWith<$Res> get bout;$WeightClassCopyWith<$Res> get weightClass;$BoutConfigCopyWith<$Res> get boutConfig;

}
/// @nodoc
class _$ScratchBoutCopyWithImpl<$Res>
    implements $ScratchBoutCopyWith<$Res> {
  _$ScratchBoutCopyWithImpl(this._self, this._then);

  final ScratchBout _self;
  final $Res Function(ScratchBout) _then;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bout = null,Object? weightClass = null,Object? boutConfig = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,
  ));
}
/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ScratchBout extends ScratchBout {
  const _ScratchBout({this.id, required this.bout, required this.weightClass, required this.boutConfig}): super._();
  factory _ScratchBout.fromJson(Map<String, dynamic> json) => _$ScratchBoutFromJson(json);

@override final  int? id;
@override final  Bout bout;
@override final  WeightClass weightClass;
@override final  BoutConfig boutConfig;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScratchBoutCopyWith<_ScratchBout> get copyWith => __$ScratchBoutCopyWithImpl<_ScratchBout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScratchBoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScratchBout&&(identical(other.id, id) || other.id == id)&&(identical(other.bout, bout) || other.bout == bout)&&(identical(other.weightClass, weightClass) || other.weightClass == weightClass)&&(identical(other.boutConfig, boutConfig) || other.boutConfig == boutConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bout,weightClass,boutConfig);

@override
String toString() {
  return 'ScratchBout(id: $id, bout: $bout, weightClass: $weightClass, boutConfig: $boutConfig)';
}


}

/// @nodoc
abstract mixin class _$ScratchBoutCopyWith<$Res> implements $ScratchBoutCopyWith<$Res> {
  factory _$ScratchBoutCopyWith(_ScratchBout value, $Res Function(_ScratchBout) _then) = __$ScratchBoutCopyWithImpl;
@override @useResult
$Res call({
 int? id, Bout bout, WeightClass weightClass, BoutConfig boutConfig
});


@override $BoutCopyWith<$Res> get bout;@override $WeightClassCopyWith<$Res> get weightClass;@override $BoutConfigCopyWith<$Res> get boutConfig;

}
/// @nodoc
class __$ScratchBoutCopyWithImpl<$Res>
    implements _$ScratchBoutCopyWith<$Res> {
  __$ScratchBoutCopyWithImpl(this._self, this._then);

  final _ScratchBout _self;
  final $Res Function(_ScratchBout) _then;

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bout = null,Object? weightClass = null,Object? boutConfig = null,}) {
  return _then(_ScratchBout(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bout: null == bout ? _self.bout : bout // ignore: cast_nullable_to_non_nullable
as Bout,weightClass: null == weightClass ? _self.weightClass : weightClass // ignore: cast_nullable_to_non_nullable
as WeightClass,boutConfig: null == boutConfig ? _self.boutConfig : boutConfig // ignore: cast_nullable_to_non_nullable
as BoutConfig,
  ));
}

/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutCopyWith<$Res> get bout {
  
  return $BoutCopyWith<$Res>(_self.bout, (value) {
    return _then(_self.copyWith(bout: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeightClassCopyWith<$Res> get weightClass {
  
  return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
    return _then(_self.copyWith(weightClass: value));
  });
}/// Create a copy of ScratchBout
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoutConfigCopyWith<$Res> get boutConfig {
  
  return $BoutConfigCopyWith<$Res>(_self.boutConfig, (value) {
    return _then(_self.copyWith(boutConfig: value));
  });
}
}

// dart format on
