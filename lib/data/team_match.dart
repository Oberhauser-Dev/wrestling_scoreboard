import 'package:flutter/cupertino.dart';

import 'fight.dart';
import 'lineup.dart';
import 'person.dart';
import 'weight_class.dart';
import 'wrestling_style.dart';

/// For team matches only.
class TeamMatch extends ChangeNotifier {
  final int? id;
  final Lineup home;
  final Lineup guest;
  final Person referee;
  late final DateTime date;
  int visitorsCount = 0;
  String comment = '';
  late String league; // Liga
  List<Fight>? _fights;
  final Duration roundDuration = Duration(minutes: 3);
  final Duration breakDuration = Duration(seconds: 30);
  final Duration activityDuration = Duration(seconds: 30);
  final Duration injuryDuration = Duration(seconds: 30);
  int maxRounds = 2;
  List<WeightClass> weightClasses = [
    WeightClass(57, WrestlingStyle.free),
    WeightClass(130, WrestlingStyle.greco),
    WeightClass(61, WrestlingStyle.greco),
    WeightClass(98, WrestlingStyle.free),
    WeightClass(66, WrestlingStyle.free),
    WeightClass(86, WrestlingStyle.greco),
    WeightClass(71, WrestlingStyle.greco),
    WeightClass(80, WrestlingStyle.free),
    WeightClass(75, WrestlingStyle.free, name: '75 kg A'),
    WeightClass(75, WrestlingStyle.greco, name: '75 kg B'),
  ];

  TeamMatch(this.home, this.guest, this.referee, {this.id}) {
    if (home.team.league == guest.team.league && home.team.league != null) {
      this.league = home.team.league!;
      //  TODO load weight classes of league
    } else {
      this.league = 'Freundschaftskampf';
    }
    date = DateTime.now();
  }

  List<Fight> get fights {
    if (_fights == null) {
      _fights = [];
      for (final weightClass in weightClasses) {
        var homePartList = home.participantStatusList.where((el) => el.weightClass == weightClass);
        var guestPartList = guest.participantStatusList.where((el) => el.weightClass == weightClass);
        var red = homePartList.isNotEmpty ? homePartList.single : null;
        var blue = guestPartList.isNotEmpty ? guestPartList.single : null;

        var fight = Fight(red, blue, weightClass);
        fight.addListener(() {
          notifyListeners();
        });
        _fights!.add(fight);
      }
    }
    return _fights!;
  }

  int get homePoints {
    int res = 0;
    for (final fight in fights) {
      res += fight.r?.classificationPoints ?? 0;
    }
    return res;
  }

  int get guestPoints {
    int res = 0;
    for (final fight in fights) {
      res += fight.b?.classificationPoints ?? 0;
    }
    return res;
  }
}
