import 'package:flutter/material.dart';

enum FightRole {
  red,
  blue,
}

MaterialColor getColorFromFightRole(FightRole role) {
  return role == FightRole.red ? Colors.red : Colors.blue;
}
