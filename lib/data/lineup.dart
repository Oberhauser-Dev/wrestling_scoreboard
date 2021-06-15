import 'participant_status.dart';
import 'person.dart';
import 'team.dart';

class Lineup {
  final Team team;
  final Person? leader; // Mannschaftsführer
  final Person? coach; // Trainer
  final List<ParticipantStatus> participantStatusList;
  int tier; // Rangordnung

  Lineup({required this.team, required this.participantStatusList, this.leader, this.coach, this.tier = 1});
}
