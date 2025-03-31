// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition_weight_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompetitionWeightCategory {
  int? get id;
  WeightClass get weightClass;
  AgeCategory get ageCategory;
  Competition get competition;

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompetitionWeightCategoryCopyWith<CompetitionWeightCategory> get copyWith =>
      _$CompetitionWeightCategoryCopyWithImpl<CompetitionWeightCategory>(
          this as CompetitionWeightCategory, _$identity);

  /// Serializes this CompetitionWeightCategory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompetitionWeightCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.ageCategory, ageCategory) ||
                other.ageCategory == ageCategory) &&
            (identical(other.competition, competition) ||
                other.competition == competition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, weightClass, ageCategory, competition);

  @override
  String toString() {
    return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, ageCategory: $ageCategory, competition: $competition)';
  }
}

/// @nodoc
abstract mixin class $CompetitionWeightCategoryCopyWith<$Res> {
  factory $CompetitionWeightCategoryCopyWith(CompetitionWeightCategory value,
          $Res Function(CompetitionWeightCategory) _then) =
      _$CompetitionWeightCategoryCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      WeightClass weightClass,
      AgeCategory ageCategory,
      Competition competition});

  $WeightClassCopyWith<$Res> get weightClass;
  $AgeCategoryCopyWith<$Res> get ageCategory;
  $CompetitionCopyWith<$Res> get competition;
}

/// @nodoc
class _$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements $CompetitionWeightCategoryCopyWith<$Res> {
  _$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final CompetitionWeightCategory _self;
  final $Res Function(CompetitionWeightCategory) _then;

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? weightClass = null,
    Object? ageCategory = null,
    Object? competition = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      weightClass: null == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      ageCategory: null == ageCategory
          ? _self.ageCategory
          : ageCategory // ignore: cast_nullable_to_non_nullable
              as AgeCategory,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
    ));
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgeCategoryCopyWith<$Res> get ageCategory {
    return $AgeCategoryCopyWith<$Res>(_self.ageCategory, (value) {
      return _then(_self.copyWith(ageCategory: value));
    });
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CompetitionWeightCategory extends CompetitionWeightCategory {
  const _CompetitionWeightCategory(
      {this.id,
      required this.weightClass,
      required this.ageCategory,
      required this.competition})
      : super._();
  factory _CompetitionWeightCategory.fromJson(Map<String, dynamic> json) =>
      _$CompetitionWeightCategoryFromJson(json);

  @override
  final int? id;
  @override
  final WeightClass weightClass;
  @override
  final AgeCategory ageCategory;
  @override
  final Competition competition;

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompetitionWeightCategoryCopyWith<_CompetitionWeightCategory>
      get copyWith =>
          __$CompetitionWeightCategoryCopyWithImpl<_CompetitionWeightCategory>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CompetitionWeightCategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompetitionWeightCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weightClass, weightClass) ||
                other.weightClass == weightClass) &&
            (identical(other.ageCategory, ageCategory) ||
                other.ageCategory == ageCategory) &&
            (identical(other.competition, competition) ||
                other.competition == competition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, weightClass, ageCategory, competition);

  @override
  String toString() {
    return 'CompetitionWeightCategory(id: $id, weightClass: $weightClass, ageCategory: $ageCategory, competition: $competition)';
  }
}

/// @nodoc
abstract mixin class _$CompetitionWeightCategoryCopyWith<$Res>
    implements $CompetitionWeightCategoryCopyWith<$Res> {
  factory _$CompetitionWeightCategoryCopyWith(_CompetitionWeightCategory value,
          $Res Function(_CompetitionWeightCategory) _then) =
      __$CompetitionWeightCategoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      WeightClass weightClass,
      AgeCategory ageCategory,
      Competition competition});

  @override
  $WeightClassCopyWith<$Res> get weightClass;
  @override
  $AgeCategoryCopyWith<$Res> get ageCategory;
  @override
  $CompetitionCopyWith<$Res> get competition;
}

/// @nodoc
class __$CompetitionWeightCategoryCopyWithImpl<$Res>
    implements _$CompetitionWeightCategoryCopyWith<$Res> {
  __$CompetitionWeightCategoryCopyWithImpl(this._self, this._then);

  final _CompetitionWeightCategory _self;
  final $Res Function(_CompetitionWeightCategory) _then;

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? weightClass = null,
    Object? ageCategory = null,
    Object? competition = null,
  }) {
    return _then(_CompetitionWeightCategory(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      weightClass: null == weightClass
          ? _self.weightClass
          : weightClass // ignore: cast_nullable_to_non_nullable
              as WeightClass,
      ageCategory: null == ageCategory
          ? _self.ageCategory
          : ageCategory // ignore: cast_nullable_to_non_nullable
              as AgeCategory,
      competition: null == competition
          ? _self.competition
          : competition // ignore: cast_nullable_to_non_nullable
              as Competition,
    ));
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WeightClassCopyWith<$Res> get weightClass {
    return $WeightClassCopyWith<$Res>(_self.weightClass, (value) {
      return _then(_self.copyWith(weightClass: value));
    });
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgeCategoryCopyWith<$Res> get ageCategory {
    return $AgeCategoryCopyWith<$Res>(_self.ageCategory, (value) {
      return _then(_self.copyWith(ageCategory: value));
    });
  }

  /// Create a copy of CompetitionWeightCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompetitionCopyWith<$Res> get competition {
    return $CompetitionCopyWith<$Res>(_self.competition, (value) {
      return _then(_self.copyWith(competition: value));
    });
  }
}

// dart format on
