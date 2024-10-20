import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutActionControls extends StatelessWidget {
  final BoutRole role;
  final BoutConfig boutConfig;
  final Function(BoutScreenActionIntent)? callback;

  const BoutActionControls(this.role, this.boutConfig, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isRed = role == BoutRole.red;
    MaterialColor color = isRed ? Colors.red : Colors.blue;
    void Function()? prepareCallback(BoutScreenActionIntent intentRed, BoutScreenActionIntent intentBlue) {
      return callback == null ? null : () => callback!(isRed ? intentRed : intentBlue);
    }

    var actions = <Widget>[
      displayActionControl(
        '1',
        prepareCallback(const BoutScreenActionIntent.redOne(), const BoutScreenActionIntent.blueOne()),
        color,
      ),
      displayActionControl(
        '2',
        prepareCallback(const BoutScreenActionIntent.redTwo(), const BoutScreenActionIntent.blueTwo()),
        color,
      ),
      displayActionControl(
        '4',
        prepareCallback(const BoutScreenActionIntent.redFour(), const BoutScreenActionIntent.blueFour()),
        color,
      ),
      displayActionControl(
        '5',
        prepareCallback(const BoutScreenActionIntent.redFive(), const BoutScreenActionIntent.blueFive()),
        color,
      ),
      displayActionControl(
        'P',
        prepareCallback(const BoutScreenActionIntent.redPassivity(), const BoutScreenActionIntent.bluePassivity()),
        color,
      ),
      displayActionControl(
        'O',
        prepareCallback(const BoutScreenActionIntent.redCaution(), const BoutScreenActionIntent.blueCaution()),
        color,
      ),
      displayActionControl(
        'D',
        prepareCallback(const BoutScreenActionIntent.redDismissal(), const BoutScreenActionIntent.blueDismissal()),
        color,
      ),
      if (boutConfig.activityDuration != null)
        displayActionControl(
          AppLocalizations.of(context)!.activityTimeAbbr, // AZ Activity Time, Aktivitätszeit
          prepareCallback(
              const BoutScreenActionIntent.redActivityTime(), const BoutScreenActionIntent.blueActivityTime()),
          color,
        ),
      if (boutConfig.injuryDuration != null)
        displayActionControl(
          AppLocalizations.of(context)!.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          prepareCallback(const BoutScreenActionIntent.redInjuryTime(), const BoutScreenActionIntent.blueInjuryTime()),
          color,
        ),
      if (boutConfig.bleedingInjuryDuration != null)
        displayActionControl(
          AppLocalizations.of(context)!.bleedingInjuryTimeShort, // BZ Bleeding Injury Time, Verletzungszeit Blut
          prepareCallback(const BoutScreenActionIntent.redBleedingInjuryTime(),
              const BoutScreenActionIntent.blueBleedingInjuryTime()),
          color,
        ),
      displayActionControl(
        '⎌',
        prepareCallback(const BoutScreenActionIntent.redUndo(), const BoutScreenActionIntent.blueUndo()),
        color,
      ),
    ];
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions,
      ),
    );
  }

  displayActionControl(String text, void Function()? callback, MaterialColor color) {
    return Expanded(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.white,
              backgroundColor: color,
              side: BorderSide(color: color.shade900, width: 1),
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
            onPressed: callback,
            child: ScaledText(text, fontSize: 10, minFontSize: 8, softWrap: false)));
  }
}
