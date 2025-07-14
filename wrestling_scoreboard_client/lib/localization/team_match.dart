import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension TeamMatchLocalization on TeamMatch {
  String localize(BuildContext context) {
    return '${date.toDateString(context)}, ${no ?? 'no ID'}, ${home.team.name} - ${guest.team.name}';
  }
}
