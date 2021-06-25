import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

import 'fight.dart';
import 'lineup.dart';
import 'participant_status.dart';

/// For team matches only.
class ClientTeamMatch extends TeamMatch with ChangeNotifier {
  List<ClientFight>? _fights;

  ClientTeamMatch(ClientLineup home, ClientLineup guest, Person referee, {int? id, String? location, DateTime? date})
      : super(home, guest, referee, id: id, location: location, date: date);

  ClientTeamMatch.from(TeamMatch obj)
      : this(ClientLineup.from(obj.home), ClientLineup.from(obj.guest), obj.referee,
            id: obj.id, location: obj.location, date: obj.date);

  factory ClientTeamMatch.fromJson(Map<String, dynamic> json) => ClientTeamMatch.from(TeamMatch.fromJson(json));

  List<ClientFight> get fights {
    if (_fights == null) {
      _fights = [];
      for (final fight in super.fights) {
        var tmpFight =
            ClientFight(fight.r as ClientParticipantStatus?, fight.b as ClientParticipantStatus?, fight.weightClass);
        _fights!.add(tmpFight);
        tmpFight.addListener(() {
          notifyListeners();
        });
      }
    }
    return _fights!;
  }
}
