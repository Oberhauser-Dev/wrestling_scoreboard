import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractOverview<T extends DataObject, E extends DataObject> {
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    List<Widget> actions = const [],
    required int dataId,
    T? initialData,
    Map<Tab, Widget> Function(T data)? buildRelations,
    required E subClassData,
  });
}

abstract class AbstractOverviewTab<T extends DataObject> {
  Future<void> onDelete(BuildContext context, WidgetRef ref, {required T single});

  (Tab, Widget) buildTab(BuildContext context, {required T initialData});
}

class AppBarTitle extends StatelessWidget {
  final String label;
  final String details;

  const AppBarTitle({super.key, required this.label, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(child: Text(label, overflow: TextOverflow.fade)),
        Expanded(
          child: Text(
            '  $details',
            style: TextStyle(color: Theme.of(context).disabledColor),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}

class FavoriteScaffold<T extends DataObject> extends ConsumerWidget {
  const FavoriteScaffold({
    super.key,
    required this.dataObject,
    required this.body,
    required this.label,
    required this.details,
    required this.tabs,
    this.actions,
  });

  final Widget body;
  final String label;
  final String details;
  final List<Tab> tabs;
  final List<Widget>? actions;
  final T dataObject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final tableName = getTableNameFromType(T);
    return OverviewScaffold(
      body: this.body,
      details: this.details,
      label: this.label,
      tabs: this.tabs,
      actions: [
        ...?this.actions,
        LoadingBuilder(
          future: ref.watch(favoritesNotifierProvider),
          builder: (BuildContext context, favorites) {
            final isFavorite = favorites[tableName]?.contains(dataObject.id) ?? false;
            return IconButton(
              onPressed: () {
                final notifier = ref.read(favoritesNotifierProvider.notifier);
                if (isFavorite) {
                  notifier.removeFavorite(tableName, dataObject.id!);
                } else {
                  notifier.addFavorite(tableName, dataObject.id!);
                }
              },
              icon: isFavorite ? const Icon(Icons.star) : const Icon(Icons.star_outline),
              tooltip: localizations.favorite,
            );
          },
        ),
      ],
    );
  }
}

class OverviewScaffold extends ConsumerWidget {
  const OverviewScaffold({
    super.key,
    required this.body,
    required this.label,
    required this.details,
    required this.tabs,
    this.actions,
  });

  final Widget body;
  final String label;
  final String details;
  final List<Tab> tabs;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: WindowStateScaffold(
        appBarTitle: AppBarTitle(label: label, details: details),
        appBarBottom: TabBar(tabs: tabs, tabAlignment: TabAlignment.center, isScrollable: true),
        actions: [...?actions],
        body: body,
      ),
    );
  }
}
