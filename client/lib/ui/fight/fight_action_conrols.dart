import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';

import 'fight_shortcuts.dart';

class FightActionControls extends StatelessWidget {
  final FightRole role;
  final Function(FightScreenActionIntent) callback;

  FightActionControls(this.role, this.callback);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;

    bool isRed = role == FightRole.red;
    MaterialColor color = isRed ? Colors.red : Colors.blue;
    var actions = <Widget>[
      displayActionControl(
          '1',
          () => callback(isRed ? const FightScreenActionIntent.RedOne() : FightScreenActionIntent.BlueOne()),
          color,
          padding),
      displayActionControl(
          '2',
          () => callback(isRed ? const FightScreenActionIntent.RedTwo() : FightScreenActionIntent.BlueTwo()),
          color,
          padding),
      displayActionControl(
          '4',
          () => callback(isRed ? const FightScreenActionIntent.RedFour() : FightScreenActionIntent.BlueFour()),
          color,
          padding),
      displayActionControl(
          'P',
          () =>
              callback(isRed ? const FightScreenActionIntent.RedPassivity() : FightScreenActionIntent.BluePassivity()),
          color,
          padding),
      displayActionControl(
          'O',
          () => callback(isRed ? const FightScreenActionIntent.RedCaution() : FightScreenActionIntent.BlueCaution()),
          color,
          padding),
      /*displayActionControl(
          'D',
              () =>
              callback(isRed ? const FightScreenActionIntent.RedDismissal() : FightScreenActionIntent.BlueDismissal()),
          color,
          padding),*/
      displayActionControl(
          AppLocalizations.of(context)!.activityTimeAbbr, // AZ Activity Time, Aktivitätszeit
          () => callback(
              isRed ? const FightScreenActionIntent.RedActivityTime() : FightScreenActionIntent.BlueActivityTime()),
          color,
          padding),
      displayActionControl(
          AppLocalizations.of(context)!.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          () => callback(
              isRed ? const FightScreenActionIntent.RedInjuryTime() : FightScreenActionIntent.BlueInjuryTime()),
          color,
          padding),
      displayActionControl(
          '⎌',
          () => callback(isRed ? const FightScreenActionIntent.RedUndo() : FightScreenActionIntent.BlueUndo()),
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

  displayActionControl(String text, void Function() callback, MaterialColor color, double padding) {
    return Expanded(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: color,
              side: BorderSide(color: color.shade900, width: 1),
              padding: EdgeInsets.all(2 + (padding * 0.75)),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
            onPressed: () => callback(),
            child: FittedText(text)));
  }
}
