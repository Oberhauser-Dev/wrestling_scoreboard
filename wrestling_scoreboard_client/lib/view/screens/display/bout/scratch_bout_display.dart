import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/home.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ScratchBoutDisplay extends StatefulWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context) {
    context.push('${Home.defaultEmptyRoute}/${ScratchBoutOverview.route}/$route');
  }

  const ScratchBoutDisplay({super.key});

  @override
  State<ScratchBoutDisplay> createState() => _ScratchBoutDisplayState();
}

class _ScratchBoutDisplayState extends State<ScratchBoutDisplay> {
  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SingleConsumer<ScratchBout>(
      id: 0,
      builder: (context, scratchBout) {
        return SingleConsumer<BoutConfig>(
          id: scratchBout.boutConfig.id,
          initialData: scratchBout.boutConfig,
          builder: (context, boutConfig) {
            return ManyConsumer<BoutResultRule, BoutConfig>(
              filterObject: boutConfig,
              builder: (context, boutResultRules) {
                return Consumer(
                  builder: (context, ref, child) {
                    return BoutScreen(
                      wrestlingEvent: ScratchEvent(),
                      officials: {},
                      boutConfig: boutConfig,
                      boutRules: boutResultRules,
                      bouts: [scratchBout.bout],
                      boutIndex: 0,
                      bout: scratchBout.bout,
                      actions: [
                        ResponsiveScaffoldActionItem(
                          icon: const Icon(Icons.restore_page),
                          onTap: () async {
                            final result = await showOkCancelDialog(
                              context: context,
                              child: Text('${localizations.reset}?'),
                            );
                            if (result && context.mounted) {
                              // FIXME: Entity is not reset when leaving the scratch provider scope (#187)
                              // Only reset entities which are displayed, but keep e.g. BoutResultRules
                              await ref.read(localDataNotifierProvider<BoutAction>().notifier).setState([]);
                              ref.invalidate(localDataNotifierProvider<BoutAction>());
                              await ref.read(localDataNotifierProvider<AthleteBoutState>().notifier).setState([]);
                              ref.invalidate(localDataNotifierProvider<AthleteBoutState>());
                              await ref.read(localDataNotifierProvider<Bout>().notifier).setState([]);
                              ref.invalidate(localDataNotifierProvider<Bout>());
                              await ref.read(localDataNotifierProvider<ScratchBout>().notifier).setState([]);
                              ref.invalidate(localDataNotifierProvider<ScratchBout>());

                              // Invalidate stream providers
                              ref.invalidate(singleDataStreamProvider<AthleteBoutState>(SingleProviderData(id: 0)));
                              ref.invalidate(singleDataStreamProvider<AthleteBoutState>(SingleProviderData(id: 1)));
                              ref.invalidate(singleDataStreamProvider<Bout>(SingleProviderData(id: 0)));
                              ref.invalidate(singleDataStreamProvider<ScratchBout>(SingleProviderData(id: 0)));
                              ref.invalidate(
                                manyDataStreamProvider<BoutAction, Bout>(
                                  ManyProviderData(filterObject: scratchBout.bout),
                                ),
                              );
                              ref.invalidate(singleDataStreamProvider<ScratchBout>(SingleProviderData(id: 0)));
                            }
                          },
                          label: localizations.reset,
                        ),
                      ],
                      navigateToBoutByIndex: (context, index) {
                        context.pop();
                      },
                      weightClass: scratchBout.weightClass,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
