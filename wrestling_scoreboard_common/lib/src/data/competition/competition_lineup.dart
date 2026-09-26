import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_lineup.freezed.dart';
part 'competition_lineup.g.dart';

/// Club participates in a competition.
@freezed
abstract class CompetitionLineup with _$CompetitionLineup implements DataObject {
  const CompetitionLineup._();

  const factory CompetitionLineup({int? id, required Competition competition, required Club club}) = _CompetitionLineup;

  factory CompetitionLineup.fromJson(Map<String, Object?> json) => _$CompetitionLineupFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {if (id != null) 'id': id, 'competition_id': competition.id!, 'club_id': club.id!};
  }

  static Future<CompetitionLineup> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    return CompetitionLineup(
      id: e['id'] as int?,
      competition: (await getSingle<Competition>(e['competition_id'] as int)),
      club: (await getSingle<Club>(e['club_id'] as int)),
    );
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_lineup';

  @override
  CompetitionLineup copyWithId(int? id) {
    return copyWith(id: id);
  }
}
