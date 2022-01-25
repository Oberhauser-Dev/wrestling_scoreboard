import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';

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
          prepareCallback(const FightScreenActionIntent.RedOne(), const FightScreenActionIntent.BlueOne()),
          color,
          padding),
      displayActionControl(
          '2',
          prepareCallback(const FightScreenActionIntent.RedTwo(), const FightScreenActionIntent.BlueTwo()),
          color,
          padding),
      displayActionControl(
          '4',
          prepareCallback(const FightScreenActionIntent.RedFour(), const FightScreenActionIntent.BlueFour()),
          color,
          padding),
      displayActionControl(
          'P',
          prepareCallback(const FightScreenActionIntent.RedPassivity(), const FightScreenActionIntent.BluePassivity()),
          color,
          padding),
      displayActionControl(
          'O',
          prepareCallback(const FightScreenActionIntent.RedCaution(), const FightScreenActionIntent.BlueCaution()),
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
              const FightScreenActionIntent.RedActivityTime(), const FightScreenActionIntent.BlueActivityTime()),
          color,
          padding),
      displayActionControl(
          AppLocalizations.of(context)!.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          prepareCallback(
              const FightScreenActionIntent.RedInjuryTime(), const FightScreenActionIntent.BlueInjuryTime()),
          color,
          padding),
      displayActionControl(
          '⎌',
          prepareCallback(const FightScreenActionIntent.RedUndo(), const FightScreenActionIntent.BlueUndo()),
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
              primary: Colors.white,
              backgroundColor: color,
              side: BorderSide(color: color.shade900, width: 1),
              padding: EdgeInsets.all(2 + (padding * 0.75)),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
            onPressed: callback,
            child: FittedText(text)));
  }
}
