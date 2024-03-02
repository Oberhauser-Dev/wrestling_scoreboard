// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantState _$ParticipantStateFromJson(Map<String, dynamic> json) {
  return _ParticipantState.fromJson(json);
}

/// @nodoc
mixin _$ParticipantState {
  int? get id => throw _privateConstructorUsedError;
  Participation get participation => throw _privateConstructorUsedError;
  int? get classificationPoints => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipantStateCopyWith<ParticipantState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantStateCopyWith<$Res> {
  factory $ParticipantStateCopyWith(ParticipantState value, $Res Function(ParticipantState) then) =
      _$ParticipantStateCopyWithImpl<$Res, ParticipantState>;
  @useResult
  $Res call({int? id, Participation participation, int? classificationPoints});

  $ParticipationCopyWith<$Res> get participation;
}

/// @nodoc
class _$ParticipantStateCopyWithImpl<$Res, $Val extends ParticipantState> implements $ParticipantStateCopyWith<$Res> {
  _$ParticipantStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? participation = null,
    Object? classificationPoints = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      participation: null == participation
          ? _value.participation
          : participation // ignore: cast_nullable_to_non_nullable
              as Participation,
      classificationPoints: freezed == classificationPoints
          ? _value.classificationPoints
          : classificationPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ParticipationCopyWith<$Res> get participation {
    return $ParticipationCopyWith<$Res>(_value.participation, (value) {
      return _then(_value.copyWith(participation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParticipantStateImplCopyWith<$Res> implements $ParticipantStateCopyWith<$Res> {
  factory _$$ParticipantStateImplCopyWith(_$ParticipantStateImpl value, $Res Function(_$ParticipantStateImpl) then) =
      __$$ParticipantStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Participation participation, int? classificationPoints});

  @override
  $ParticipationCopyWith<$Res> get participation;
}

/// @nodoc
class __$$ParticipantStateImplCopyWithImpl<$Res> extends _$ParticipantStateCopyWithImpl<$Res, _$ParticipantStateImpl>
    implements _$$ParticipantStateImplCopyWith<$Res> {
  __$$ParticipantStateImplCopyWithImpl(_$ParticipantStateImpl _value, $Res Function(_$ParticipantStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? participation = null,
    Object? classificationPoints = freezed,
  }) {
    return _then(_$ParticipantStateImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      participation: null == participation
          ? _value.participation
          : participation // ignore: cast_nullable_to_non_nullable
              as Participation,
      classificationPoints: freezed == classificationPoints
          ? _value.classificationPoints
          : classificationPoints // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantStateImpl extends _ParticipantState {
  const _$ParticipantStateImpl({this.id, required this.participation, this.classificationPoints}) : super._();

  factory _$ParticipantStateImpl.fromJson(Map<String, dynamic> json) => _$$ParticipantStateImplFromJson(json);

  @override
  final int? id;
  @override
  final Participation participation;
  @override
  final int? classificationPoints;

  @override
  String toString() {
    return 'ParticipantState(id: $id, participation: $participation, classificationPoints: $classificationPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.participation, participation) || other.participation == participation) &&
            (identical(other.classificationPoints, classificationPoints) ||
                other.classificationPoints == classificationPoints));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, participation, classificationPoints);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantStateImplCopyWith<_$ParticipantStateImpl> get copyWith =>
      __$$ParticipantStateImplCopyWithImpl<_$ParticipantStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantStateImplToJson(
      this,
    );
  }
}

abstract class _ParticipantState extends ParticipantState {
  const factory _ParticipantState(
      {final int? id,
      required final Participation participation,
      final int? classificationPoints}) = _$ParticipantStateImpl;
  const _ParticipantState._() : super._();

  factory _ParticipantState.fromJson(Map<String, dynamic> json) = _$ParticipantStateImpl.fromJson;

  @override
  int? get id;
  @override
  Participation get participation;
  @override
  int? get classificationPoints;
  @override
  @JsonKey(ignore: true)
  _$$ParticipantStateImplCopyWith<_$ParticipantStateImpl> get copyWith => throw _privateConstructorUsedError;
}
