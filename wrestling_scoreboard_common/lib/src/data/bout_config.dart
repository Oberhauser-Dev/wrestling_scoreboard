import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'bout_config.freezed.dart';
part 'bout_config.g.dart';

/// The general configuration for a bout, e.g. in a team match or competition.
@freezed
class BoutConfig with _$BoutConfig implements DataObject {
  static const defaultPeriodDuration = Duration(minutes: 3);
  static const defaultBreakDuration = Duration(seconds: 30);
  static const defaultActivityDuration = Duration(seconds: 30);
  static const defaultInjuryDuration = Duration(minutes: 2);
  static const defaultBleedingInjuryDuration = Duration(minutes: 4);
  static const defaultPeriodCount = 2;

  const BoutConfig._();

  const factory BoutConfig({
    int? id,
    @Default(BoutConfig.defaultPeriodDuration) Duration periodDuration,
    @Default(BoutConfig.defaultBreakDuration) Duration breakDuration,
    Duration? activityDuration,
    Duration? injuryDuration,
    Duration? bleedingInjuryDuration,
    @Default(BoutConfig.defaultPeriodCount) int periodCount,
  }) = _BoutConfig;

  factory BoutConfig.fromJson(Map<String, Object?> json) => _$BoutConfigFromJson(json);

  static Future<BoutConfig> fromRaw(Map<String, dynamic> e) async {
    final periodSeconds = e['period_duration_secs'] as int?;
    final breakSeconds = e['break_duration_secs'] as int?;
    final activitySeconds = e['activity_duration_secs'] as int?;
    final injurySeconds = e['injury_duration_secs'] as int?;
    final bleedingInjurySeconds = e['bleeding_injury_duration_secs'] as int?;

    return BoutConfig(
      id: e['id'] as int?,
      periodDuration: periodSeconds != null ? Duration(seconds: periodSeconds) : defaultPeriodDuration,
      breakDuration: breakSeconds != null ? Duration(seconds: breakSeconds) : defaultBreakDuration,
      activityDuration: activitySeconds != null ? Duration(seconds: activitySeconds) : null,
      injuryDuration: injurySeconds != null ? Duration(seconds: injurySeconds) : null,
      bleedingInjuryDuration: bleedingInjurySeconds != null ? Duration(seconds: bleedingInjurySeconds) : null,
      periodCount: (e['period_count'] as int?) ?? defaultPeriodCount,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'period_duration_secs': periodDuration.inSeconds,
      'break_duration_secs': breakDuration.inSeconds,
      'activity_duration_secs': activityDuration?.inSeconds,
      'injury_duration_secs': injuryDuration?.inSeconds,
      'bleeding_injury_duration_secs': bleedingInjuryDuration?.inSeconds,
      'period_count': periodCount,
    };
  }

  @override
  String get tableName => 'bout_config';

  Duration get totalPeriodDuration => periodDuration * periodCount;

  @override
  BoutConfig copyWithId(int? id) {
    return copyWith(id: id);
  }

  static BoutResultRule? resultRule({
    required BoutResult result,
    required WrestlingStyle style,
    required int technicalPointsWinner,
    required int technicalPointsLoser,
    required List<BoutResultRule> rules,
  }) {
    final diff = technicalPointsWinner - technicalPointsLoser;
    final applyingRules = rules.where((rule) {
      final matchResult = rule.boutResult == result;
      final matchStyle = rule.style == null || rule.style == style;
      final matchDiff = rule.technicalPointsDifference == null ? true : diff >= rule.technicalPointsDifference!;
      final matchPointsLoser = technicalPointsLoser >= (rule.loserTechnicalPoints ?? 0);
      final matchPointsWinner = technicalPointsWinner >= (rule.winnerTechnicalPoints ?? 0);
      return matchResult && matchStyle && matchDiff && matchPointsLoser && matchPointsWinner;
    }).toList();
    if (applyingRules.isEmpty) {
      return null;
    }
    applyingRules.sort((a, b) {
      var pDiff = (a.technicalPointsDifference ?? 0) - (b.technicalPointsDifference ?? 0);
      if (pDiff != 0) return pDiff;
      pDiff = (a.loserTechnicalPoints ?? 0) - (b.loserTechnicalPoints ?? 0);
      if (pDiff != 0) return pDiff;
      pDiff = (a.winnerTechnicalPoints ?? 0) - (b.winnerTechnicalPoints ?? 0);
      if (pDiff != 0) return pDiff;
      throw Exception('Two rules with the same attributes $a and $b');
    });
    return applyingRules.last;
  }
}
