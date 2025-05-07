import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

/// The membership of a person in a club.
@freezed
abstract class Membership with _$Membership implements DataObject, Organizational {
  const Membership._();

  const factory Membership({
    int? id,
    String? orgSyncId,
    Organization? organization,
    String? no, // Mitgliedsnummer
    required Club club,
    required Person person,
  }) = _Membership;

  factory Membership.fromJson(Map<String, Object?> json) => _$MembershipFromJson(json);

  static Future<Membership> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final person = await getSingle<Person>(e['person_id'] as int);
    final club = await getSingle<Club>(e['club_id'] as int);
    final organizationId = e['organization_id'] as int?;
    return Membership(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      no: e['no'] as String?,
      person: person,
      club: club,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'person_id': person.id!,
      'club_id': club.id!,
      'no': no,
    };
  }

  String get info {
    return '${no == null ? '' : 'No. $no, '}\t ${person.fullName},\t${person.age}';
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'membership';

  @override
  Membership copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {'no'};

  static Map<String, Type> searchableForeignAttributeMapping = {'person_id': Person, 'club_id': Club};
}
