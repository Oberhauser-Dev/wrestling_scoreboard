import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tooltip.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutActionControls extends StatelessWidget {
  final BoutRole role;
  final BoutConfig boutConfig;
  final WrestlingStyle? wrestlingStyle;
  final Function(Intent)? callback;

  const BoutActionControls(this.role, this.boutConfig, this.callback, {super.key, required this.wrestlingStyle});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final bool isRed = role == BoutRole.red;
    final MaterialColor color = isRed ? Colors.red : Colors.blue;
    void Function()? prepareCallback(Intent intentRed, Intent intentBlue) {
      return callback == null ? null : () => callback!(isRed ? intentRed : intentBlue);
    }

    final actions = <Widget>[
      _ActionControl(
        '1',
        prepareCallback(const RolePointBoutActionIntent.redOne(), const RolePointBoutActionIntent.blueOne()),
        color,
        tooltipMessage: '1 ${localizations.point} (${isRed ? '1 | F' : 'Numpad1 | J | ⇧ + 1'})',
      ),
      _ActionControl(
        '2',
        prepareCallback(const RolePointBoutActionIntent.redTwo(), const RolePointBoutActionIntent.blueTwo()),
        color,
        tooltipMessage: '2 ${localizations.points} (${isRed ? '2 | D' : 'Numpad2 | K | ⇧ + 2'})',
      ),
      _ActionControl(
        '4',
        prepareCallback(const RolePointBoutActionIntent.redFour(), const RolePointBoutActionIntent.blueFour()),
        color,
        tooltipMessage: '4 ${localizations.points} (${isRed ? '4 | S' : 'Numpad4 | L | ⇧ + 4'})',
      ),
      // TODO: Get character mapping from LogicalKeyboardKey before pressing it.
      // https://github.com/flutter/flutter/issues/25841
      _ActionControl(
        '5',
        prepareCallback(const RolePointBoutActionIntent.redFive(), const RolePointBoutActionIntent.blueFive()),
        color,
        tooltipMessage: '5 ${localizations.points} (${isRed ? '5 | A' : 'Numpad5 | ;/Ö | ⇧ + 5'})',
      ),
      _ActionControl(
        localizations.verbalWarningAbbr,
        prepareCallback(RoleBoutActionIntent.redVerbal(), RoleBoutActionIntent.blueVerbal()),
        color,
        tooltipMessage: localizations.verbalWarning,
      ),
      _ActionControl(
        localizations.passivityAbbr,
        prepareCallback(RoleBoutActionIntent.redPassivity(), RoleBoutActionIntent.bluePassivity()),
        color,
        tooltipMessage: localizations.passivity,
      ),
      _ActionControl(
        localizations.cautionAbbr,
        prepareCallback(RoleBoutActionIntent.redCaution(), RoleBoutActionIntent.blueCaution()),
        color,
        tooltipMessage: localizations.caution,
      ),
      _ActionControl(
        localizations.dismissalAbbr,
        prepareCallback(RoleBoutActionIntent.redDismissal(), RoleBoutActionIntent.blueDismissal()),
        color,
        tooltipMessage: localizations.dismissal,
      ),
      if (boutConfig.activityDuration != null && wrestlingStyle == WrestlingStyle.free)
        _ActionControl(
          context.l10n.activityTimeAbbr, // AZ Activity Time, Aktivitätszeit
          prepareCallback(
            const RoleScreenActionIntent.redActivityTime(),
            const RoleScreenActionIntent.blueActivityTime(),
          ),
          color,
          tooltipMessage: localizations.activityDuration,
        ),
      if (boutConfig.injuryDuration != null)
        _ActionControl(
          context.l10n.injuryTimeShort, // VZ Injury Time, Verletzungszeit
          prepareCallback(const RoleScreenActionIntent.redInjuryTime(), const RoleScreenActionIntent.blueInjuryTime()),
          color,
          tooltipMessage: localizations.injuryDuration,
        ),
      if (boutConfig.bleedingInjuryDuration != null)
        _ActionControl(
          context.l10n.bleedingInjuryTimeShort, // BZ Bleeding Injury Time, Verletzungszeit Blut
          prepareCallback(
            const RoleScreenActionIntent.redBleedingInjuryTime(),
            const RoleScreenActionIntent.blueBleedingInjuryTime(),
          ),
          color,
          tooltipMessage: localizations.bleedingInjuryDuration,
        ),
      _ActionControl(
        '⎌',
        prepareCallback(const RoleScreenActionIntent.redUndo(), const RoleScreenActionIntent.blueUndo()),
        color,
        tooltipMessage: '${localizations.deleteLatestAction} (⌫)',
      ),
    ];
    return IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: actions));
  }
}

class _ActionControl extends StatelessWidget {
  final String text;
  final VoidCallback? callback;
  final MaterialColor color;
  final String? tooltipMessage;

  const _ActionControl(this.text, this.callback, this.color, {this.tooltipMessage});

  @override
  Widget build(BuildContext context) {
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
