import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'participant_state.freezed.dart';
part 'participant_state.g.dart';

/// The state of one participant during a bout.
@freezed
abstract class AthleteBoutState with _$AthleteBoutState implements DataObject {
  const AthleteBoutState._();

  const factory AthleteBoutState({
    int? id,
    required Membership membership,
    int? classificationPoints,
  }) = _AthleteBoutState;

  factory AthleteBoutState.fromJson(Map<String, Object?> json) => _$AthleteBoutStateFromJson(json);

  static Future<AthleteBoutState> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    // TODO renamed participant to membership
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    return AthleteBoutState(
      id: e['id'] as int?,
      membership: membership,
      classificationPoints: e['classification_points'] as int?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'membership_id': membership.id!,
      'classification_points': classificationPoints,
    };
  }

  @override
  String get tableName => 'participant_state';

  static int getTechnicalPoints(Iterable<BoutAction> actions, BoutRole role) {
    var res = 0;
    for (var el in actions) {
      if (el.actionType == BoutActionType.points && el.role == role) {
        res += el.pointCount!;
      }
    }
    return res;
  }

  bool equalDuringBout(o) => o is AthleteBoutState && o.runtimeType == runtimeType && membership == o.membership;

  @override
  AthleteBoutState copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {
    'membership_id': Membership,
  };
}
