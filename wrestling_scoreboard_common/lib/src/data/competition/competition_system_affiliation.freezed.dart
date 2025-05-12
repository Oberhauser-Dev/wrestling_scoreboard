// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_system_affiliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionSystemAffiliation {

 int? get id; Competition get competition; CompetitionSystem get competitionSystem; int? get maxContestants;
/// Create a copy of CompetitionSystemAffiliation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetitionSystemAffiliationCopyWith<CompetitionSystemAffiliation> get copyWith => _$CompetitionSystemAffiliationCopyWithImpl<CompetitionSystemAffiliation>(this as CompetitionSystemAffiliation, _$identity);

  /// Serializes this CompetitionSystemAffiliation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetitionSystemAffiliation&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.maxContestants, maxContestants) || other.maxContestants == maxContestants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,competitionSystem,maxContestants);

@override
String toString() {
  return 'CompetitionSystemAffiliation(id: $id, competition: $competition, competitionSystem: $competitionSystem, maxContestants: $maxContestants)';
}


}

/// @nodoc
abstract mixin class $CompetitionSystemAffiliationCopyWith<$Res>  {
  factory $CompetitionSystemAffiliationCopyWith(CompetitionSystemAffiliation value, $Res Function(CompetitionSystemAffiliation) _then) = _$CompetitionSystemAffiliationCopyWithImpl;
@useResult
$Res call({
 int? id, Competition competition, CompetitionSystem competitionSystem, int? maxContestants
});


$CompetitionCopyWith<$Res> get competition;

}
/// @nodoc
class _$CompetitionSystemAffiliationCopyWithImpl<$Res>
    implements $CompetitionSystemAffiliationCopyWith<$Res> {
  _$CompetitionSystemAffiliationCopyWithImpl(this._self, this._then);

  final CompetitionSystemAffiliation _self;
  final $Res Function(CompetitionSystemAffiliation) _then;

/// Create a copy of CompetitionSystemAffiliation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? competition = null,Object? competitionSystem = null,Object? maxContestants = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystem: null == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem,maxContestants: freezed == maxContestants ? _self.maxContestants : maxContestants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of CompetitionSystemAffiliation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompetitionCopyWith<$Res> get competition {
  
  return $CompetitionCopyWith<$Res>(_self.competition, (value) {
    return _then(_self.copyWith(competition: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _CompetitionSystemAffiliation extends CompetitionSystemAffiliation {
  const _CompetitionSystemAffiliation({this.id, required this.competition, required this.competitionSystem, this.maxContestants}): super._();
  factory _CompetitionSystemAffiliation.fromJson(Map<String, dynamic> json) => _$CompetitionSystemAffiliationFromJson(json);

@override final  int? id;
@override final  Competition competition;
@override final  CompetitionSystem competitionSystem;
@override final  int? maxContestants;

/// Create a copy of CompetitionSystemAffiliation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetitionSystemAffiliationCopyWith<_CompetitionSystemAffiliation> get copyWith => __$CompetitionSystemAffiliationCopyWithImpl<_CompetitionSystemAffiliation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetitionSystemAffiliationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetitionSystemAffiliation&&(identical(other.id, id) || other.id == id)&&(identical(other.competition, competition) || other.competition == competition)&&(identical(other.competitionSystem, competitionSystem) || other.competitionSystem == competitionSystem)&&(identical(other.maxContestants, maxContestants) || other.maxContestants == maxContestants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,competition,competitionSystem,maxContestants);

@override
String toString() {
  return 'CompetitionSystemAffiliation(id: $id, competition: $competition, competitionSystem: $competitionSystem, maxContestants: $maxContestants)';
}


}

/// @nodoc
abstract mixin class _$CompetitionSystemAffiliationCopyWith<$Res> implements $CompetitionSystemAffiliationCopyWith<$Res> {
  factory _$CompetitionSystemAffiliationCopyWith(_CompetitionSystemAffiliation value, $Res Function(_CompetitionSystemAffiliation) _then) = __$CompetitionSystemAffiliationCopyWithImpl;
@override @useResult
$Res call({
 int? id, Competition competition, CompetitionSystem competitionSystem, int? maxContestants
});


@override $CompetitionCopyWith<$Res> get competition;

}
/// @nodoc
class __$CompetitionSystemAffiliationCopyWithImpl<$Res>
    implements _$CompetitionSystemAffiliationCopyWith<$Res> {
  __$CompetitionSystemAffiliationCopyWithImpl(this._self, this._then);

  final _CompetitionSystemAffiliation _self;
  final $Res Function(_CompetitionSystemAffiliation) _then;

/// Create a copy of CompetitionSystemAffiliation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? competition = null,Object? competitionSystem = null,Object? maxContestants = freezed,}) {
  return _then(_CompetitionSystemAffiliation(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,competition: null == competition ? _self.competition : competition // ignore: cast_nullable_to_non_nullable
as Competition,competitionSystem: null == competitionSystem ? _self.competitionSystem : competitionSystem // ignore: cast_nullable_to_non_nullable
as CompetitionSystem,maxContestants: freezed == maxContestants ? _self.maxContestants : maxContestants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of CompetitionSystemAffiliation
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
