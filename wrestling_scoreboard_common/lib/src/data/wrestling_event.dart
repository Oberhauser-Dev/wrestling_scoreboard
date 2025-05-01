import '../data.dart';

abstract class WrestlingEvent implements DataObject, Organizational {
  const WrestlingEvent();

  DateTime get date;

  /// competitionId (CID), eventId, matchId or Kampf-Id
  String? get no;

  String? get location;

  int? get visitorsCount;

  String? get comment;

  // static Future<WrestlingEvent> fromRaw(Map<String, dynamic> e) async => WrestlingEvent(
  //       id: e['id'] as int?,
  //       orgSyncId: e['org_sync_id'] as String?,
  //       organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
  //       location: e['location'] as String?,
  //       date: e['date'] as DateTime?,
  //       visitorsCount: e['visitors_count'] as int?,
  //       comment: e['comment'] as String?,
  //     );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'no': no,
      'location': location,
      'date': date,
      'visitors_count': visitorsCount,
      'comment': comment,
    };
  }

  static Set<String> searchableAttributes = {'no', 'location', 'comment'};
}
