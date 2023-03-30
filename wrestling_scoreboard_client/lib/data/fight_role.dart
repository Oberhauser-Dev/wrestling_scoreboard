import 'package:wrestling_scoreboard_common/common.dart';
import 'package:flutter/material.dart';

MaterialColor getColorFromFightRole(FightRole role) {
  return role == FightRole.red ? Colors.red : Colors.blue;
}
