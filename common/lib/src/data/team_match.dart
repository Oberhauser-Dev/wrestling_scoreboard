import 'package:json_annotation/json_annotation.dart';

import '../enums/wrestling_style.dart';
import 'data_object.dart';
import 'fight.dart';
import 'league.dart';
import 'lineup.dart';
import 'person.dart';
import 'weight_class.dart';

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
  List<Fight>? fights;
  final Duration roundDuration = Duration(minutes: 3);
  final Duration breakDuration = Duration(seconds: 30);
  final Duration activityDuration = Duration(seconds: 30);
  final Duration injuryDuration = Duration(seconds: 30);
  int maxRounds = 2;
  List<WeightClass> weightClasses = [
    WeightClass(weight: 57, style: WrestlingStyle.free),
    WeightClass(weight: 130, style: WrestlingStyle.greco),
    WeightClass(weight: 61, style: WrestlingStyle.greco),
    WeightClass(weight: 98, style: WrestlingStyle.free),
    WeightClass(weight: 66, style: WrestlingStyle.free),
    WeightClass(weight: 86, style: WrestlingStyle.greco),
    WeightClass(weight: 71, style: WrestlingStyle.greco),
    WeightClass(weight: 80, style: WrestlingStyle.free),
    WeightClass(weight: 75, style: WrestlingStyle.free, name: '75 kg A'),
    WeightClass(weight: 75, style: WrestlingStyle.greco, name: '75 kg B'),
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

  int get homePoints {
    var res = 0;
    for (final fight in fights!) {
      res += fight.r?.classificationPoints ?? 0;
    }
    return res;
  }

  int get guestPoints {
    var res = 0;
    for (final fight in fights!) {
      res += fight.b?.classificationPoints ?? 0;
    }
    return res;
  }
}
