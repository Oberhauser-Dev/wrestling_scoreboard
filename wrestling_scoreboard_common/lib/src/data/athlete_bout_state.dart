import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'athlete_bout_state.freezed.dart';
part 'athlete_bout_state.g.dart';

/// The state of one participant during a bout.
@freezed
abstract class AthleteBoutState with _$AthleteBoutState implements DataObject {
  const AthleteBoutState._();

  const factory AthleteBoutState({
    int? id,
    required Membership membership,
    int? classificationPoints,

    /// Activity time is only running, when bout time is running.
    Duration? activityTime,
    Duration? injuryTime,
    @Default(false) bool isInjuryTimeRunning,
    Duration? bleedingInjuryTime,
    @Default(false) bool isBleedingInjuryTimeRunning,
  }) = _AthleteBoutState;

  factory AthleteBoutState.fromJson(Map<String, Object?> json) => _$AthleteBoutStateFromJson(json);

  static Future<AthleteBoutState> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final activityTimeMillis = e['activity_time_millis'] as int?;
    final injuryTimeMillis = e['injury_time_millis'] as int?;
    final bleedingInjuryTimeMillis = e['bleeding_injury_time_millis'] as int?;
    return AthleteBoutState(
      id: e['id'] as int?,
      membership: membership,
      classificationPoints: e['classification_points'] as int?,
      activityTime: activityTimeMillis == null ? null : Duration(milliseconds: activityTimeMillis),
      injuryTime: injuryTimeMillis == null ? null : Duration(milliseconds: injuryTimeMillis),
      isInjuryTimeRunning: e['is_injury_time_running'] as bool,
      bleedingInjuryTime: bleedingInjuryTimeMillis == null ? null : Duration(milliseconds: bleedingInjuryTimeMillis),
      isBleedingInjuryTimeRunning: e['is_bleeding_injury_time_running'] as bool,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'membership_id': membership.id!,
      'classification_points': classificationPoints,
      'activity_time_millis': activityTime?.inMilliseconds,
      'injury_time_millis': injuryTime?.inMilliseconds,
      'is_injury_time_running': isInjuryTimeRunning,
      'bleeding_injury_time_millis': bleedingInjuryTime?.inMilliseconds,
      'is_bleeding_injury_time_running': isBleedingInjuryTimeRunning,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'athlete_bout_state';

  static int getTechnicalPoints(Iterable<BoutAction> actions, BoutRole role) {
    var res = 0;
    for (var el in actions) {
      if (el.actionType == BoutActionType.points && el.role == role) {
        res += el.pointCount!;
      }
    }
    return res;
  }

  bool equalDuringBout(AthleteBoutState? o) => membership == o?.membership;

  @override
  AthleteBoutState copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {'membership_id': Membership};
}
