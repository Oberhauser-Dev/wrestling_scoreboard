import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension WeightClassLocalization on WeightClass {
  localize(BuildContext context) => '$name ${style.localize(context)}';

  abbreviation(BuildContext context) => '$name ${style.abbreviation(context)}';
}
