import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

import 'participant_status.dart';

class ClientFight extends Fight with ChangeNotifier {
  ClientFight(ClientParticipantStatus? r, ClientParticipantStatus? b, WeightClass weightClass, {int? pool})
      : super(r, b, weightClass, pool: pool) {
    r?.addListener(() {
      notifyListeners();
    });
    b?.addListener(() {
      notifyListeners();
    });
  }

  ClientFight.from(Fight obj)
      : this(obj.r == null ? null : ClientParticipantStatus.from(obj.r!),
            obj.b == null ? null : ClientParticipantStatus.from(obj.b!), obj.weightClass,
            pool: obj.pool);

  factory ClientFight.fromJson(Map<String, dynamic> json) => ClientFight.from(Fight.fromJson(json));

  ClientParticipantStatus? get r {
    return super.r != null ? super.r as ClientParticipantStatus : null;
  }

  ClientParticipantStatus? get b {
    return super.b != null ? super.b as ClientParticipantStatus : null;
  }

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

  removeAction(FightAction action) {
    super.removeAction(action);
    notifyListeners();
  }
}
