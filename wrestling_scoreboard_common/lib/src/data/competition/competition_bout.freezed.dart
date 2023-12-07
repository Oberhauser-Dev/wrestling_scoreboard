// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CompetitionBout _$CompetitionBoutFromJson(Map<String, dynamic> json) {
  return _CompetitionBout.fromJson(json);
}

/// @nodoc
mixin _$CompetitionBout {
  int? get id => throw _privateConstructorUsedError;
  Competition get competition => throw _privateConstructorUsedError;
  Bout get bout => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompetitionBoutCopyWith<CompetitionBout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitionBoutCopyWith<$Res> {
  factory $CompetitionBoutCopyWith(
          CompetitionBout value, $Res Function(CompetitionBout) then) =
      _$CompetitionBoutCopyWithImpl<$Res, CompetitionBout>;
  @useResult
  $Res call({int? id, Competition competition, Bout bout});

  $CompetitionCopyWith<$Res> get competition;
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$CompetitionBoutCopyWithImpl<$Res, $Val extends CompetitionBout>
    implements $CompetitionBoutCopyWith<$Res> {
  _$CompetitionBoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? bout = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_value.competition, (value) {
      return _then(_value.copyWith(competition: value) as $Val);
    });
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
abstract class _$$CompetitionBoutImplCopyWith<$Res>
    implements $CompetitionBoutCopyWith<$Res> {
  factory _$$CompetitionBoutImplCopyWith(_$CompetitionBoutImpl value,
          $Res Function(_$CompetitionBoutImpl) then) =
      __$$CompetitionBoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, Competition competition, Bout bout});

  @override
  $CompetitionCopyWith<$Res> get competition;
  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$$CompetitionBoutImplCopyWithImpl<$Res>
    extends _$CompetitionBoutCopyWithImpl<$Res, _$CompetitionBoutImpl>
    implements _$$CompetitionBoutImplCopyWith<$Res> {
  __$$CompetitionBoutImplCopyWithImpl(
      _$CompetitionBoutImpl _value, $Res Function(_$CompetitionBoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? bout = null,
  }) {
    return _then(_$CompetitionBoutImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _value.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      bout: null == bout
          ? _value.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitionBoutImpl extends _CompetitionBout {
  const _$CompetitionBoutImpl(
      {this.id, required this.competition, required this.bout})
      : super._();

  factory _$CompetitionBoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitionBoutImplFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Bout bout;

  @override
  String toString() {
    return 'CompetitionBout(id: $id, competition: $competition, bout: $bout)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitionBoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, bout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitionBoutImplCopyWith<_$CompetitionBoutImpl> get copyWith =>
      __$$CompetitionBoutImplCopyWithImpl<_$CompetitionBoutImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitionBoutImplToJson(
      this,
    );
  }
}

abstract class _CompetitionBout extends CompetitionBout {
  const factory _CompetitionBout(
      {final int? id,
      required final Competition competition,
      required final Bout bout}) = _$CompetitionBoutImpl;
  const _CompetitionBout._() : super._();

  factory _CompetitionBout.fromJson(Map<String, dynamic> json) =
      _$CompetitionBoutImpl.fromJson;

  @override
  int? get id;
  @override
  Competition get competition;
  @override
  Bout get bout;
  @override
  @JsonKey(ignore: true)
  _$$CompetitionBoutImplCopyWith<_$CompetitionBoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
