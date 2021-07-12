import 'package:common/common.dart';

import 'entity_controller.dart';
import 'lineup_controller.dart';
import 'membership_controller.dart';
import 'weight_class_controller.dart';

class ParticipationController extends EntityController<Participation> {
  static final ParticipationController _singleton = ParticipationController._internal();

  factory ParticipationController() {
    return _singleton;
  }

  ParticipationController._internal() : super(tableName: 'participation');

  @override
  Future<Participation> parseToClass(Map<String, dynamic> e) async {
    final weightClass = await WeightClassController().getSingle(e['weight_class_id'] as int);
    final lineup = await LineupController().getSingle(e['lineup_id'] as int);
    final membership = await MembershipController().getSingle(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return Participation(
      id: e['id'] as int?,
      weightClass: weightClass!,
      lineup: lineup!,
      membership: membership!,
      weight: weight,
    );
  }
}
