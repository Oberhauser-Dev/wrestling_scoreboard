import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';

part 'bout_config.g.dart';

/// The general configuration for a bout, e.g. in a team competition or tournament.
@JsonSerializable()
class BoutConfig extends DataObject {
  static const defaultPeriodDuration = Duration(minutes: 3);
  static const defaultBreakDuration = Duration(seconds: 30);
  static const defaultActivityDuration = Duration(seconds: 30);
  static const defaultInjuryDuration = Duration(minutes: 2);
  static const defaultPeriodCount = 2;

  final Duration periodDuration;
  final Duration breakDuration;
  final Duration activityDuration;
  final Duration injuryDuration;
  final int periodCount;

  BoutConfig(
      {int? id,
      this.periodDuration = defaultPeriodDuration,
      this.breakDuration = defaultBreakDuration,
      this.activityDuration = defaultActivityDuration,
      this.injuryDuration = defaultInjuryDuration,
      this.periodCount = defaultPeriodCount})
      : super(id);

  factory BoutConfig.fromJson(Map<String, dynamic> json) => _$BoutConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BoutConfigToJson(this);

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
}
