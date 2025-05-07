import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
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
    final localizations = context.l10n;
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;

    return LoadingBuilder<bool>(
      future: ref.watch(timeCountDownNotifierProvider),
      builder: (context, isTimeCountDown) {
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
                              onTap:
                                  () async =>
                                      (await ref.read(dataManagerNotifierProvider)).deleteSingle<BoutAction>(action),
                            ),
                            PopupMenuItem<String>(
                              child: Text(localizations.edit),
                              onTap: () async {
                                final val = await showDurationDialog(
                                  context: context,
                                  initialDuration: action.duration.invertIf(
                                    isTimeCountDown,
                                    max: boutConfig.totalPeriodDuration,
                                  ),
                                  maxValue: boutConfig.totalPeriodDuration,
                                );
                                if (val != null) {
                                  (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle<BoutAction>(
                                    action.copyWith(
                                      duration: isTimeCountDown ? boutConfig.totalPeriodDuration - val : val,
                                    ),
                                  );
                                }
                              },
                            ),
                          ];
                        },
                        tooltip:
                            (isTimeCountDown ? boutConfig.totalPeriodDuration - action.duration : action.duration)
                                .formatMinutesAndSeconds(),
                        child: ThemedContainer(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          padding: EdgeInsets.all(padding),
                          color: color,
                          child: ScaledText(action.actionValue, fontSize: 28, softWrap: false),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
