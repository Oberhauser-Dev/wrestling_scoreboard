import 'package:common/src/data/data_object.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fight.dart';
import 'league.dart';
import 'lineup.dart';
import 'person.dart';
import 'weight_class.dart';
import 'wrestling_style.dart';

part 'team_match.g.dart';

/// For team matches only.
@JsonSerializable()
class TeamMatch extends DataObject {
  final String? no;
  final Lineup home;
  final Lineup guest;
  final Person referee;
  Person? transcriptWriter;
  Person? timeKeeper;
  Person? matPresident;
  List<Person> stewards = [];
  DateTime? date;
  String? location;
  int visitorsCount = 0;
  String comment = '';
  late League league; // Liga
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

  TeamMatch(this.home, this.guest, this.referee, {int? id, this.no, this.location, this.date}) : super(id) {
    if (home.team.league == guest.team.league && home.team.league != null) {
      league = home.team.league!;
      //  TODO load weight classes of league
    } else {
      league = League.outOfCompetition;
    }
    date ??= DateTime.now();
  }

  factory TeamMatch.fromJson(Map<String, dynamic> json) => _$TeamMatchFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMatchToJson(this);

  List<Fight> get fights {
    if (_fights == null) {
      _fights = [];
      for (final weightClass in weightClasses) {
        var homePartList = home.participantStatusList.where((el) => el.weightClass == weightClass);
        var guestPartList = guest.participantStatusList.where((el) => el.weightClass == weightClass);
        var red = homePartList.isNotEmpty ? homePartList.single : null;
        var blue = guestPartList.isNotEmpty ? guestPartList.single : null;

        var fight = Fight(red, blue, weightClass);
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
