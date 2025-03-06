import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_bout.freezed.dart';
part 'competition_bout.g.dart';

@freezed
abstract class CompetitionBout with _$CompetitionBout implements DataObject {
  const CompetitionBout._();

  const factory CompetitionBout({
    int? id,
    required Competition competition,
    required Bout bout,
  }) = _CompetitionBout;

  factory CompetitionBout.fromJson(Map<String, Object?> json) => _$CompetitionBoutFromJson(json);

  static Future<CompetitionBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competition = await getSingle<Competition>(e['competition_id'] as int);
    final bout = await getSingle<Bout>(e['bout_id'] as int);

    return CompetitionBout(
      id: e['id'] as int?,
      competition: competition,
      bout: bout,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id!,
      'bout_id': bout.id!,
    };
  }

  @override
  String get tableName => 'competition_bout';

  @override
  CompetitionBout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
