// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bout_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BoutAction _$BoutActionFromJson(Map<String, dynamic> json) {
  return _BoutAction.fromJson(json);
}

/// @nodoc
mixin _$BoutAction {
  int? get id => throw _privateConstructorUsedError;
  BoutActionType get actionType => throw _privateConstructorUsedError;
  Bout get bout => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  BoutRole get role => throw _privateConstructorUsedError;
  int? get pointCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoutActionCopyWith<BoutAction> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoutActionCopyWith<$Res> {
  factory $BoutActionCopyWith(BoutAction value, $Res Function(BoutAction) then) =
      _$BoutActionCopyWithImpl<$Res, BoutAction>;
  @useResult
  $Res call({int? id, BoutActionType actionType, Bout bout, Duration duration, BoutRole role, int? pointCount});

  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$BoutActionCopyWithImpl<$Res, $Val extends BoutAction> implements $BoutActionCopyWith<$Res> {
  _$BoutActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? bout = null,
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
              as BoutActionType,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as BoutRole,
      pointCount: freezed == pointCount
          ? _value.pointCount
          : pointCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_value.bout, (value) {
      return _then(_value.copyWith(bout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoutActionImplCopyWith<$Res> implements $BoutActionCopyWith<$Res> {
  factory _$$BoutActionImplCopyWith(_$BoutActionImpl value, $Res Function(_$BoutActionImpl) then) =
      __$$BoutActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, BoutActionType actionType, Bout bout, Duration duration, BoutRole role, int? pointCount});

  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$$BoutActionImplCopyWithImpl<$Res> extends _$BoutActionCopyWithImpl<$Res, _$BoutActionImpl>
    implements _$$BoutActionImplCopyWith<$Res> {
  __$$BoutActionImplCopyWithImpl(_$BoutActionImpl _value, $Res Function(_$BoutActionImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? actionType = null,
    Object? bout = null,
    Object? duration = null,
    Object? role = null,
    Object? pointCount = freezed,
  }) {
    return _then(_$BoutActionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as BoutActionType,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as BoutRole,
      pointCount: freezed == pointCount
          ? _value.pointCount
          : pointCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoutActionImpl extends _BoutAction {
  const _$BoutActionImpl(
      {this.id,
      required this.actionType,
      required this.bout,
      required this.duration,
      required this.role,
      this.pointCount})
      : super._();

  factory _$BoutActionImpl.fromJson(Map<String, dynamic> json) => _$$BoutActionImplFromJson(json);

  @override
  final int? id;
  @override
  final BoutActionType actionType;
  @override
  final Bout bout;
  @override
  final Duration duration;
  @override
  final BoutRole role;
  @override
  final int? pointCount;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoutActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionType, actionType) || other.actionType == actionType) &&
            (identical(other.bout, bout) || other.bout == bout) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.pointCount, pointCount) || other.pointCount == pointCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, actionType, bout, duration, role, pointCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoutActionImplCopyWith<_$BoutActionImpl> get copyWith =>
      __$$BoutActionImplCopyWithImpl<_$BoutActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoutActionImplToJson(
      this,
    );
  }
}

abstract class _BoutAction extends BoutAction {
  const factory _BoutAction(
      {final int? id,
      required final BoutActionType actionType,
      required final Bout bout,
      required final Duration duration,
      required final BoutRole role,
      final int? pointCount}) = _$BoutActionImpl;
  const _BoutAction._() : super._();

  factory _BoutAction.fromJson(Map<String, dynamic> json) = _$BoutActionImpl.fromJson;

  @override
  int? get id;
  @override
  BoutActionType get actionType;
  @override
  Bout get bout;
  @override
  Duration get duration;
  @override
  BoutRole get role;
  @override
  int? get pointCount;
  @override
  @JsonKey(ignore: true)
  _$$BoutActionImplCopyWith<_$BoutActionImpl> get copyWith => throw _privateConstructorUsedError;
}
