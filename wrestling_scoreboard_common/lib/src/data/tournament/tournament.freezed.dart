// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return _Tournament.fromJson(json);
}

/// @nodoc
mixin _$Tournament {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  BoutConfig get boutConfig => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get no => throw _privateConstructorUsedError;
  int? get visitorsCount => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentCopyWith<Tournament> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentCopyWith<$Res> {
  factory $TournamentCopyWith(
          Tournament value, $Res Function(Tournament) then) =
      _$TournamentCopyWithImpl<$Res, Tournament>;
  @useResult
  $Res call(
      {int? id,
      String name,
      BoutConfig boutConfig,
      String? location,
      DateTime date,
      String? no,
      int? visitorsCount,
      String? comment});

  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class _$TournamentCopyWithImpl<$Res, $Val extends Tournament>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? boutConfig = null,
    Object? location = freezed,
    Object? date = null,
    Object? no = freezed,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoutConfigCopyWith<$Res> get boutConfig {
    return $BoutConfigCopyWith<$Res>(_value.boutConfig, (value) {
      return _then(_value.copyWith(boutConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TournamentImplCopyWith<$Res>
    implements $TournamentCopyWith<$Res> {
  factory _$$TournamentImplCopyWith(
          _$TournamentImpl value, $Res Function(_$TournamentImpl) then) =
      __$$TournamentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String name,
      BoutConfig boutConfig,
      String? location,
      DateTime date,
      String? no,
      int? visitorsCount,
      String? comment});

  @override
  $BoutConfigCopyWith<$Res> get boutConfig;
}

/// @nodoc
class __$$TournamentImplCopyWithImpl<$Res>
    extends _$TournamentCopyWithImpl<$Res, _$TournamentImpl>
    implements _$$TournamentImplCopyWith<$Res> {
  __$$TournamentImplCopyWithImpl(
      _$TournamentImpl _value, $Res Function(_$TournamentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? boutConfig = null,
    Object? location = freezed,
    Object? date = null,
    Object? no = freezed,
    Object? visitorsCount = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$TournamentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      boutConfig: null == boutConfig
          ? _value.boutConfig
          : boutConfig // ignore: cast_nullable_to_non_nullable
              as BoutConfig,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorsCount: freezed == visitorsCount
          ? _value.visitorsCount
          : visitorsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentImpl extends _Tournament {
  const _$TournamentImpl(
      {this.id,
      required this.name,
      required this.boutConfig,
      this.location,
      required this.date,
      this.no,
      this.visitorsCount,
      this.comment})
      : super._();

  factory _$TournamentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final BoutConfig boutConfig;
  @override
  final String? location;
  @override
  final DateTime date;
  @override
  final String? no;
  @override
  final int? visitorsCount;
  @override
  final String? comment;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, boutConfig: $boutConfig, location: $location, date: $date, no: $no, visitorsCount: $visitorsCount, comment: $comment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.boutConfig, boutConfig) ||
                other.boutConfig == boutConfig) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.no, no) || other.no == no) &&
            (identical(other.visitorsCount, visitorsCount) ||
                other.visitorsCount == visitorsCount) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, boutConfig, location,
      date, no, visitorsCount, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      __$$TournamentImplCopyWithImpl<_$TournamentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentImplToJson(
      this,
    );
  }
}

abstract class _Tournament extends Tournament {
  const factory _Tournament(
      {final int? id,
      required final String name,
      required final BoutConfig boutConfig,
      final String? location,
      required final DateTime date,
      final String? no,
      final int? visitorsCount,
      final String? comment}) = _$TournamentImpl;
  const _Tournament._() : super._();

  factory _Tournament.fromJson(Map<String, dynamic> json) =
      _$TournamentImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  BoutConfig get boutConfig;
  @override
  String? get location;
  @override
  DateTime get date;
  @override
  String? get no;
  @override
  int? get visitorsCount;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
