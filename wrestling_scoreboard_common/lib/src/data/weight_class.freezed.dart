// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeightClass _$WeightClassFromJson(Map<String, dynamic> json) {
  return _WeightClass.fromJson(json);
}

/// @nodoc
mixin _$WeightClass {
  int? get id => throw _privateConstructorUsedError;
  int get weight => throw _privateConstructorUsedError;
  WrestlingStyle get style => throw _privateConstructorUsedError;
  String? get suffix => throw _privateConstructorUsedError;
  WeightUnit get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeightClassCopyWith<WeightClass> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightClassCopyWith<$Res> {
  factory $WeightClassCopyWith(WeightClass value, $Res Function(WeightClass) then) =
      _$WeightClassCopyWithImpl<$Res, WeightClass>;
  @useResult
  $Res call({int? id, int weight, WrestlingStyle style, String? suffix, WeightUnit unit});
}

/// @nodoc
class _$WeightClassCopyWithImpl<$Res, $Val extends WeightClass> implements $WeightClassCopyWith<$Res> {
  _$WeightClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? weight = null,
    Object? style = null,
    Object? suffix = freezed,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle,
      suffix: freezed == suffix
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightClassImplCopyWith<$Res> implements $WeightClassCopyWith<$Res> {
  factory _$$WeightClassImplCopyWith(_$WeightClassImpl value, $Res Function(_$WeightClassImpl) then) =
      __$$WeightClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, int weight, WrestlingStyle style, String? suffix, WeightUnit unit});
}

/// @nodoc
class __$$WeightClassImplCopyWithImpl<$Res> extends _$WeightClassCopyWithImpl<$Res, _$WeightClassImpl>
    implements _$$WeightClassImplCopyWith<$Res> {
  __$$WeightClassImplCopyWithImpl(_$WeightClassImpl _value, $Res Function(_$WeightClassImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? weight = null,
    Object? style = null,
    Object? suffix = freezed,
    Object? unit = null,
  }) {
    return _then(_$WeightClassImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as WrestlingStyle,
      suffix: freezed == suffix
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as WeightUnit,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightClassImpl extends _WeightClass {
  const _$WeightClassImpl(
      {this.id, required this.weight, required this.style, this.suffix, this.unit = WeightUnit.kilogram})
      : super._();

  factory _$WeightClassImpl.fromJson(Map<String, dynamic> json) => _$$WeightClassImplFromJson(json);

  @override
  final int? id;
  @override
  final int weight;
  @override
  final WrestlingStyle style;
  @override
  final String? suffix;
  @override
  @JsonKey()
  final WeightUnit unit;

  @override
  String toString() {
    return 'WeightClass(id: $id, weight: $weight, style: $style, suffix: $suffix, unit: $unit)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightClassImplCopyWith<_$WeightClassImpl> get copyWith =>
      __$$WeightClassImplCopyWithImpl<_$WeightClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightClassImplToJson(
      this,
    );
  }
}

abstract class _WeightClass extends WeightClass {
  const factory _WeightClass(
      {final int? id,
      required final int weight,
      required final WrestlingStyle style,
      final String? suffix,
      final WeightUnit unit}) = _$WeightClassImpl;
  const _WeightClass._() : super._();

  factory _WeightClass.fromJson(Map<String, dynamic> json) = _$WeightClassImpl.fromJson;

  @override
  int? get id;
  @override
  int get weight;
  @override
  WrestlingStyle get style;
  @override
  String? get suffix;
  @override
  WeightUnit get unit;
  @override
  @JsonKey(ignore: true)
  _$$WeightClassImplCopyWith<_$WeightClassImpl> get copyWith => throw _privateConstructorUsedError;
}
