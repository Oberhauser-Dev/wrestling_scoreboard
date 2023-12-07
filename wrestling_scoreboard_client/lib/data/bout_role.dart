import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_common/common.dart';

MaterialColor getColorFromBoutRole(BoutRole role) {
  return role == BoutRole.red ? Colors.red : Colors.blue;
}
