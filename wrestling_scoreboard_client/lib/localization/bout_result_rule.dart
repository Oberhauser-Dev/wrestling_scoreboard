import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutResultRuleLocalization on BoutResultRule {
  String localize(BuildContext context) {
    return '# $id | ${boutResult.abbreviation(context)} | ${style?.abbreviation(context) ?? '-'} | CP $winnerClassificationPoints:$loserClassificationPoints | TP ${winnerTechnicalPoints ?? '-'}:${loserTechnicalPoints ?? '-'} | Diff: ${technicalPointsDifference ?? '-'}';
  }
}
