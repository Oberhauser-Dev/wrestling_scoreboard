import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionParticipationItem extends ConsumerWidget {
  final CompetitionParticipation participation;

  const CompetitionParticipationItem({
    super.key,
    required this.participation,
  });

  displayName({AthleteBoutState? pStatus, required BoutRole role, double? fontSize, required BuildContext context}) {
    return ThemedContainer(
      color: role.color(),
      child: Center(
        child: ScaledText(
          pStatus == null ? context.l10n.participantVacant : pStatus.membership.person.fullName,
          color: pStatus == null ? Colors.white.disabled() : Colors.white,
          fontSize: 17,
          minFontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer<CompetitionParticipation>(
        initialData: participation,
        id: participation.id,
        builder: (context, bout) {
          return Row(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        if (ageCategory != null)
                          Center(
                            child: ScaledText(
                              ageCategory!.name,
                              minFontSize: 8,
                            ),
                          ),
                        if (weightClass != null)
                          Expanded(
                            child: Center(
                              child: ScaledText(
                                '${weightClass!.weight} $weightUnit',
                                softWrap: false,
                                minFontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (weightClass != null)
                    Expanded(
                      child: Center(
                        child: ScaledText(
                          weightClass!.style.abbreviation(context),
                          minFontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              displayName(pStatus: bout.r, role: BoutRole.red, context: context),
              SmallBoutStateDisplay(bout: bout, boutConfig: boutConfig),
              displayName(pStatus: bout.b, role: BoutRole.blue, context: context),
            ].asMap().entries.map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value)).toList(),
          );
        });
  }
}
