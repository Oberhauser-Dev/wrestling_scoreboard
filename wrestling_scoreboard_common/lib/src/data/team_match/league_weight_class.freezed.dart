// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'league_weight_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LeagueWeightClass _$LeagueWeightClassFromJson(Map<String, dynamic> json) {
  return _LeagueWeightClass.fromJson(json);
}

/// @nodoc
mixin _$LeagueWeightClass {
  int? get id => throw _privateConstructorUsedError;
  int get pos => throw _privateConstructorUsedError;
  League get league => throw _privateConstructorUsedError;
  WeightClass get weightClass => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeagueWeightClassCopyWith<LeagueWeightClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueWeightClassCopyWith<$Res> {
  factory $LeagueWeightClassCopyWith(
          LeagueWeightClass value, $Res Function(LeagueWeightClass) then) =
      _$LeagueWeightClassCopyWithImpl<$Res, LeagueWeightClass>;
  @useResult
  $Res call({int? id, int pos, League league, WeightClass weightClass});

  $LeagueCopyWith<$Res> get league;
  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class _$LeagueWeightClassCopyWithImpl<$Res, $Val extends LeagueWeightClass>
    implements $LeagueWeightClassCopyWith<$Res> {
  _$LeagueWeightClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pos = null,
    Object? league = null,
    Object? weightClass = null,
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
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LeagueCopyWith<$Res> get league {
    return $LeagueCopyWith<$Res>(_value.league, (value) {
      return _then(_value.copyWith(league: value) as $Val);
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
abstract class _$$LeagueWeightClassImplCopyWith<$Res>
    implements $LeagueWeightClassCopyWith<$Res> {
  factory _$$LeagueWeightClassImplCopyWith(_$LeagueWeightClassImpl value,
          $Res Function(_$LeagueWeightClassImpl) then) =
      __$$LeagueWeightClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, int pos, League league, WeightClass weightClass});

  @override
  $LeagueCopyWith<$Res> get league;
  @override
  $WeightClassCopyWith<$Res> get weightClass;
}

/// @nodoc
class __$$LeagueWeightClassImplCopyWithImpl<$Res>
    extends _$LeagueWeightClassCopyWithImpl<$Res, _$LeagueWeightClassImpl>
    implements _$$LeagueWeightClassImplCopyWith<$Res> {
  __$$LeagueWeightClassImplCopyWithImpl(_$LeagueWeightClassImpl _value,
      $Res Function(_$LeagueWeightClassImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pos = null,
    Object? league = null,
    Object? weightClass = null,
  }) {
    return _then(_$LeagueWeightClassImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      pos: null == pos
          ? _value.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as int,
      league: null == league
          ? _value.league
          : league // ignore: cast_nullable_to_non_nullable
              as League,
      weightClass: null == weightClass
          ? _value.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueWeightClassImpl extends _LeagueWeightClass {
  const _$LeagueWeightClassImpl(
      {this.id,
      required this.pos,
      required this.league,
      required this.weightClass})
      : super._();

  factory _$LeagueWeightClassImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueWeightClassImplFromJson(json);

  @override
  final int? id;
  @override
  final int pos;
  @override
  final League league;
  @override
  final WeightClass weightClass;

  @override
  String toString() {
    return 'LeagueWeightClass(id: $id, pos: $pos, league: $league, weightClass: $weightClass)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueWeightClassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, pos, league, weightClass);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueWeightClassImplCopyWith<_$LeagueWeightClassImpl> get copyWith =>
      __$$LeagueWeightClassImplCopyWithImpl<_$LeagueWeightClassImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueWeightClassImplToJson(
      this,
    );
  }
}

abstract class _LeagueWeightClass extends LeagueWeightClass {
  const factory _LeagueWeightClass(
      {final int? id,
      required final int pos,
      required final League league,
      required final WeightClass weightClass}) = _$LeagueWeightClassImpl;
  const _LeagueWeightClass._() : super._();

  factory _LeagueWeightClass.fromJson(Map<String, dynamic> json) =
      _$LeagueWeightClassImpl.fromJson;

  @override
  int? get id;
  @override
  int get pos;
  @override
  League get league;
  @override
  WeightClass get weightClass;
  @override
  @JsonKey(ignore: true)
  _$$LeagueWeightClassImplCopyWith<_$LeagueWeightClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
