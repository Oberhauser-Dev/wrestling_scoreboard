import '../data.dart';

abstract class WrestlingEvent implements DataObject {
  const WrestlingEvent();

  DateTime get date;

  /// competitionId (CID), eventId, matchId or Kampf-Id
  String? get no;

  String? get location;

  int? get visitorsCount;

  String? get comment;

  Future<List<Fight>> generateFights(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses);

  // static Future<WrestlingEvent> fromRaw(Map<String, dynamic> e) async => WrestlingEvent(
  //       id: e['id'] as int?,
  //       location: e['location'] as String?,
  //       date: e['date'] as DateTime?,
  //       visitorsCount: e['visitors_count'] as int?,
  //       comment: e['comment'] as String?,
  //     );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'no': no,
      'location': location,
      'date': date,
      'visitors_count': visitorsCount,
      'comment': comment,
    };
  }
}
