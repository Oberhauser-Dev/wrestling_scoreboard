// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fight_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FightAction _$FightActionFromJson(Map<String, dynamic> json) {
  return _FightAction.fromJson(json);
}

/// @nodoc
mixin _$FightAction {
  int? get id => throw _privateConstructorUsedError;
  FightActionType get actionType => throw _privateConstructorUsedError;
  Fight get fight => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  FightRole get role => throw _privateConstructorUsedError;
  int? get pointCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FightActionCopyWith<FightAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FightActionCopyWith<$Res> {
  factory $FightActionCopyWith(
          FightAction value, $Res Function(FightAction) then) =
      _$FightActionCopyWithImpl<$Res, FightAction>;
  @useResult
  $Res call(
      {int? id,
      FightActionType actionType,
      Fight fight,
      Duration duration,
      FightRole role,
      int? pointCount});

  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class _$FightActionCopyWithImpl<$Res, $Val extends FightAction>
    implements $FightActionCopyWith<$Res> {
  _$FightActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? fight = null,
    Object? duration = null,
    Object? role = null,
    Object? pointCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as FightActionType,
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as FightRole,
      pointCount: freezed == pointCount
          ? _value.pointCount
          : pointCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FightCopyWith<$Res> get fight {
    return $FightCopyWith<$Res>(_value.fight, (value) {
      return _then(_value.copyWith(fight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FightActionImplCopyWith<$Res>
    implements $FightActionCopyWith<$Res> {
  factory _$$FightActionImplCopyWith(
          _$FightActionImpl value, $Res Function(_$FightActionImpl) then) =
      __$$FightActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      FightActionType actionType,
      Fight fight,
      Duration duration,
      FightRole role,
      int? pointCount});

  @override
  $FightCopyWith<$Res> get fight;
}

/// @nodoc
class __$$FightActionImplCopyWithImpl<$Res>
    extends _$FightActionCopyWithImpl<$Res, _$FightActionImpl>
    implements _$$FightActionImplCopyWith<$Res> {
  __$$FightActionImplCopyWithImpl(
      _$FightActionImpl _value, $Res Function(_$FightActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? fight = null,
    Object? duration = null,
    Object? role = null,
    Object? pointCount = freezed,
  }) {
    return _then(_$FightActionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as FightActionType,
      fight: null == fight
          ? _value.fight
          : fight // ignore: cast_nullable_to_non_nullable
              as Fight,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as FightRole,
      pointCount: freezed == pointCount
          ? _value.pointCount
          : pointCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FightActionImpl extends _FightAction {
  const _$FightActionImpl(
      {this.id,
      required this.actionType,
      required this.fight,
      required this.duration,
      required this.role,
      this.pointCount})
      : super._();

  factory _$FightActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FightActionImplFromJson(json);

  @override
  final int? id;
  @override
  final FightActionType actionType;
  @override
  final Fight fight;
  @override
  final Duration duration;
  @override
  final FightRole role;
  @override
  final int? pointCount;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FightActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.fight, fight) || other.fight == fight) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.pointCount, pointCount) ||
                other.pointCount == pointCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, actionType, fight, duration, role, pointCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FightActionImplCopyWith<_$FightActionImpl> get copyWith =>
      __$$FightActionImplCopyWithImpl<_$FightActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FightActionImplToJson(
      this,
    );
  }
}

abstract class _FightAction extends FightAction {
  const factory _FightAction(
      {final int? id,
      required final FightActionType actionType,
      required final Fight fight,
      required final Duration duration,
      required final FightRole role,
      final int? pointCount}) = _$FightActionImpl;
  const _FightAction._() : super._();

  factory _FightAction.fromJson(Map<String, dynamic> json) =
      _$FightActionImpl.fromJson;

  @override
  int? get id;
  @override
  FightActionType get actionType;
  @override
  Fight get fight;
  @override
  Duration get duration;
  @override
  FightRole get role;
  @override
  int? get pointCount;
  @override
  @JsonKey(ignore: true)
  _$$FightActionImplCopyWith<_$FightActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
