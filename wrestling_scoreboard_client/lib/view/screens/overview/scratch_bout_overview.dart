import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/scratch_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/scratch_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/home.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_config_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension ScratchBoutRouteExtension on GoRouterState {
  bool get isScratchBoutRoute => uri.path.startsWith('${Home.defaultEmptyRoute}/${ScratchBoutOverview.route}');
}

class ScratchBoutOverview extends ConsumerWidget with BoutOverview<ScratchBout>, BoutConfigOverviewTab {
  static const route = 'scratch';

  static void navigateTo(BuildContext context, WidgetRef ref, {BoutConfig? boutConfig}) async {
    if (boutConfig != null) {
      List<BoutResultRule>? boutResultRules;
      if (boutConfig.id != null) {
        boutResultRules = await ref.readAsync(
          manyDataStreamProvider<BoutResultRule, BoutConfig>(ManyProviderData(filterObject: boutConfig)).future,
        );
        // Can override id with local static id, once the result rules have been fetched.
        boutConfig = boutConfig.copyWithId(0);
        // Cannot use LocaDataManager as it depends on dataManagerProvider internally, which would require a ProviderScope.
        // This provider scope is not feasible here as we request the original result rules from the default provider.
        // Therefore we directly manipulate the local data.
        await ref.read(localDataNotifierProvider<BoutConfig>().notifier).setState([boutConfig]);
        ref.invalidate(localDataNotifierProvider<BoutConfig>());
        // We just assume we can override every bout config & bout result rule without checking the dependency on existing bout configs.
        if (boutResultRules != null && boutResultRules.isNotEmpty) {
          await ref
              .read(localDataNotifierProvider<BoutResultRule>().notifier)
              .setState(boutResultRules.map((e) => e.copyWith(/*id: null,*/ boutConfig: boutConfig!)).toList());
          ref.invalidate(localDataNotifierProvider<BoutResultRule>());
        }
      }
    }
    if (context.mounted) context.push('${Home.defaultEmptyRoute}/$route');
  }

  const ScratchBoutOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                final (boutConfigTab, boutConfigTabContent) = buildTab(context, initialData: boutConfig);
                return buildOverview(
                  context,
                  ref,
                  classLocale: localizations.bout,
                  details: '${bout.r?.membership.person.fullName} - ${bout.b?.membership.person.fullName}',
                  editPage: ScratchBoutEdit(scratchBout: scratchBout),
                  actions: [
                    ResponsiveScaffoldActionItem(
                      style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
                      icon: const Icon(Icons.tv),
                      onTap: () => ScratchBoutDisplay.navigateTo(context),
                      label: localizations.display,
                    ),
                  ],
                  tiles: [
                    ContentItem(
                      title: scratchBout.weightClass.localize(context),
                      subtitle: localizations.weightClass,
                      icon: Icons.label,
                    ),
                  ],
                  dataId: bout.id!,
                  initialData: bout,
                  subClassData: scratchBout,
                  buildRelations: (boutConfig) => {boutConfigTab: boutConfigTabContent},
                  boutConfig: boutConfig,
                  onDelete: () {},
                );
              },
            );
          },
        );
      },
    );
  }
}

class ScratchBoutProviderScope extends StatelessWidget {
  final Widget child;

  const ScratchBoutProviderScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: Container(padding: const EdgeInsets.all(1.0), color: Theme.of(context).colorScheme.primary, child: child),
    );
  }
}
