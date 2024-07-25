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
  static const defaultPeriodCount = 2;

  const BoutConfig._();

  const factory BoutConfig({
    int? id,
    @Default(BoutConfig.defaultPeriodDuration) Duration periodDuration,
    @Default(BoutConfig.defaultBreakDuration) Duration breakDuration,
    @Default(BoutConfig.defaultActivityDuration) Duration activityDuration,
    @Default(BoutConfig.defaultInjuryDuration) Duration injuryDuration,
    @Default(BoutConfig.defaultPeriodCount) int periodCount,
  }) = _BoutConfig;

  factory BoutConfig.fromJson(Map<String, Object?> json) => _$BoutConfigFromJson(json);

  static Future<BoutConfig> fromRaw(Map<String, dynamic> e) async {
    final periodSeconds = e['period_duration_secs'] as int?;
    final breakSeconds = e['break_duration_secs'] as int?;
    final activitySeconds = e['activity_duration_secs'] as int?;
    final injurySeconds = e['injury_duration_secs'] as int?;

    return BoutConfig(
      id: e['id'] as int?,
      periodDuration: periodSeconds != null ? Duration(seconds: periodSeconds) : defaultPeriodDuration,
      breakDuration: breakSeconds != null ? Duration(seconds: breakSeconds) : defaultBreakDuration,
      activityDuration: activitySeconds != null ? Duration(seconds: activitySeconds) : defaultActivityDuration,
      injuryDuration: injurySeconds != null ? Duration(seconds: injurySeconds) : defaultInjuryDuration,
      periodCount: (e['period_count'] as int?) ?? defaultPeriodCount,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'period_duration_secs': periodDuration.inSeconds,
      'break_duration_secs': breakDuration.inSeconds,
      'activity_duration_secs': activityDuration.inSeconds,
      'injury_duration_secs': injuryDuration.inSeconds,
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
}
