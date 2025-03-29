// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_mode_affiliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionModeAffiliation {
  int? get id;
  Competition get competition;
  CompetitionMode get competitionMode;
  int? get maxContestants;

  /// Create a copy of CompetitionModeAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionModeAffiliationCopyWith<CompetitionModeAffiliation>
      get copyWith =>
          _$CompetitionModeAffiliationCopyWithImpl<CompetitionModeAffiliation>(
              this as CompetitionModeAffiliation, _$identity);

  /// Serializes this CompetitionModeAffiliation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompetitionModeAffiliation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.competitionMode, competitionMode) ||
                other.competitionMode == competitionMode) &&
            (identical(other.maxContestants, maxContestants) ||
                other.maxContestants == maxContestants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, competition, competitionMode, maxContestants);

  @override
  String toString() {
    return 'CompetitionModeAffiliation(id: $id, competition: $competition, competitionMode: $competitionMode, maxContestants: $maxContestants)';
  }
}

/// @nodoc
abstract mixin class $CompetitionModeAffiliationCopyWith<$Res> {
  factory $CompetitionModeAffiliationCopyWith(CompetitionModeAffiliation value,
          $Res Function(CompetitionModeAffiliation) _then) =
      _$CompetitionModeAffiliationCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      Competition competition,
      CompetitionMode competitionMode,
      int? maxContestants});

  $CompetitionCopyWith<$Res> get competition;
}

/// @nodoc
class _$CompetitionModeAffiliationCopyWithImpl<$Res>
    implements $CompetitionModeAffiliationCopyWith<$Res> {
  _$CompetitionModeAffiliationCopyWithImpl(this._self, this._then);

  final CompetitionModeAffiliation _self;
  final $Res Function(CompetitionModeAffiliation) _then;

  /// Create a copy of CompetitionModeAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? competitionMode = null,
    Object? maxContestants = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      competitionMode: null == competitionMode
          ? _self.competitionMode
          : competitionMode // ignore: cast_nullable_to_non_nullable
              as CompetitionMode,
      maxContestants: freezed == maxContestants
          ? _self.maxContestants
          : maxContestants // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of CompetitionModeAffiliation
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
class _CompetitionModeAffiliation extends CompetitionModeAffiliation {
  const _CompetitionModeAffiliation(
      {this.id,
      required this.competition,
      required this.competitionMode,
      this.maxContestants})
      : super._();
  factory _CompetitionModeAffiliation.fromJson(Map<String, dynamic> json) =>
      _$CompetitionModeAffiliationFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final CompetitionMode competitionMode;
  @override
  final int? maxContestants;

  /// Create a copy of CompetitionModeAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionModeAffiliationCopyWith<_CompetitionModeAffiliation>
      get copyWith => __$CompetitionModeAffiliationCopyWithImpl<
          _CompetitionModeAffiliation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionModeAffiliationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompetitionModeAffiliation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.competitionMode, competitionMode) ||
                other.competitionMode == competitionMode) &&
            (identical(other.maxContestants, maxContestants) ||
                other.maxContestants == maxContestants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, competition, competitionMode, maxContestants);

  @override
  String toString() {
    return 'CompetitionModeAffiliation(id: $id, competition: $competition, competitionMode: $competitionMode, maxContestants: $maxContestants)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionModeAffiliationCopyWith<$Res>
    implements $CompetitionModeAffiliationCopyWith<$Res> {
  factory _$CompetitionModeAffiliationCopyWith(
          _CompetitionModeAffiliation value,
          $Res Function(_CompetitionModeAffiliation) _then) =
      __$CompetitionModeAffiliationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      Competition competition,
      CompetitionMode competitionMode,
      int? maxContestants});

  @override
  $CompetitionCopyWith<$Res> get competition;
}

/// @nodoc
class __$CompetitionModeAffiliationCopyWithImpl<$Res>
    implements _$CompetitionModeAffiliationCopyWith<$Res> {
  __$CompetitionModeAffiliationCopyWithImpl(this._self, this._then);

  final _CompetitionModeAffiliation _self;
  final $Res Function(_CompetitionModeAffiliation) _then;

  /// Create a copy of CompetitionModeAffiliation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? competitionMode = null,
    Object? maxContestants = freezed,
  }) {
    return _then(_CompetitionModeAffiliation(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      competitionMode: null == competitionMode
          ? _self.competitionMode
          : competitionMode // ignore: cast_nullable_to_non_nullable
              as CompetitionMode,
      maxContestants: freezed == maxContestants
          ? _self.maxContestants
          : maxContestants // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of CompetitionModeAffiliation
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
