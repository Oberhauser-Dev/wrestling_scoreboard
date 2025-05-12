// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$League {

 int? get id; String? get orgSyncId; Organization? get organization; String get name; DateTime get startDate; DateTime get endDate; Division get division;/// The bout days are not necessarily the total days a league has, but ideally they should.
/// More binding is the seasonPartition of each single Match.
 int get boutDays;
/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeagueCopyWith<League> get copyWith => _$LeagueCopyWithImpl<League>(this as League, _$identity);

  /// Serializes this League to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is League&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.division, division) || other.division == division)&&(identical(other.boutDays, boutDays) || other.boutDays == boutDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,name,startDate,endDate,division,boutDays);

@override
String toString() {
  return 'League(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, division: $division, boutDays: $boutDays)';
}


}

/// @nodoc
abstract mixin class $LeagueCopyWith<$Res>  {
  factory $LeagueCopyWith(League value, $Res Function(League) _then) = _$LeagueCopyWithImpl;
@useResult
$Res call({
 int? id, String? orgSyncId, Organization? organization, String name, DateTime startDate, DateTime endDate, Division division, int boutDays
});


$OrganizationCopyWith<$Res>? get organization;$DivisionCopyWith<$Res> get division;

}
/// @nodoc
class _$LeagueCopyWithImpl<$Res>
    implements $LeagueCopyWith<$Res> {
  _$LeagueCopyWithImpl(this._self, this._then);

  final League _self;
  final $Res Function(League) _then;

/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = freezed,Object? name = null,Object? startDate = null,Object? endDate = null,Object? division = null,Object? boutDays = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as Division,boutDays: null == boutDays ? _self.boutDays : boutDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DivisionCopyWith<$Res> get division {
  
  return $DivisionCopyWith<$Res>(_self.division, (value) {
    return _then(_self.copyWith(division: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _League extends League {
  const _League({this.id, this.orgSyncId, this.organization, required this.name, required this.startDate, required this.endDate, required this.division, required this.boutDays}): super._();
  factory _League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

@override final  int? id;
@override final  String? orgSyncId;
@override final  Organization? organization;
@override final  String name;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  Division division;
/// The bout days are not necessarily the total days a league has, but ideally they should.
/// More binding is the seasonPartition of each single Match.
@override final  int boutDays;

/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeagueCopyWith<_League> get copyWith => __$LeagueCopyWithImpl<_League>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeagueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _League&&(identical(other.id, id) || other.id == id)&&(identical(other.orgSyncId, orgSyncId) || other.orgSyncId == orgSyncId)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.name, name) || other.name == name)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.division, division) || other.division == division)&&(identical(other.boutDays, boutDays) || other.boutDays == boutDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgSyncId,organization,name,startDate,endDate,division,boutDays);

@override
String toString() {
  return 'League(id: $id, orgSyncId: $orgSyncId, organization: $organization, name: $name, startDate: $startDate, endDate: $endDate, division: $division, boutDays: $boutDays)';
}


}

/// @nodoc
abstract mixin class _$LeagueCopyWith<$Res> implements $LeagueCopyWith<$Res> {
  factory _$LeagueCopyWith(_League value, $Res Function(_League) _then) = __$LeagueCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? orgSyncId, Organization? organization, String name, DateTime startDate, DateTime endDate, Division division, int boutDays
});


@override $OrganizationCopyWith<$Res>? get organization;@override $DivisionCopyWith<$Res> get division;

}
/// @nodoc
class __$LeagueCopyWithImpl<$Res>
    implements _$LeagueCopyWith<$Res> {
  __$LeagueCopyWithImpl(this._self, this._then);

  final _League _self;
  final $Res Function(_League) _then;

/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? orgSyncId = freezed,Object? organization = freezed,Object? name = null,Object? startDate = null,Object? endDate = null,Object? division = null,Object? boutDays = null,}) {
  return _then(_League(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,orgSyncId: freezed == orgSyncId ? _self.orgSyncId : orgSyncId // ignore: cast_nullable_to_non_nullable
as String?,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as Organization?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as Division,boutDays: null == boutDays ? _self.boutDays : boutDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizationCopyWith<$Res>? get organization {
    if (_self.organization == null) {
    return null;
  }

  return $OrganizationCopyWith<$Res>(_self.organization!, (value) {
    return _then(_self.copyWith(organization: value));
  });
}/// Create a copy of League
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DivisionCopyWith<$Res> get division {
  
  return $DivisionCopyWith<$Res>(_self.division, (value) {
    return _then(_self.copyWith(division: value));
  });
}
}

// dart format on
