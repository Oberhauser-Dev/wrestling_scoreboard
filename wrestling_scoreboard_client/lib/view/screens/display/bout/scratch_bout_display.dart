import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_client/view/models/scratch_event.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/home.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToScratchBoutScreen(BuildContext context) {
  context.push('/${Home.route}/${ScratchBoutDisplay.route}');
}

class ScratchBoutDisplay extends StatefulWidget {
  static const route = 'scratch';

  const ScratchBoutDisplay({super.key});

  @override
  State<ScratchBoutDisplay> createState() => _ScratchBoutDisplayState();
}

class _ScratchBoutDisplayState extends State<ScratchBoutDisplay> {
  final boutConfig = Competition.defaultBoutConfig.copyWithId(0);
  final boutResultRules = Competition.defaultBoutResultRules.indexed.map((e) => e.$2.copyWithId(e.$1)).toList();

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return ProviderScope(
      // Never retry any provider
      retry: (retryCount, error) => null,
      overrides: [
        dataManagerNotifierProvider.overrideWith(() {
          return LocalDataManagerNotifier();
        }),
        webSocketManagerNotifierProvider.overrideWith(() {
          return LocalWebsocketManagerNotifier();
        }),
      ],
      child: SingleConsumer<Bout>(
        id: 0,
        builder: (context, bout) {
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
                      final result = await showOkCancelDialog(context: context, child: Text('${localizations.reset}?'));
                      if (result && context.mounted) {
                        final dataManager = await ref.read(dataManagerNotifierProvider);
                        await dataManager.resetDatabase();
                        if (context.mounted) {
                          await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                        }
                      }
                    },
                    tooltip: localizations.reset,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed:
                        () => showOkCancelDialog(
                          context: context,
                          child: SelectableText(
                            'The settings for the scratch bout will be added in the future, see: https://github.com/Oberhauser-Dev/wrestling_scoreboard/issues/142',
                          ),
                        ),
                  ),
                ],
                navigateToBoutByIndex: (context, index) {
                  context.pop();
                },
                weightClass: WeightClass(weight: 0, style: WrestlingStyle.free),
              );
            },
          );
        },
      ),
    );
  }
}
