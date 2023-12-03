import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'fight_shortcuts.dart';

class FightActionControls extends StatelessWidget {
  final FightRole role;
  final Function(FightScreenActionIntent)? callback;

  const FightActionControls(this.role, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 512;

    bool isRed = role == FightRole.red;
    MaterialColor color = isRed ? Colors.red : Colors.blue;
    void Function()? prepareCallback(FightScreenActionIntent intentRed, FightScreenActionIntent intentBlue) {
      return callback == null ? null : () => callback!(isRed ? intentRed : intentBlue);
    }

    var actions = <Widget>[
      displayActionControl(
          '1',
          prepareCallback(const FightScreenActionIntent.redOne(), const FightScreenActionIntent.blueOne()),
          color,
          padding),
      displayActionControl(
          '2',
          prepareCallback(const FightScreenActionIntent.redTwo(), const FightScreenActionIntent.blueTwo()),
          color,
          padding),
      displayActionControl(
          '4',
          prepareCallback(const FightScreenActionIntent.redFour(), const FightScreenActionIntent.blueFour()),
          color,
          padding),
      displayActionControl(
          'P',
          prepareCallback(const FightScreenActionIntent.redPassivity(), const FightScreenActionIntent.bluePassivity()),
          color,
          padding),
      displayActionControl(
          'O',
          prepareCallback(const FightScreenActionIntent.redCaution(), const FightScreenActionIntent.blueCaution()),
          color,
          padding),
      /*displayActionControl(
          'D',
          prepareCallback(const FightScreenActionIntent.RedDismissal(), FightScreenActionIntent.BlueDismissal()),
          color,
          padding),*/
      displayActionControl(
          AppLocalizations.of(context)!.activityTimeAbbr, // AZ Activity Time, Aktivitätszeit
          prepareCallback(
              const FightScreenActionIntent.redActivityTime(), const FightScreenActionIntent.blueActivityTime()),
          color,
          padding),
      displayActionControl(
          AppLocalizations.of(context)!.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          prepareCallback(
              const FightScreenActionIntent.redInjuryTime(), const FightScreenActionIntent.blueInjuryTime()),
          color,
          padding),
      displayActionControl(
          '⎌',
          prepareCallback(const FightScreenActionIntent.redUndo(), const FightScreenActionIntent.blueUndo()),
          color,
          padding),
    ];
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions,
      ),
    );
  }

  displayActionControl(String text, void Function()? callback, MaterialColor color, double padding) {
    return Expanded(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              foregroundColor: Colors.white,
              backgroundColor: color,
              side: BorderSide(color: color.shade900, width: 1),
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
            onPressed: callback,
            child: ScaledText(text, fontSize: 10, minFontSize: 6, softWrap: false)));
  }
}
