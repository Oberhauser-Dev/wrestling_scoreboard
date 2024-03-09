// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Organization _$OrganizationFromJson(Map<String, dynamic> json) {
  return _Organization.fromJson(json);
}

/// @nodoc
mixin _$Organization {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get abbreviation => throw _privateConstructorUsedError;
  Organization? get parent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationCopyWith<Organization> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationCopyWith<$Res> {
  factory $OrganizationCopyWith(Organization value, $Res Function(Organization) then) =
      _$OrganizationCopyWithImpl<$Res, Organization>;
  @useResult
  $Res call({int? id, String name, String? abbreviation, Organization? parent});

  $OrganizationCopyWith<$Res>? get parent;
}

/// @nodoc
class _$OrganizationCopyWithImpl<$Res, $Val extends Organization> implements $OrganizationCopyWith<$Res> {
  _$OrganizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? abbreviation = freezed,
    Object? parent = freezed,
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
      abbreviation: freezed == abbreviation
          ? _value.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as Organization?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $OrganizationCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationImplCopyWith<$Res> implements $OrganizationCopyWith<$Res> {
  factory _$$OrganizationImplCopyWith(_$OrganizationImpl value, $Res Function(_$OrganizationImpl) then) =
      __$$OrganizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String name, String? abbreviation, Organization? parent});

  @override
  $OrganizationCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$OrganizationImplCopyWithImpl<$Res> extends _$OrganizationCopyWithImpl<$Res, _$OrganizationImpl>
    implements _$$OrganizationImplCopyWith<$Res> {
  __$$OrganizationImplCopyWithImpl(_$OrganizationImpl _value, $Res Function(_$OrganizationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? abbreviation = freezed,
    Object? parent = freezed,
  }) {
    return _then(_$OrganizationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      abbreviation: freezed == abbreviation
          ? _value.abbreviation
          : abbreviation // ignore: cast_nullable_to_non_nullable
              as String?,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as Organization?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationImpl extends _Organization {
  const _$OrganizationImpl({this.id, required this.name, this.abbreviation, this.parent}) : super._();

  factory _$OrganizationImpl.fromJson(Map<String, dynamic> json) => _$$OrganizationImplFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? abbreviation;
  @override
  final Organization? parent;

  @override
  String toString() {
    return 'Organization(id: $id, name: $name, abbreviation: $abbreviation, parent: $parent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.abbreviation, abbreviation) || other.abbreviation == abbreviation) &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, abbreviation, parent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationImplCopyWith<_$OrganizationImpl> get copyWith =>
      __$$OrganizationImplCopyWithImpl<_$OrganizationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationImplToJson(
      this,
    );
  }
}

abstract class _Organization extends Organization {
  const factory _Organization(
      {final int? id,
      required final String name,
      final String? abbreviation,
      final Organization? parent}) = _$OrganizationImpl;
  const _Organization._() : super._();

  factory _Organization.fromJson(Map<String, dynamic> json) = _$OrganizationImpl.fromJson;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get abbreviation;
  @override
  Organization? get parent;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationImplCopyWith<_$OrganizationImpl> get copyWith => throw _privateConstructorUsedError;
}
