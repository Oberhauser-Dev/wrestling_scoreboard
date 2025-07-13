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
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToScratchBoutDisplay(BuildContext context) {
  context.push('/${Home.route}/${ScratchBoutOverview.route}/${ScratchBoutDisplay.route}');
}

class ScratchBoutDisplay extends StatefulWidget {
  static const route = 'display';

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
        return SingleConsumer<Bout>(
          id: scratchBout.bout.id,
          initialData: scratchBout.bout,
          builder: (context, bout) {
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
                          boutConfig: boutConfig,
                          boutRules: boutResultRules,
                          bouts: [bout],
                          boutIndex: 0,
                          bout: bout,
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.restore_page),
                              onPressed: () async {
                                final result = await showOkCancelDialog(
                                  context: context,
                                  child: Text('${localizations.reset}?'),
                                );
                                if (result && context.mounted) {
                                  // Some hacky way to refresh the page:
                                  // - family providers such as manyDataStream cannot be invalidated that easily
                                  // - invalidating / refreshing the localDataProvider does not lead to refreshing its dependent providers / the Consumers unless they are actively loaded
                                  // - setState does not force the Consumers to be refreshed.
                                  context.pop();

                                  // Need to call invalidation between pop and navigating back, otherwise it will get saved while popping (data safety feature of BoutScreen).
                                  // Only reset entities which are displayed, but keep e.g. BoutResultRules
                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                    await ref.read(localDataNotifierProvider<BoutAction>().notifier).setState([]);
                                    ref.invalidate(localDataNotifierProvider<BoutAction>());
                                    await ref.read(localDataNotifierProvider<AthleteBoutState>().notifier).setState([]);
                                    ref.invalidate(localDataNotifierProvider<AthleteBoutState>());
                                    await ref.read(localDataNotifierProvider<Bout>().notifier).setState([]);
                                    ref.invalidate(localDataNotifierProvider<Bout>());

                                    // Invalidate stream providers
                                    ref.invalidate(singleDataStreamProvider<ScratchBout>(SingleProviderData(id: 0)));
                                    ref.invalidate(
                                      singleDataStreamProvider<AthleteBoutState>(SingleProviderData(id: 0)),
                                    );
                                    ref.invalidate(
                                      singleDataStreamProvider<AthleteBoutState>(SingleProviderData(id: 1)),
                                    );
                                    ref.invalidate(singleDataStreamProvider<Bout>(SingleProviderData(id: 0)));
                                    ref.invalidate(
                                      manyDataStreamProvider<BoutAction, Bout>(ManyProviderData(filterObject: bout)),
                                    );

                                    if (context.mounted) {
                                      navigateToScratchBoutDisplay(context);
                                    }
                                  });
                                }
                              },
                              tooltip: localizations.reset,
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
      },
    );
  }
}
