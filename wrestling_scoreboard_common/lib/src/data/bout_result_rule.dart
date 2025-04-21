import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'bout_result_rule.freezed.dart';
part 'bout_result_rule.g.dart';

@freezed
abstract class BoutResultRule with _$BoutResultRule implements DataObject {
  const BoutResultRule._();

  const factory BoutResultRule({
    int? id,
    required BoutConfig boutConfig,
    required BoutResult boutResult,
    WrestlingStyle? style,
    // Minimum points, the winner must have to fulfill this rule
    int? winnerTechnicalPoints,
    // Minimum points, the loser must have to fulfill this rule
    int? loserTechnicalPoints,
    int? technicalPointsDifference,
    required int winnerClassificationPoints,
    required int loserClassificationPoints,
  }) = _BoutResultRule;

  @override
  BoutResultRule copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override

  @override
  String get tableName => cTableName;
  static const cTableName = 'bout_result_rule';

  factory BoutResultRule.fromJson(Map<String, Object?> json) => _$BoutResultRuleFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'bout_config_id': boutConfig.id,
      'bout_result': boutResult.name,
      'winner_technical_points': winnerTechnicalPoints,
      'loser_technical_points': loserTechnicalPoints,
      'technical_points_difference': technicalPointsDifference,
      'winner_classification_points': winnerClassificationPoints,
      'loser_classification_points': loserClassificationPoints,
    };
  }

  static Future<BoutResultRule> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      BoutResultRule(
        id: e['id'] as int?,
        boutConfig: (await getSingle<BoutConfig>(e['bout_config_id'] as int)),
        boutResult: BoutResult.values.byName(e['bout_result']),
        winnerTechnicalPoints: e['winner_technical_points'] as int?,
        loserTechnicalPoints: e['loser_technical_points'] as int?,
        technicalPointsDifference: e['technical_points_difference'] as int?,
        winnerClassificationPoints: e['winner_classification_points'] as int,
        loserClassificationPoints: e['loser_classification_points'] as int,
      );
}
