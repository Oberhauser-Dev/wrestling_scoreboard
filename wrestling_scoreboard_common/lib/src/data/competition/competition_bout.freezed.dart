// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_bout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionBout {
  int? get id;
  Competition get competition;
  Bout get bout;

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionBoutCopyWith<CompetitionBout> get copyWith =>
      _$CompetitionBoutCopyWithImpl<CompetitionBout>(
          this as CompetitionBout, _$identity);

  /// Serializes this CompetitionBout to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompetitionBout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, bout);

  @override
  String toString() {
    return 'CompetitionBout(id: $id, competition: $competition, bout: $bout)';
  }
}

/// @nodoc
abstract mixin class $CompetitionBoutCopyWith<$Res> {
  factory $CompetitionBoutCopyWith(
          CompetitionBout value, $Res Function(CompetitionBout) _then) =
      _$CompetitionBoutCopyWithImpl;
  @useResult
  $Res call({int? id, Competition competition, Bout bout});

  $CompetitionCopyWith<$Res> get competition;
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class _$CompetitionBoutCopyWithImpl<$Res>
    implements $CompetitionBoutCopyWith<$Res> {
  _$CompetitionBoutCopyWithImpl(this._self, this._then);

  final CompetitionBout _self;
  final $Res Function(CompetitionBout) _then;

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? bout = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      bout: null == bout
          ? _self.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_self.bout, (value) {
      return _then(_self.copyWith(bout: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CompetitionBout extends CompetitionBout {
  const _CompetitionBout(
      {this.id, required this.competition, required this.bout})
      : super._();
  factory _CompetitionBout.fromJson(Map<String, dynamic> json) =>
      _$CompetitionBoutFromJson(json);

  @override
  final int? id;
  @override
  final Competition competition;
  @override
  final Bout bout;

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionBoutCopyWith<_CompetitionBout> get copyWith =>
      __$CompetitionBoutCopyWithImpl<_CompetitionBout>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionBoutToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompetitionBout &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.competition, competition) ||
                other.competition == competition) &&
            (identical(other.bout, bout) || other.bout == bout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, competition, bout);

  @override
  String toString() {
    return 'CompetitionBout(id: $id, competition: $competition, bout: $bout)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionBoutCopyWith<$Res>
    implements $CompetitionBoutCopyWith<$Res> {
  factory _$CompetitionBoutCopyWith(
          _CompetitionBout value, $Res Function(_CompetitionBout) _then) =
      __$CompetitionBoutCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, Competition competition, Bout bout});

  @override
  $CompetitionCopyWith<$Res> get competition;
  @override
  $BoutCopyWith<$Res> get bout;
}

/// @nodoc
class __$CompetitionBoutCopyWithImpl<$Res>
    implements _$CompetitionBoutCopyWith<$Res> {
  __$CompetitionBoutCopyWithImpl(this._self, this._then);

  final _CompetitionBout _self;
  final $Res Function(_CompetitionBout) _then;

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? competition = null,
    Object? bout = null,
  }) {
    return _then(_CompetitionBout(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
      bout: null == bout
          ? _self.bout
          : bout // ignore: cast_nullable_to_non_nullable
              as Bout,
    ));
  }

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }

  /// Create a copy of CompetitionBout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoutCopyWith<$Res> get bout {
    return $BoutCopyWith<$Res>(_self.bout, (value) {
      return _then(_self.copyWith(bout: value));
    });
  }
}

// dart format on
