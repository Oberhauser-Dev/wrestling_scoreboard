import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard/mocks/mocks.dart';

import 'fight.dart';
import 'lineup.dart';
import 'participant_state.dart';

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
    return _fights!;
  }

  Future<List<Fight>> generateFights() async {
    _fights = [];
    // TODO fetch
    Iterable<Participation> homeParticipations = getParticipations().where((el) => el.lineup == home);
    Iterable<Participation> guestParticipations = getParticipations().where((el) => el.lineup == guest);
    for (final weightClass in weightClasses) {
      var homePartList = homeParticipations.where((el) => el.weightClass == weightClass);
      var guestPartList = guestParticipations.where((el) => el.weightClass == weightClass);
      var red = homePartList.isNotEmpty ? homePartList.single : null;
      var blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      var fight = ClientFight(
        red == null ? null : ClientParticipantState(participation: red),
        blue == null ? null : ClientParticipantState(participation: blue),
        weightClass,
      );
      fight.addListener(() {
        notifyListeners();
      });
      _fights!.add(fight);
    }
    return _fights!;
  }
}
