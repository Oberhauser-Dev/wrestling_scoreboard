// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantState {
  int? get id;
  Participation get participation;
  int? get classificationPoints;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantStateCopyWith<ParticipantState> get copyWith =>
      _$ParticipantStateCopyWithImpl<ParticipantState>(this as ParticipantState, _$identity);

  /// Serializes this ParticipantState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantState &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.participation, participation) || other.participation == participation) &&
            (identical(other.classificationPoints, classificationPoints) ||
                other.classificationPoints == classificationPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, participation, classificationPoints);

  @override
  String toString() {
    return 'ParticipantState(id: $id, participation: $participation, classificationPoints: $classificationPoints)';
  }
}

/// @nodoc
abstract mixin class $ParticipantStateCopyWith<$Res> {
  factory $ParticipantStateCopyWith(ParticipantState value, $Res Function(ParticipantState) _then) =
      _$ParticipantStateCopyWithImpl;
  @useResult
  $Res call({int? id, Participation participation, int? classificationPoints});

  $ParticipationCopyWith<$Res> get participation;
}

/// @nodoc
class _$ParticipantStateCopyWithImpl<$Res> implements $ParticipantStateCopyWith<$Res> {
  _$ParticipantStateCopyWithImpl(this._self, this._then);

  final ParticipantState _self;
  final $Res Function(ParticipantState) _then;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? participation = null,
    Object? classificationPoints = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      participation: null == participation
          ? _self.participation
          : participation // ignore: cast_nullable_to_non_nullable
              as Participation,
      classificationPoints: freezed == classificationPoints
          ? _self.classificationPoints
          : classificationPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipationCopyWith<$Res> get participation {
    return $ParticipationCopyWith<$Res>(_self.participation, (value) {
      return _then(_self.copyWith(participation: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ParticipantState extends ParticipantState {
  const _ParticipantState({this.id, required this.participation, this.classificationPoints}) : super._();
  factory _ParticipantState.fromJson(Map<String, dynamic> json) => _$ParticipantStateFromJson(json);

  @override
  final int? id;
  @override
  final Participation participation;
  @override
  final int? classificationPoints;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantStateCopyWith<_ParticipantState> get copyWith =>
      __$ParticipantStateCopyWithImpl<_ParticipantState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipantStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantState &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.participation, participation) || other.participation == participation) &&
            (identical(other.classificationPoints, classificationPoints) ||
                other.classificationPoints == classificationPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, participation, classificationPoints);

  @override
  String toString() {
    return 'ParticipantState(id: $id, participation: $participation, classificationPoints: $classificationPoints)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantStateCopyWith<$Res> implements $ParticipantStateCopyWith<$Res> {
  factory _$ParticipantStateCopyWith(_ParticipantState value, $Res Function(_ParticipantState) _then) =
      __$ParticipantStateCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, Participation participation, int? classificationPoints});

  @override
  $ParticipationCopyWith<$Res> get participation;
}

/// @nodoc
class __$ParticipantStateCopyWithImpl<$Res> implements _$ParticipantStateCopyWith<$Res> {
  __$ParticipantStateCopyWithImpl(this._self, this._then);

  final _ParticipantState _self;
  final $Res Function(_ParticipantState) _then;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? participation = null,
    Object? classificationPoints = freezed,
  }) {
    return _then(_ParticipantState(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      participation: null == participation
          ? _self.participation
          : participation // ignore: cast_nullable_to_non_nullable
              as Participation,
      classificationPoints: freezed == classificationPoints
          ? _self.classificationPoints
          : classificationPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipationCopyWith<$Res> get participation {
    return $ParticipationCopyWith<$Res>(_self.participation, (value) {
      return _then(_self.copyWith(participation: value));
    });
  }
}

// dart format on
