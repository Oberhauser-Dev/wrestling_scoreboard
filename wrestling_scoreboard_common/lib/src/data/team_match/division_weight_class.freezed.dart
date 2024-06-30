// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'division_weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DivisionWeightClass _$DivisionWeightClassFromJson(Map<String, dynamic> json) {
  return _DivisionWeightClass.fromJson(json);
}

/// @nodoc
mixin _$DivisionWeightClass {
  int? get id => throw _privateConstructorUsedError;

  int get pos => throw _privateConstructorUsedError;

  Division get division => throw _privateConstructorUsedError;

  WeightClass get weightClass => throw _privateConstructorUsedError;

  int? get seasonPartition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DivisionWeightClassCopyWith<DivisionWeightClass> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DivisionWeightClassCopyWith<$Res> {
  factory $DivisionWeightClassCopyWith(DivisionWeightClass value, $Res Function(DivisionWeightClass) then) =
      _$DivisionWeightClassCopyWithImpl<$Res, DivisionWeightClass>;

  @useResult
  $Res call({int? id, int pos, Division division, WeightClass weightClass, int? seasonPartition});

  $DivisionCopyWith<$Res> get division;

  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class _$DivisionWeightClassCopyWithImpl<$Res, $Val extends DivisionWeightClass>
    implements $DivisionWeightClassCopyWith<$Res> {
  _$DivisionWeightClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pos = null,
    Object? division = null,
    Object? weightClass = null,
    Object? seasonPartition = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      division: null == division
          ? _value.division
          : division // ignore: cast_nullable_to_non_nullable
              as Division,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _value.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DivisionCopyWith<$Res> get division {
    return $DivisionCopyWith<$Res>(_value.division, (value) {
      return _then(_value.copyWith(division: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_value.weightClass, (value) {
      return _then(_value.copyWith(weightClass: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DivisionWeightClassImplCopyWith<$Res> implements $DivisionWeightClassCopyWith<$Res> {
  factory _$$DivisionWeightClassImplCopyWith(
          _$DivisionWeightClassImpl value, $Res Function(_$DivisionWeightClassImpl) then) =
      __$$DivisionWeightClassImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({int? id, int pos, Division division, WeightClass weightClass, int? seasonPartition});

  @override
  $DivisionCopyWith<$Res> get division;

  @override
  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class __$$DivisionWeightClassImplCopyWithImpl<$Res>
    extends _$DivisionWeightClassCopyWithImpl<$Res, _$DivisionWeightClassImpl>
    implements _$$DivisionWeightClassImplCopyWith<$Res> {
  __$$DivisionWeightClassImplCopyWithImpl(
      _$DivisionWeightClassImpl _value, $Res Function(_$DivisionWeightClassImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pos = null,
    Object? division = null,
    Object? weightClass = null,
    Object? seasonPartition = freezed,
  }) {
    return _then(_$DivisionWeightClassImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      division: null == division
          ? _value.division
          : division // ignore: cast_nullable_to_non_nullable
              as Division,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      seasonPartition: freezed == seasonPartition
          ? _value.seasonPartition
          : seasonPartition // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DivisionWeightClassImpl extends _DivisionWeightClass {
  const _$DivisionWeightClassImpl(
      {this.id, required this.pos, required this.division, required this.weightClass, this.seasonPartition})
      : super._();

  factory _$DivisionWeightClassImpl.fromJson(Map<String, dynamic> json) => _$$DivisionWeightClassImplFromJson(json);

  @override
  final int? id;
  @override
  final int pos;
  @override
  final Division division;
  @override
  final WeightClass weightClass;
  @override
  final int? seasonPartition;

  @override
  String toString() {
    return 'DivisionWeightClass(id: $id, pos: $pos, division: $division, weightClass: $weightClass, seasonPartition: $seasonPartition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DivisionWeightClassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.division, division) || other.division == division) &&
            (identical(other.weightClass, weightClass) || other.weightClass == weightClass) &&
            (identical(other.seasonPartition, seasonPartition) || other.seasonPartition == seasonPartition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, pos, division, weightClass, seasonPartition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DivisionWeightClassImplCopyWith<_$DivisionWeightClassImpl> get copyWith =>
      __$$DivisionWeightClassImplCopyWithImpl<_$DivisionWeightClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DivisionWeightClassImplToJson(
      this,
    );
  }
}

abstract class _DivisionWeightClass extends DivisionWeightClass {
  const factory _DivisionWeightClass(
      {final int? id,
      required final int pos,
      required final Division division,
      required final WeightClass weightClass,
      final int? seasonPartition}) = _$DivisionWeightClassImpl;

  const _DivisionWeightClass._() : super._();

  factory _DivisionWeightClass.fromJson(Map<String, dynamic> json) = _$DivisionWeightClassImpl.fromJson;

  @override
  int? get id;

  @override
  int get pos;

  @override
  Division get division;

  @override
  WeightClass get weightClass;

  @override
  int? get seasonPartition;

  @override
  @JsonKey(ignore: true)
  _$$DivisionWeightClassImplCopyWith<_$DivisionWeightClassImpl> get copyWith => throw _privateConstructorUsedError;
}
