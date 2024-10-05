import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ActionsWidget extends ConsumerWidget {
  final List<BoutAction> actions;
  final BoutConfig boutConfig;

  ActionsWidget(this.actions, {required this.boutConfig, super.key}) {
    actions.sort((a, b) => a.duration.compareTo(b.duration));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...actions.map((action) {
              return SingleConsumer<BoutAction>(
                  id: action.id,
                  initialData: action,
                  builder: (context, action) {
                    final color = action.role.color();
                    return PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<String>(
                            child: Text(localizations.remove),
                            onTap: () async =>
                                (await ref.read(dataManagerNotifierProvider)).deleteSingle<BoutAction>(action),
                          ),
                          PopupMenuItem<String>(
                            child: Text(localizations.edit),
                            onTap: () async {
                              final val = await showDialog<Duration?>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DurationDialog(
                                    initialValue: action.duration,
                                    maxValue: boutConfig.totalPeriodDuration,
                                  );
                                },
                              );
                              if (val != null) {
                                (await ref.read(dataManagerNotifierProvider))
                                    .createOrUpdateSingle<BoutAction>(action.copyWith(duration: val));
                              }
                            },
                          ),
                        ];
                      },
                      tooltip: durationToString(action.duration),
                      child: ThemedContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        padding: EdgeInsets.all(padding),
                        color: color,
                        child: ScaledText(
                          action.actionValue,
                          fontSize: 28,
                          softWrap: false,
                        ),
                      ),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }
}
