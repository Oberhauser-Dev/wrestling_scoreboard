import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'participant_state.freezed.dart';
part 'participant_state.g.dart';

/// The state of one participant during a bout.
@freezed
class ParticipantState with _$ParticipantState implements DataObject {
  const ParticipantState._();

  const factory ParticipantState({
    int? id,
    required Participation participation,
    int? classificationPoints,
  }) = _ParticipantState;

  factory ParticipantState.fromJson(Map<String, Object?> json) => _$ParticipantStateFromJson(json);

  static Future<ParticipantState> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final participation = await getSingle<Participation>(e['participation_id'] as int);
    return ParticipantState(
      id: e['id'] as int?,
      participation: participation,
      classificationPoints: e['classification_points'] as int?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'participation_id': participation.id!,
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

  bool equalDuringBout(o) => o is ParticipantState && o.runtimeType == runtimeType && participation == o.participation;

  @override
  ParticipantState copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override
  String? get orgSyncId => throw UnimplementedError();

  @override
  Organization? get organization => throw UnimplementedError();
}
