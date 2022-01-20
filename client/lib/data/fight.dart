import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

import 'participant_state.dart';

class ClientFight extends Fight with ChangeNotifier {
  ClientFight({
    int? id,
    ClientParticipantState? r,
    ClientParticipantState? b,
    required WeightClass weightClass,
    int? pool,
    FightResult? result,
    FightRole? winner,
    Duration duration = const Duration(),
  }) : super(id: id, r: r, b: b, weightClass: weightClass, pool: pool, result: result, winner: winner, duration: duration) {
    r?.addListener(() {
      notifyListeners();
    });
    b?.addListener(() {
      notifyListeners();
    });
  }

  ClientFight.from(Fight obj)
      : this(
          id: obj.id,
          r: obj.r == null ? null : ClientParticipantState.from(obj.r!),
          b: obj.b == null ? null : ClientParticipantState.from(obj.b!),
          weightClass: obj.weightClass,
          pool: obj.pool,
          result: obj.result,
          winner: obj.winner,
          duration: obj.duration,
        );

  factory ClientFight.fromJson(Map<String, dynamic> json) => ClientFight.from(Fight.fromJson(json));

  @override
  ClientParticipantState? get r {
    return super.r != null ? super.r as ClientParticipantState : null;
  }

  @override
  ClientParticipantState? get b {
    return super.b != null ? super.b as ClientParticipantState : null;
  }

  @override
  set duration(Duration duration) {
    super.duration = duration;
    notifyListeners();
  }

  @override
  bool addAction(FightAction action) {
    if (super.addAction(action)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  removeAction(FightAction action) {
    super.removeAction(action);
    notifyListeners();
  }
}
