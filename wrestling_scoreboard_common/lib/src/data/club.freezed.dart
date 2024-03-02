// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Club _$ClubFromJson(Map<String, dynamic> json) {
  return _Club.fromJson(json);
}

/// @nodoc
mixin _$Club {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get no => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubCopyWith<Club> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubCopyWith<$Res> {
  factory $ClubCopyWith(Club value, $Res Function(Club) then) = _$ClubCopyWithImpl<$Res, Club>;
  @useResult
  $Res call({int? id, String name, String? no});
}

/// @nodoc
class _$ClubCopyWithImpl<$Res, $Val extends Club> implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? no = freezed,
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
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubImplCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$$ClubImplCopyWith(_$ClubImpl value, $Res Function(_$ClubImpl) then) = __$$ClubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String name, String? no});
}

/// @nodoc
class __$$ClubImplCopyWithImpl<$Res> extends _$ClubCopyWithImpl<$Res, _$ClubImpl> implements _$$ClubImplCopyWith<$Res> {
  __$$ClubImplCopyWithImpl(_$ClubImpl _value, $Res Function(_$ClubImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? no = freezed,
  }) {
    return _then(_$ClubImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      no: freezed == no
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubImpl extends _Club {
  const _$ClubImpl({this.id, required this.name, this.no}) : super._();

  factory _$ClubImpl.fromJson(Map<String, dynamic> json) => _$$ClubImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? no;

  @override
  String toString() {
    return 'Club(id: $id, name: $name, no: $no)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.no, no) || other.no == no));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, no);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith => __$$ClubImplCopyWithImpl<_$ClubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubImplToJson(
      this,
    );
  }
}

abstract class _Club extends Club {
  const factory _Club({final int? id, required final String name, final String? no}) = _$ClubImpl;
  const _Club._() : super._();

  factory _Club.fromJson(Map<String, dynamic> json) = _$ClubImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get no;
  @override
  @JsonKey(ignore: true)
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith => throw _privateConstructorUsedError;
}
