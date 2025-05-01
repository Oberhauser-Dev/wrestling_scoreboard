import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'bout_action.freezed.dart';
part 'bout_action.g.dart';

/// An action and its value that is fulfilled by the participant during a bout, e.g. points or caution
@freezed
abstract class BoutAction with _$BoutAction implements DataObject {
  const BoutAction._();

  const factory BoutAction({
    int? id,
    required BoutActionType actionType,
    required Bout bout,
    required Duration duration,
    required BoutRole role,
    int? pointCount,
  }) = _BoutAction;

  factory BoutAction.fromJson(Map<String, Object?> json) => _$BoutActionFromJson(json);

  static Future<BoutAction> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async => BoutAction(
        id: e['id'] as int?,
        actionType: BoutActionType.values.byName(e['action_type']),
        duration: Duration(milliseconds: e['duration_millis']),
        role: BoutRole.values.byName(e['bout_role']),
        pointCount: e['point_count'] as int?,
        bout: (await getSingle<Bout>(e['bout_id'] as int)),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'action_type': actionType.name,
      'duration_millis': duration.inMilliseconds,
      'bout_role': role.name,
      'point_count': pointCount,
      'bout_id': bout.id!,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'bout_action';

  String get actionValue {
    switch (actionType) {
      case BoutActionType.points:
        return pointCount?.toString() ?? '0';
      case BoutActionType.passivity:
        return 'P';
      case BoutActionType.verbal:
        return 'V';
      case BoutActionType.caution:
        return 'O';
      case BoutActionType.dismissal:
        return 'D';
    }
  }

  @override
  BoutAction copyWithId(int? id) {
    return copyWith(id: id);
  }
}
