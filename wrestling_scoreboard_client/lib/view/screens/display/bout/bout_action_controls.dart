import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tooltip.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutActionControls extends StatelessWidget {
  final BoutRole role;
  final BoutConfig boutConfig;
  final Function(BoutScreenActionIntent)? callback;

  const BoutActionControls(this.role, this.boutConfig, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final bool isRed = role == BoutRole.red;
    final MaterialColor color = isRed ? Colors.red : Colors.blue;
    void Function()? prepareCallback(BoutScreenActionIntent intentRed, BoutScreenActionIntent intentBlue) {
      return callback == null ? null : () => callback!(isRed ? intentRed : intentBlue);
    }

    final actions = <Widget>[
      displayActionControl(
        '1',
        prepareCallback(const BoutScreenActionIntent.redOne(), const BoutScreenActionIntent.blueOne()),
        color,
        tooltipMessage: '1 ${localizations.point} (${isRed ? '1 | F' : 'Numpad1 | J | ⇧ + 1'})',
      ),
      displayActionControl(
        '2',
        prepareCallback(const BoutScreenActionIntent.redTwo(), const BoutScreenActionIntent.blueTwo()),
        color,
        tooltipMessage: '2 ${localizations.points} (${isRed ? '2 | D' : 'Numpad2 | K | ⇧ + 2'})',
      ),
      displayActionControl(
        '4',
        prepareCallback(const BoutScreenActionIntent.redFour(), const BoutScreenActionIntent.blueFour()),
        color,
        tooltipMessage: '4 ${localizations.points} (${isRed ? '4 | S' : 'Numpad4 | L | ⇧ + 4'})',
      ),
      // TODO: Get character mapping from LogicalKeyboardKey before pressing it.
      // https://github.com/flutter/flutter/issues/25841
      displayActionControl(
        '5',
        prepareCallback(const BoutScreenActionIntent.redFive(), const BoutScreenActionIntent.blueFive()),
        color,
        tooltipMessage: '5 ${localizations.points} (${isRed ? '5 | A' : 'Numpad5 | ;/Ö | ⇧ + 5'})',
      ),
      displayActionControl(
        localizations.verbalWarningAbbr,
        prepareCallback(const BoutScreenActionIntent.redVerbal(), const BoutScreenActionIntent.blueVerbal()),
        color,
        tooltipMessage: localizations.verbalWarning,
      ),
      displayActionControl(
        localizations.passivityAbbr,
        prepareCallback(const BoutScreenActionIntent.redPassivity(), const BoutScreenActionIntent.bluePassivity()),
        color,
        tooltipMessage: localizations.passivity,
      ),
      displayActionControl(
        localizations.cautionAbbr,
        prepareCallback(const BoutScreenActionIntent.redCaution(), const BoutScreenActionIntent.blueCaution()),
        color,
        tooltipMessage: localizations.caution,
      ),
      displayActionControl(
        localizations.dismissalAbbr,
        prepareCallback(const BoutScreenActionIntent.redDismissal(), const BoutScreenActionIntent.blueDismissal()),
        color,
        tooltipMessage: localizations.dismissal,
      ),
      if (boutConfig.activityDuration != null)
        displayActionControl(
          context.l10n.activityTimeAbbr, // AZ Activity Time, Aktivitätszeit
          prepareCallback(
            const BoutScreenActionIntent.redActivityTime(),
            const BoutScreenActionIntent.blueActivityTime(),
          ),
          color,
          tooltipMessage: localizations.activityDuration,
        ),
      if (boutConfig.injuryDuration != null)
        displayActionControl(
          context.l10n.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          prepareCallback(const BoutScreenActionIntent.redInjuryTime(), const BoutScreenActionIntent.blueInjuryTime()),
          color,
          tooltipMessage: localizations.injuryDuration,
        ),
      if (boutConfig.bleedingInjuryDuration != null)
        displayActionControl(
          context.l10n.bleedingInjuryTimeShort, // BZ Bleeding Injury Time, Verletzungszeit Blut
          prepareCallback(
            const BoutScreenActionIntent.redBleedingInjuryTime(),
            const BoutScreenActionIntent.blueBleedingInjuryTime(),
          ),
          color,
          tooltipMessage: localizations.bleedingInjuryDuration,
        ),
      displayActionControl(
        '⎌',
        prepareCallback(const BoutScreenActionIntent.redUndo(), const BoutScreenActionIntent.blueUndo()),
        color,
        tooltipMessage: '${localizations.deleteLatestAction} (⌫)',
      ),
    ];
    return IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: actions));
  }

  Widget displayActionControl(String text, void Function()? callback, MaterialColor color, {String? tooltipMessage}) {
    return Expanded(
      child: DelayedTooltip(
        message: tooltipMessage,
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
          child: ScaledText(text, fontSize: 10, minFontSize: 8, softWrap: false),
        ),
      ),
    );
  }
}
